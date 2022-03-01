import 'package:flutter/material.dart';
import "package:provider/provider.dart";

import './screens/products_overview_screen.dart';
import "./screens/auth_screen.dart";
import "./screens/edit_products_screen.dart";
import "./screens/product_detail_screen.dart";
import "./screens/cart_screen.dart";
import "./screens/orders_screen.dart";
import "./screens/user_products_screen.dart";
import "./screens/splash_screen.dart";

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
        ChangeNotifierProxyProvider<Auth, Products>( 
          update: (ctx, auth, previousProducts) => Products(
            auth.token,
            auth.userId,
            previousProducts == null
              ? []
              : previousProducts.items
            ),
          // create: (ctx) => Products(),
          // value: Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          // create: (ctx) => Orders(),
          update: (ctx, auth, previousOrders) => Orders(
            auth.token,
            auth.userId,
            previousOrders == null 
              ? []
              : previousOrders.orders
            ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Shopee',
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
            colorScheme: ThemeData().colorScheme.copyWith(
              primary: Colors.deepOrange,
              secondary: Colors.blue[900],
            ),
            fontFamily: "Lato",
          ),
          home: auth.isAuth 
          ? ProductsOverview()
          : FutureBuilder(
              future: auth.tryAutoLogin(),
              builder: (ctx, authResultSnapshot) => 
              authResultSnapshot.connectionState == ConnectionState.waiting
              ? SplashScreen()
              : AuthScreen(),
            ),
          routes: {
            ProductDetail.routeName: (ctx) => ProductDetail(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
