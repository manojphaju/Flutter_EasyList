import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../products/address_tag.dart';
import '../ui_elements/title_default.dart';
import './price_tag.dart';
import '../../models/product_model.dart';
import '../../scoped_model/main_scoped_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final int productIndex;

  ProductCard(this.product, this.productIndex);

  Widget _buildTitlePriceRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TitleDefault(product.title),
        SizedBox(width: 8.0),
        PriceTag(
          product.price.toString(),
        ),
      ],
    );
  }

  Widget _buildButtonBar(BuildContext context) {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (BuildContext context, Widget child, MainScopedModel model) {
      return ButtonBar(
        alignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.info),
            color: Theme.of(context).accentColor,
            onPressed: () {
              model.selectProduct(model.allProducts[productIndex].id);
              Navigator.pushNamed<bool>(
                      context, '/product/' + model.allProducts[productIndex].id)
                  .then((value) => model.selectProduct(null));
            },
          ),
          IconButton(
            icon: Icon(model.allProducts[productIndex].isFavorite
                ? Icons.favorite
                : Icons.favorite_border),
            color: Colors.red,
            onPressed: () {
              model.selectProduct(model.allProducts[productIndex].id);
              model.toggleProductFavoriteStatus();
            },
          )
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/food.jpg'),
              image: NetworkImage(product.image),
              height: 300.0,
              fit: BoxFit.cover,
            ),
          ),
          _buildTitlePriceRow(),
          AddressTag(product.description),
          _buildButtonBar(context)
        ],
      ),
    );
  }
}
