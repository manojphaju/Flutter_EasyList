import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/models/product_model.dart';
import 'package:scoped_model/scoped_model.dart';

import './pages/auth.dart';
import './pages/products_admin.dart';
import './pages/product.dart';
import './pages/products.dart';
import './scoped_model/main_scoped_model.dart';

main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final MainScopedModel model = MainScopedModel();
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: model,
      child: MaterialApp(
        theme: ThemeData(
            primarySwatch: Colors.deepOrange, accentColor: Colors.deepPurple),
        // home: AuthPage(),
        routes: {
          '/': (BuildContext context) => AuthPage(),
          '/productPage': (BuildContext context) => ProductsPage(model),
          '/admin': (BuildContext context) => ProductsAdminPage(model),
        },
        onGenerateRoute: (RouteSettings settings) {
          List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'product') {
            final String productId = pathElements[2];
            final ProductModel product =
                model.allProducts.firstWhere((ProductModel product) {
              return product.id == productId;
            });
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) => ProductPage(product),
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (BuildContext context) => ProductsPage(model),
          );
        },
      ),
    );
  }
}
