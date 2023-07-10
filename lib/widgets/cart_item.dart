import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart';
import '../screens/product_details_screen.dart';

class CartItem extends StatelessWidget {
  final String id;
  final double price;
  final String title;
  final int quantity;
  final String productId;
  const CartItem({
    required this.id,
    required this.price,
    required this.title,
    required this.quantity,
    required this.productId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
      child: Dismissible(
        key: ValueKey(id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 15.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.error,
            borderRadius: BorderRadius.circular(4.0),
          ),
          // margin: const EdgeInsets.symmetric(
          //   // horizontal: 15.0,
          //   vertical: 4.0,
          // ),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
            size: 40.0,
          ),
        ),
        onDismissed: (direction) {
          Provider.of<Cart>(context, listen: false).removeItem(productId);
        },
        confirmDismiss: (direction) {
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Are you sure?'),
              content:
                  const Text('Do you want to remove the item from the cart?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                  child: const Text('Yes'),
                ),
              ],
            ),
          );
        },
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailsScreen.routeName,
              arguments: productId,
            );
          },
          child: Card(
            margin: EdgeInsets.zero,
            child: ListTile(
              leading: CircleAvatar(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: FittedBox(
                    child: Text('$price'),
                  ),
                ),
              ),
              title: Text(title),
              subtitle:
                  Text('Total: Rs ${(price * quantity).toStringAsFixed(2)}'),
              trailing: SizedBox(
                width: 110,
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  IconButton(
                    onPressed: () {
                      Provider.of<Cart>(context, listen: false)
                          .removeSingleItem(productId);
                    },
                    icon: const Icon(Icons.remove),
                  ),
                  FittedBox(fit: BoxFit.scaleDown, child: Text('$quantity')),
                  Expanded(
                    child: IconButton(
                      onPressed: () {
                        Provider.of<Cart>(context, listen: false)
                            .addCartItem(productId, title, price);
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
