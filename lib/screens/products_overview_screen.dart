import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/products_provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/cart_badge.dart';

import '../provider/auth.dart';
import '../widgets/products_overview_gridview.dart';

enum FilterGrid {
  favourites,
  all,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/products-overview';
  final bool isAuth;
  const ProductsOverviewScreen({super.key, required this.isAuth});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showSearch = false;
  var _showFav = false;
  var _isInit = true;
  var _isLoading = false;
  var _isUnavailable = false;
  bool isSearching = false;
  final FocusNode _searchFocus = FocusNode();
  String searchedData = "";

  @override
  void dispose() {
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductsProvider>(context)
          .fetchAndSetProducts()
          .catchError((error) {
        // showDialog<void>(
        //   context: context,
        //   builder: (ctx) => AlertDialog(
        //     title: const Text('An error occurred!'),
        //     content: const Text('No products available.'),
        //     actions: [
        //       TextButton(
        //         onPressed: () {
        //           setState(() {
        _isUnavailable = true;
        //             Navigator.of(context).pop();
        //           });
        //         },
        //         child: const Text('Okay'),
        //       ),
        //     ],
        //   ),
        // );
      }).then(
        (value) => setState(
          () {
            _isLoading = false;
          },
        ),
      );
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
   
    var auth = Provider.of<Auth>(context);
    var userId = auth.userId;
    var token = auth.token;
    var cartItemCount = Provider.of<Cart>(context).itemCount;

    final products = _showSearch
        ? Provider.of<ProductsProvider>(context).searchItems
        : _showFav
            ? Provider.of<ProductsProvider>(context).favourites
            : Provider.of<ProductsProvider>(context).items;

    if (products.isEmpty) {
      setState(() {
        _isUnavailable = true;
      });
    } else {
      setState(() {
        _isUnavailable = false;
      });
    }

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: isSearching ? _buildSearchField() : const Text('Shop App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                _showSearch = false;
              });
              if (isSearching) {
                _searchFocus.requestFocus();
              } else {
                searchedData = "";
                _searchFocus.unfocus();
              }
            },
          ),
          if (userId.isNotEmpty || token.isNotEmpty)
            PopupMenuButton(
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    value: FilterGrid.favourites,
                    child: Text('Only Favourites'),
                  ),
                  const PopupMenuItem(
                    value: FilterGrid.all,
                    child: Text('All'),
                  ),
                ];
              },
              onSelected: (FilterGrid value) {
                setState(() {
                  if (value == FilterGrid.favourites) {
                    _showFav = true;
                  } else {
                    _showFav = false;
                  }
                });
              },
            ),
          Container(
            padding: const EdgeInsets.only(
              right: 8,
              top: 8,
              bottom: 8,
              left: 0,
            ),
            child: Consumer<Cart>(
              builder: (context, value, ch) => CartBadge(
                value: cartItemCount.toString(),
                color: Colors.orange,
                child: ch!,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                // ignore: avoid_returning_null_for_void
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : (_isUnavailable
              ? const Center(
                  child: Text('No products available.'),
                )
              : BuildProductsOverviewGridview(products)),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      focusNode: _searchFocus,
      decoration: InputDecoration(
        hintText: 'Search...',
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        hintStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            setState(() {
              isSearching = false;
              _showSearch = false;
            });
          },
        ),
      ),
      textInputAction: TextInputAction.search,
      onSubmitted: (value) {
        setState(() {
          _isLoading = true;
          _showSearch = true;
        });
        Provider.of<ProductsProvider>(context, listen: false)
            .fetchAndSetProducts(false, value)
            .catchError((error) {
          _isUnavailable = true;
        }).then(
          (value) => setState(
            () {
              _isLoading = false;
            },
          ),
        );
      },
    );
  }
}
