import 'package:flutter/material.dart';
import "package:provider/provider.dart";

import "./screens/products_overview_screen.dart";
import "./screens/product_detail_screen.dart";
import "./providers/products_provider.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider( // .value is NOT preferrable here
      create: (ctx) => Products(), // because we're instantiating a class (Products())
      // value: Products(),
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
        home: ProductsOverview(),
        routes: {
          ProductDetail.routeName: (ctx) => ProductDetail(),
        },
      ),
    );
  }
}
