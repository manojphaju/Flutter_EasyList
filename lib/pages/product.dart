import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/product_model.dart';
import '../widgets/products/product_fab.dart';

class ProductPage extends StatelessWidget {
  final ProductModel product;

  ProductPage(this.product);

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
              Hero(
                tag: product.id,
                child: 
              FadeInImage(
                placeholder: AssetImage('assets/food.jpg'),
                image: NetworkImage(product.image),
                height: 300.0,
                fit: BoxFit.cover,
              ),),
              Text(product.title),
            ],
          ),
        ),
        floatingActionButton: ProductFAB(product),
      );
  }
}
