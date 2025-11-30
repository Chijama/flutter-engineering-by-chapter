import 'package:flutter/material.dart';
import '../core/app.dart';
import '../core/home_page.dart';
import 'environment_config_singleton.dart';

/// Root widget for the Singleton-based environment setup.
class MyAppSingleton extends StatelessWidget {
  const MyAppSingleton({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    // Read global configuration from the singleton.
    final cfg = EnvironmentConfigSingleton.instance;

    return AppShell(
      title: title,
      home: HomePage(
        envLabel: cfg.label,
        flavorName: cfg.env,
        apiUrl: cfg.apiUrl,
        featureEnabled: cfg.featureEnabled,
        hint: 'Using global singleton config.',
      ),
    );
  }
}
