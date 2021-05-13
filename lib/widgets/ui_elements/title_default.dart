import 'package:flutter/cupertino.dart';

class TitleDefault extends StatelessWidget {
  final String title;
  TitleDefault(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 30,
        fontFamily: 'Oswald',
      ),
    );
  }
}
