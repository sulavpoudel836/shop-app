import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_add_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/manage_product_item.dart';

import '../provider/products_provider.dart';

class ManageProductScreen extends StatefulWidget {
  static const routeName = '/manage-product';
  const ManageProductScreen({super.key});

  @override
  State<ManageProductScreen> createState() => _ManageProductScreenState();
}

class _ManageProductScreenState extends State<ManageProductScreen> {
  var _isLoading = false;
  var _isUnavailable = false;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<ProductsProvider>(context, listen: false)
          .fetchAndSetProducts(true)
          .catchError((error) {
        setState(() {
          _isUnavailable = true;
        });
      });
      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
  }

  Future<void> _refreshPage(BuildContext context) async {
    try {
      await Provider.of<ProductsProvider>(context, listen: false)
          .fetchAndSetProducts(true);
    } catch (error) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('An error occurred!'),
          content: const Text('No products available.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var product = Provider.of<ProductsProvider>(context).items;
    return Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          title: const Text('Manage Product'),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => _refreshPage(context),
                child: (product.isEmpty || _isUnavailable)
                    ? const Center(child: Text('No products to manage.'))
                    : ListView.builder(
                        itemCount: product.length,
                        itemBuilder: (context, index) {
                          return ManageProductItem(
                            image: product[index].imageUrl,
                            title: product[index].title,
                            price: product[index].price,
                            productId: product[index].id,
                          );
                        },
                      ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(EditAddProductScreen.routeName);
          },
          child: const Icon(Icons.add),
        ));
  }
}
