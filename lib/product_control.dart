import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductControl extends StatelessWidget {
  final Function addProduct;
  ProductControl(this.addProduct);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        addProduct({'title': 'Chocolate', 'image':'assets/food.jpg'});
      },
      child: Text('Add Product'),
    );
  }
}
