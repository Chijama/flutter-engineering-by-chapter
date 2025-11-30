import 'package:flutter/material.dart';
/// Base app wrapper used by all environment demos.

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.title, required this.home});

  final String title;
  final Widget home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(colorSchemeSeed: Colors.blue),
      home: home,
    );
  }
}
