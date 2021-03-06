import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../pages/product_edit.dart';
import 'package:flutter_course/scoped_model/main_scoped_model.dart';

class ProductListPage extends StatefulWidget {
  final MainScopedModel model;
  ProductListPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ProductListPageState();
  }
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  initState() {
    widget.model.fetchDataFromServer();
    super.initState();
  }

  Widget _buildEditButton(
      BuildContext context, int index, MainScopedModel model) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        model.selectProduct(model.allProducts[index].id);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return ProductEditPage();
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (BuildContext context, Widget child, MainScopedModel model) {
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(model.allProducts[index].title),
            background: Container(color: Colors.red),
            onDismissed: (DismissDirection direction) {
              // to delete product on swipe from left to right
              if (direction == DismissDirection.endToStart) {
                model.selectProduct(model.allProducts[index].id);
                model.deleteProduct();
              }
            },
            child: Column(
              children: [
                ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(model.allProducts[index].image),
                    ),
                    title: Text(model.allProducts[index].title),
                    subtitle:
                        Text('\$${model.allProducts[index].price.toString()}'),
                    trailing: _buildEditButton(context, index, model)),
                Divider()
              ],
            ),
          );
        },
        itemCount: model.allProducts.length,
      );
    });
  }
}
