import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/widgets/ui_elements/logout_list_tile.dart';
import 'package:scoped_model/scoped_model.dart';

import '../widgets/products/products.dart';
import '../scoped_model/main_scoped_model.dart';

class ProductsPage extends StatefulWidget {
  final MainScopedModel model;
  ProductsPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ProductPageState();
  }
}

class _ProductPageState extends State<ProductsPage> {
  @override
  initState() {
    widget.model.fetchDataFromServer();
    super.initState();
  }

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Choose'),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/admin');
            },
          ),
          Divider(),
          LogoutListTile(),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainScopedModel model) {
      Widget content = Center(
        child: Text('No products found'),
      );
      if (model.displayedProducts.length > 0 && !model.isLoading) {
        content = Products();
      } else if (model.isLoading) {
        content = Center(
          child: CircularProgressIndicator(),
        );
      }
      return RefreshIndicator(
          child: content, onRefresh: model.fetchDataFromServer);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: AppBar(
        title: Text('EasyList'),
        actions: [
          ScopedModelDescendant<MainScopedModel>(builder:
              (BuildContext context, Widget child, MainScopedModel model) {
            return IconButton(
              icon: Icon(model.displayFavoritesOnly
                  ? Icons.favorite
                  : Icons.favorite_border),
              onPressed: () {
                model.toggleDisplayMode();
              },
            );
          })
        ],
      ),
      body: _buildProductList(),
    );
  }
}
