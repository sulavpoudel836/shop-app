// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shop_app/provider/products_provider.dart';

// import '../widgets/products_overview_gridview.dart';

// class ProductsSearchScreen extends StatefulWidget {
//   static const routeName = '/products-search';
//   const ProductsSearchScreen({super.key});

//   @override
//   State<ProductsSearchScreen> createState() => _ProductsSearchScreenState();
// }

// class _ProductsSearchScreenState extends State<ProductsSearchScreen> {
//   // final _showFav = false;/
//   var _isInit = true;
//   var _isLoading = false;
//   var _isUnavailable = false;

//   @override
//   void didChangeDependencies() {
//     if (_isInit) {
//       setState(() {
//         _isLoading = true;
//       });
//       Provider.of<ProductsProvider>(context)
//           .fetchAndSetProductsBySearch('search')
//           .catchError((error) {
//         _isUnavailable = true;
//       }).then((_) {
//         setState(() {
//           _isLoading = false;
//         });
//       });
//     }
//     _isInit = false;
//     super.didChangeDependencies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final productsData = Provider.of<ProductsProvider>(context);
//     final products = productsData.items;
//     return Scaffold(
//       appBar: AppBar(
//         title:
//             //searchbox
//             const TextField(
//           decoration: InputDecoration(
//             hintText: 'Search',
//             hintStyle: TextStyle(color: Colors.white),
//             suffixIcon: Icon(Icons.search),
//           ),
//         ),
//       ),
//       body: _isLoading
//           ? const Center(
//               child: CircularProgressIndicator(),
//             )
//           : (_isUnavailable
//               ? const Center(
//                   child: Text('No products available.'),
//                 )
//               : const BuildProductsOverviewGridview(false, true)),
//     );
//   }
// }
