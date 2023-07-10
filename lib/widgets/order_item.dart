import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop_app/provider/orders.dart' as ord;
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  const OrderItem({required this.order, super.key});

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height:
          _expanded ? min(widget.order.products.length * 20.0 + 200, 250) : 108,
      child: Card(
        margin: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            children: [
              ListTile(
                title: Text(
                  'Total: Rs ${widget.order.amount.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
                  style: const TextStyle(color: Colors.grey),
                ),
                trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                  icon: _expanded
                      ? const Icon(Icons.expand_less)
                      : const Icon(Icons.expand_more),
                ),
              ),
              if (_expanded) const Divider(),
              AnimatedContainer(
                height: _expanded
                    ? min(widget.order.products.length * 20.0 + 50, 150)
                    : 0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeIn,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 4,
                ),
                child: ListView(
                  children: widget.order.products
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 4,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                e.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${e.quantity}x   Rs ${e.price}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );

    // child: Card(
    //   margin: const EdgeInsets.all(10.0),
    //   child: Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: Column(
    //       children: [
    //         ListTile(
    //           title: Text(
    //             'Total: Rs ${widget.order.amount.toStringAsFixed(2)}',
    //             style: const TextStyle(fontWeight: FontWeight.bold),
    //           ),
    //           subtitle: Text(
    //             DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
    //             style: const TextStyle(color: Colors.grey),
    //           ),
    //           trailing: IconButton(
    //             onPressed: () {
    //               setState(() {
    //                 _expanded = !_expanded;
    //               });
    //             },
    //             icon: _expanded
    //                 ? const Icon(Icons.expand_less)
    //                 : const Icon(Icons.expand_more),
    //           ),
    //         ),
    //         if (_expanded) const Divider(),

    //           AnimatedContainer(
    //             height: _expanded
    //                 ? min(widget.order.products.length * 20.0 + 10, 100)
    //                 : 0,
    //             duration: const Duration(milliseconds: 300),
    //             curve: Curves.easeIn,
    //             padding: const EdgeInsets.symmetric(
    //               horizontal: 15,
    //               vertical: 4,
    //             ),
    //             child: ListView(
    //               children: widget.order.products
    //                   .map(
    //                     (e) => Padding(
    //                       padding: const EdgeInsets.symmetric(
    //                         horizontal: 15,
    //                         vertical: 4,
    //                       ),
    //                       child: Row(
    //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                         children: [
    //                           Text(
    //                             e.title,
    //                             style: const TextStyle(
    //                               fontSize: 18,
    //                               fontWeight: FontWeight.bold,
    //                             ),
    //                           ),
    //                           Text(
    //                             '${e.quantity}x   Rs ${e.price}',
    //                             style: const TextStyle(
    //                               fontSize: 18,
    //                               color: Colors.grey,
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   )
    //                   .toList(),
    //             ),
    //           )
    //       ],
    //     ),
    //   ),
    // ),
    //);
  }
}
