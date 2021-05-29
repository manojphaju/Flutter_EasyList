import 'package:flutter/material.dart';

final ThemeData _androidTheme = ThemeData(
  primarySwatch: Colors.deepOrange,
  accentColor: Colors.deepPurple,
);

final ThemeData _iOSTheme = ThemeData(
  primarySwatch: Colors.grey,
  accentColor: Colors.deepPurple,
);

ThemeData getAdaptiveThemeData(context) {
  return Theme.of(context).platform == TargetPlatform.android
      ? _androidTheme
      : _iOSTheme;
}
