import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './pages/products_admin.dart';
import './pages/products.dart';


main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        accentColor: Colors.deepPurple
      ),
      // home: AuthPage(),
      routes: {
        '/' :  (BuildContext context) => ProductsAdminPage(),
        '/admin': (BuildContext context) => ProductsPage(),
      },
    );
  }
}
