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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: ListView(
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Product Title'),
            onChanged: (String value) {
              setState(
                () {
                  _title = value;
                },
              );
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Product Price'),
            keyboardType: TextInputType.number,
            onChanged: (String value) {
              setState(
                () {
                  _price = double.parse(value);
                },
              );
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Product Descriptions'),
            maxLines: 4,
            onChanged: (value) {
              setState(
                () {
                  _descriptions = value;
                },
              );
            },
          ),
          SizedBox(height: 10.0,),
          ElevatedButton(
            onPressed: () {
              final Map<String, dynamic> product = {
                'title': _title,
                'description': _descriptions,
                'price': _price,
                'image': 'assets/food.jpg'
              };
              widget.addProduct(product);
              Navigator.pushReplacementNamed(context, '/');
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
