import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped_model/main_scoped_model.dart';

class LogoutListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainScopedModel model) {
      return ListTile(
        leading: Icon(Icons.exit_to_app),
        title: Text('Logout'),
        onTap: () {
          model.logOut();
        },
      );
    });
  }
}
