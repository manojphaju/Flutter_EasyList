import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../products/address_tag.dart';
import '../ui_elements/title_default.dart';
import './price_tag.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final int productIndex;

  ProductCard(this.product, this.productIndex);

  Widget _buildTitlePriceRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TitleDefault(product['title']),
        SizedBox(width: 8.0),
        PriceTag(
          product['price'].toString(),
        ),
      ],
    );
  }

  Widget _buildButtonBar(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: [
        IconButton(
          color: Theme.of(context).accentColor,
          onPressed: () => Navigator.pushNamed<bool>(
              context, '/product/' + productIndex.toString()),
          icon: Icon(Icons.info),
        ),
        IconButton(
          color: Colors.red,
          onPressed: () => Navigator.pushNamed<bool>(
              context, '/product/' + productIndex.toString()),
          icon: Icon(Icons.favorite_border),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.asset(product['image']),
          _buildTitlePriceRow(),
          AddressTag(product['address']),
          _buildButtonBar(context)
        ],
      ),
    );
  }
}
