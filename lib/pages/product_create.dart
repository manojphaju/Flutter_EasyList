import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductCreatePage extends StatefulWidget {
  final Function addProduct;

  ProductCreatePage(this.addProduct);

  @override
  State<StatefulWidget> createState() {
    return _ProductCreatePage();
  }
}

class _ProductCreatePage extends State<ProductCreatePage> {
  String _title;
  String _descriptions;
  double _price;

  Widget _buildTitleTextField() {
    return TextField(
      decoration: InputDecoration(labelText: 'Product Title'),
      onChanged: (String value) {
        setState(
          () {
            _title = value;
          },
        );
      },
    );
  }

  Widget _buildPriceTextField() {
    return TextField(
      decoration: InputDecoration(labelText: 'Product Price'),
      keyboardType: TextInputType.number,
      onChanged: (String value) {
        setState(
          () {
            _price = double.parse(value);
          },
        );
      },
    );
  }

  Widget _buildDescriptionTextField() {
    return TextField(
      decoration: InputDecoration(labelText: 'Product Descriptions'),
      maxLines: 4,
      onChanged: (value) {
        setState(
          () {
            _descriptions = value;
          },
        );
      },
    );
  }

  void _submitForm() {
    final Map<String, dynamic> product = {
      'title': _title,
      'description': _descriptions,
      'price': _price,
      'image': 'assets/food.jpg'
    };
    widget.addProduct(product);
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 760.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    return Container(
      margin: EdgeInsets.all(10.0),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
        children: [
          _buildTitleTextField(),
          _buildPriceTextField(),
          _buildDescriptionTextField(),
          SizedBox(
            height: 10.0,
          ),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
