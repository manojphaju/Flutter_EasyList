import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddressTag extends StatelessWidget {
  final String addressName;

  AddressTag(this.addressName);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Text('Union Square, San Francisco'),
    );
  }
}
