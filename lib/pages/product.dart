import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/product_model.dart';
import '../scoped_model/main_scoped_model.dart';

class ProductPage extends StatelessWidget {
  final int productIndex;

  ProductPage(this.productIndex);

  showWarningDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('This action cannot be undone!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('DISCARD'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context, true);
              },
              child: Text('CONTINUE'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainScopedModel>(builder:
        (BuildContext context, Widget child, MainScopedModel model) {
      final ProductModel product = model.allProducts[productIndex];
      return Scaffold(
        appBar: AppBar(
          title: Text('Product Detail'),
        ),
        body: WillPopScope(
          onWillPop: () {
            Navigator.pop(context, false);
            return Future.value(false);
          },
          child: Column(
            children: [
              Image.asset(product.image),
              Text(product.title),
              Container(
                padding: EdgeInsets.all(10.0),
                child: ElevatedButton(
                  child: Text('DELETE'),
                  onPressed: () => showWarningDialog(context),
                ),
              ),
              Center(
                child: Text('On the product page'),
              ),
            ],
          ),
        ),
      );
    });
  }
}
