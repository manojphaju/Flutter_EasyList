import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../pages/product_create.dart';
import '../pages/product_list.dart';

class ProductsAdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          drawer: Drawer(
            child: Column(
              children: [
                AppBar(
                  automaticallyImplyLeading: false,
                  title: Text('Choose'),
                ),
                ListTile(
                  title: Text('All Products'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/admin');
                  },
                )
              ],
            ),
          ),
          appBar: AppBar(
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
          ),
          body: TabBarView(
            children: [ProductCreatePage(), ProductListPage()],
          )),
    );
  }
}
