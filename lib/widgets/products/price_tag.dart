import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceTag extends StatelessWidget {
  final String _priceTag;

  PriceTag(this._priceTag);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.5),
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Text(
        '\$ $_priceTag',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
