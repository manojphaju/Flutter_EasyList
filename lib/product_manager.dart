import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './product_control.dart';
import './products.dart';

class ProductManager extends StatefulWidget {
  final Map startingProduct;
  ProductManager({this.startingProduct});

  @override
  State<StatefulWidget> createState() {
    return _ProductManagerState();
  }
}

class _ProductManagerState extends State<ProductManager> {
  List<Map<String, String>> _product = [];

  @override
  void initState() {
    if (widget.startingProduct != null) {
      _product.add(widget.startingProduct);
    }
    super.initState();
  }

  void addProduct(Map<String, String> product) {
    setState(() {
      _product.add(product);
    });
  }

  void deleteProduct(int index) {
    setState(() {
      _product.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProductControl(addProduct),
        Expanded(
          child: Products(_product, deleteProduct: deleteProduct),
        ),
      ],
    );
  }
}
