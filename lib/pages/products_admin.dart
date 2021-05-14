import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'product_edit.dart';
import '../pages/product_list.dart';

class ProductsAdminPage extends StatelessWidget {
  final Function addProduct;
  final Function updateProduct;
  final Function deleteProduct;
  final List<Map<String, dynamic>> products;

  ProductsAdminPage(this.addProduct, this.updateProduct, this.deleteProduct, this.products);

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Choose'),
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('All Products'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/productPage');
            },
          )
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text('Manage Products'),
      bottom: TabBar(
        tabs: [
          Tab(
            text: 'Create Product',
            icon: Icon(Icons.create),
          ),
          Tab(
            text: 'Manage Product',
            icon: Icon(Icons.list),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: _buildDrawer(context),
        appBar: _buildAppBar(),
        body: TabBarView(
          children: [
            ProductEditPage(addProduct: addProduct),
            ProductListPage(products, updateProduct, deleteProduct)
          ],
        ),
      ),
    );
  }
}
