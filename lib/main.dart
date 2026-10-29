import 'package:agrismart/screens/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:agrismart/screens/app_shell.dart';
import 'package:agrismart/theme/app_theme.dart';

void main() {
  runApp(const AgriSmartApp());
}

class AgriSmartApp extends StatelessWidget {
  const AgriSmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriSmart',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.clair(),
      darkTheme: AppTheme.sombre(),
      themeMode: ThemeMode.system,
      home: const AppShell(),
    );
  }
}