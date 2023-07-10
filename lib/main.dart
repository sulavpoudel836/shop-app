import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/auth.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/orders.dart';
import 'package:shop_app/provider/products_provider.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_add_product_screen.dart';
import 'package:shop_app/screens/manage_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';

import 'screens/product_details_screen.dart';
import 'screens/splash-screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context) {
          return Auth();
        }),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          create: (BuildContext context) {
            return ProductsProvider('', '', []);
          },
          update: (BuildContext context, Auth auth, ProductsProvider? prev) {
            return ProductsProvider(
              auth.token,
              auth.userId,
              prev == null ? [] : prev.items,
            );
          },
        ),
        // ChangeNotifierProvider(create: (BuildContext context) {
        //   return ProductsProvider();
        // }),
        ChangeNotifierProvider(create: (BuildContext context) {
          return Cart();
        }),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (BuildContext context) {
            return Orders('', '', []);
          },
          update: (BuildContext context, Auth auth, Orders? prev) {
            return Orders(
              auth.token,
              auth.userId,
              prev == null ? [] : prev.orders,
            );
          },
        ),
        // ChangeNotifierProvider(create: (BuildContext context) {
        //   return Orders();
        // }),
      ],
      child: Consumer<Auth>(
        builder: (BuildContext context, Auth auth, Widget? _) {
          return MaterialApp(
            title: 'shop App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              colorScheme: const ColorScheme.light().copyWith(
                secondary: Colors.deepOrange,
              ),
              fontFamily: 'Lato',
              textTheme: ThemeData.light().textTheme.copyWith(
                    titleLarge: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            ),
            home: auth.isAuth
                ? const ProductsOverviewScreen()
                : FutureBuilder(
                    future: auth.autoLogin(),
                    builder: (ctx, autologinSnapshot) {
                      if (autologinSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const SplashScreen();
                      } else {
                        return const AuthScreen();
                      }
                    }),
            routes: {
              ProductsOverviewScreen.routeName: (context) =>
                  const ProductsOverviewScreen(),
              ProductDetailsScreen.routeName: (ctx) =>
                  const ProductDetailsScreen(),
              CartScreen.routeName: (context) => const CartScreen(),
              OrderScreen.routeName: (context) => const OrderScreen(),
              ManageProductScreen.routeName: (context) =>
                  const ManageProductScreen(),
              EditAddProductScreen.routeName: (context) =>
                  const EditAddProductScreen(),
            },
          );
        },
      ),
    );
  }
}
