import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  final String title;
  final String imageUrl;

  ProductPage(this.title, this.imageUrl);
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
            Image.asset(imageUrl),
            Text(title),
            Container(
              padding: EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('DELETE'),
              ),
            ),
            Center(
              child: Text('On the product page'),
            ),
          ],
        ),
      ),
    );
  }
}
