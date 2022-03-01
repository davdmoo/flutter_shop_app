import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../screens/cart_screen.dart";
import "../widgets/products_grid.dart";
import "../widgets/badge.dart";
import "../widgets/main_drawer.dart";
import "../providers/cart.dart";
import "../providers/products_provider.dart";

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverview extends StatefulWidget {
  static const routeName = "/products-overview";

  @override
  State<ProductsOverview> createState() => _ProductsOverviewState();
}

class _ProductsOverviewState extends State<ProductsOverview> {
  var _showOnlyFavorites = false;
  var _isInit = false;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();

    _isInit = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      
      Provider.of<Products>(context).fetchProducts()
        .then((_) {
          setState(() {
            _isLoading = false;
          });
        })
        .catchError((error) {

        });
    }

    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopee"),
        actions: <Widget>[
          Consumer<Cart> (
            builder:(_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            // this below refers to ch -> won't rebuild because defined outside the builder
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Only favorites"),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text("Show all"),
                value: FilterOptions.All,
              ),
            ],
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: _isLoading 
      ? Center(
          child: CircularProgressIndicator()
        )
      : ProductsGrid(_showOnlyFavorites),
    );
  }
}