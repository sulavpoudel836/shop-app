import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/product.dart';
import 'package:shop_app/widgets/cart_badge.dart';

import '../provider/auth.dart';
import '../screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);

    final cart = Provider.of<Cart>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx_, products, Widget? _) {
              return IconButton(
                onPressed: () async {
                  try {
                    await products.toggleFavourite(
                      auth.token,
                      auth.userId,
                    );
                  } catch (error) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(error.toString()),
                      ),
                    );
                  }
                },
                icon: products.isFavourite
                    ? const Icon(Icons.favorite)
                    : const Icon(Icons.favorite_border),
                color: Theme.of(context).colorScheme.secondary,
              );
            },
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            onPressed: () {
              cart.addCartItem(product.id, product.title, product.price);
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
            icon: cart.items.containsKey(product.id)
                ? CartBadge(
                    value: cart.items[product.id]!.quantity.toString(),
                    child: IconButton(
                      icon: Icon(
                        Icons.shopping_cart,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      onPressed: null,
                    ),
                  )
                : CartBadge(
                    value: 0.toString(),
                    child: IconButton(
                      icon: Icon(
                        Icons.shopping_cart,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      onPressed: null,
                    ),
                  ),
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailsScreen.routeName,
              arguments: product.id,
            );
          },
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: const AssetImage('assets/images/white.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
