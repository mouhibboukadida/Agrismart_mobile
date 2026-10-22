import 'package:flutter/material.dart';
class AppTheme {
  static const Color succes = Color(0xFF2E7D32);
  static const Color echec = Color(0xFFC62828);

  static ThemeData clair(){
    return ThemeData(
        colorSchemeSeed: Colors.green,
        brightness: Brightness.light,
        useMaterial3: true,
    );
  }
  static ThemeData sombre(){
    return ThemeData(
      colorSchemeSeed: Colors.green,
        brightness: Brightness.dark,
        useMaterial3: true,
    );
  }
}