import 'package:flutter/material.dart';

import "./screens/products_overview_screen.dart";
import "./screens/product_detail_screen.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyShop',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        accentColor: Colors.blue[900],
        fontFamily: "Lato",
      ),
      home: ProductsOverview(),
      routes: {
        ProductDetail.routeName: (ctx) => ProductDetail(),
      },
    );
  }
}
