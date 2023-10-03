import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/product_item.dart';

import '../provider/product.dart';

class BuildProductsOverviewGridview extends StatelessWidget {
  final List<Product> products;
  const BuildProductsOverviewGridview(
    this.products, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // final products = showSearch
    //     ? Provider.of<ProductsProvider>(context).searchItems
    //     : showFav
    //         ? Provider.of<ProductsProvider>(context).favourites
    //         : Provider.of<ProductsProvider>(context).items;
    return GridView.builder(
      // GridView.builder is a better choice than GridView.count
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 3 / 2,
      ),
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
          // create: (context) {
          //   return products[index];
          // },
          value: products[index],
          child: const ProductItem(
              // imageUrl: products[index].imageUrl,
              // id: products[index].id,
              // title: products[index].title,
              ),
        );
      },
      itemCount: products.length,
    );
  }
}
