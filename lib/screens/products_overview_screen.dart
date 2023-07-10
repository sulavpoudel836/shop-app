import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/products_provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/cart_badge.dart';

import '../widgets/products_overview_gridview.dart';

enum FilterGrid {
  favourites,
  all,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/products-overview';
  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showFav = false;
  var _isInit = true;
  var _isLoading = false;
  var _isUnavailable = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductsProvider>(context)
          .fetchAndSetProducts(true)
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
    var cartItemCount = Provider.of<Cart>(context).itemCount;
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Shop App'),
        actions: [
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
              : BuildProductsOverviewGridview(_showFav)),
    );
  }
}
