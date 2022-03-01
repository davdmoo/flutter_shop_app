import 'package:flutter/material.dart';
import "package:provider/provider.dart";

import "./screens/auth_screen.dart";
import "./screens/edit_products_screen.dart";
import "./screens/product_detail_screen.dart";
import "./screens/cart_screen.dart";
import "./screens/orders_screen.dart";
import "./screens/user_products_screen.dart";
import "./providers/products_provider.dart";
import "./providers/cart.dart";
import "./providers/orders.dart";
import './providers/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        // .value is NOT preferrable here because a class is instantiated (Products())
        ChangeNotifierProvider( 
          create: (ctx) => Products(),
          // value: Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        ),
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          colorScheme: ThemeData().colorScheme.copyWith(
            primary: Colors.deepOrange,
            secondary: Colors.blue[900],
          ),
          fontFamily: "Lato",
        ),
        home: AuthScreen(),
        routes: {
          ProductDetail.routeName: (ctx) => ProductDetail(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
        },
      ),
    );
  }
}
