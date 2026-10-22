import 'package:flutter/material.dart';
import 'package:agrismart/screens/accueil_page.dart';
import 'package:agrismart/theme/app_theme.dart';

void main() => runApp(const AgriSmartApp());

class AgriSmartApp extends StatelessWidget {
  const AgriSmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriSmart',
      theme: AppTheme.clair(),
      darkTheme: AppTheme.sombre(),
      themeMode: ThemeMode.system,
      home: const AccueilPage(),
    );
  }
}