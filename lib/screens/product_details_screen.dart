import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products_provider.dart';
import 'package:shop_app/widgets/cart_badge.dart';

import '../provider/cart.dart';
import 'cart_screen.dart';

class ProductDetailsScreen extends StatelessWidget {
  // final String title;
  // final String imageUrl;
  // final String id;
  // const ProductDetailsScreen({
  //   required this.id,
  //   required this.imageUrl,
  //   required this.title,
  //   super.key,
  // });
  static const routeName = '/product-details';

  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final String id = ModalRoute.of(context)!.settings.arguments as String;
    final product = Provider.of<ProductsProvider>(
      context,
      listen: false,
    ).findById(id);

    return Scaffold(
      // drawer: const AppDrawer(),
      // appBar: AppBar(
      //   title: Text(product.title),
      //   actions: [
      //     Container(
      //       padding: const EdgeInsets.only(
      //         right: 8,
      //         top: 8,
      //         bottom: 8,
      //         left: 0,
      //       ),
      //       child: Consumer<Cart>(
      //         builder: (context, value, ch) => CartBadge(
      //           value: cart.itemCount.toString(),
      //           color: Colors.orange,
      //           child: ch!,
      //         ),
      //         child: IconButton(
      //           icon: const Icon(
      //             Icons.shopping_cart,
      //             color: Colors.white,
      //           ),
      //           // ignore: avoid_returning_null_for_void
      //           onPressed: () {
      //             Navigator.of(context).pushNamed(CartScreen.routeName);
      //           },
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                product.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              background: Hero(
                tag: product.id,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            actions: [
              Container(
                padding: const EdgeInsets.only(
                  right: 8,
                  top: 8,
                  bottom: 8,
                  left: 0,
                ),
                child: Consumer<Cart>(
                  builder: (context, value, ch) => CartBadge(
                    value: cart.itemCount.toString(),
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
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    'Rs ${product.price}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    product.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
                const SizedBox(
                  height: 800,
                )
              ],
            ),
          )
        ],
        // child: Column(
        //   children: [
        //     SizedBox(
        //       height: 300,
        //       width: double.infinity,
        //       child: Hero(
        //         tag: product.id,
        //         child: Image.network(
        //           product.imageUrl,
        //           fit: BoxFit.cover,
        //         ),
        //       ),
        //     ),
        //     const SizedBox(
        //       height: 10,
        //     ),
        //     Text(
        //       'Rs ${product.price}',
        //       style: const TextStyle(
        //         color: Colors.grey,
        //         fontSize: 20,
        //       ),
        //     ),
        //     const SizedBox(
        //       height: 10,
        //     ),
        //     Container(
        //       padding: const EdgeInsets.symmetric(horizontal: 10),
        //       width: double.infinity,
        //       child: Text(
        //         product.description,
        //         textAlign: TextAlign.center,
        //         softWrap: true,
        //       ),
        //     ),
        //   ],
        // ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          cart.addCartItem(
            product.id,
            product.title,
            product.price,
          );
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Added item to cart'),
              duration: const Duration(seconds: 2),
              action: SnackBarAction(
                label: 'UNDO',
                onPressed: () {
                  cart.removeSingleItem(product.id);
                },
              ),
            ),
          );
        },
        child: CartBadge(
          value: cart.items.containsKey(product.id)
              ? cart.items[product.id]!.quantity.toString()
              : '0',
          child: const Icon(Icons.shopping_cart),
        ),
      ),
    );
  }
}
