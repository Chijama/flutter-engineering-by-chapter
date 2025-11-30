import 'package:flutter/material.dart';
import '../core/app.dart';
import '../core/home_page.dart';
import '../core/flavor.dart';
import 'environment_config.dart';

/// Development environment entry point (InheritedWidget approach).
void main() {
  runApp(
    EnvironmentConfig(
      flavor: Flavor.dev,
      label: 'Development',
      apiUrl: 'https://api.dev.example.com',
      featureEnabled: true,
      child: AppShell(
        title: 'Chapter 17 — Development',
        home: const _InheritedHome(),
      ),
    ),
  );
}

class _InheritedHome extends StatelessWidget {
  const _InheritedHome();

  @override
  Widget build(BuildContext context) {
    
    // Access environment config provided at the top level.
    final cfg = EnvironmentConfig.of(context);
    return HomePage(
      envLabel: cfg.label,
      flavorName: cfg.flavor.name,
      apiUrl: cfg.apiUrl,
      featureEnabled: cfg.featureEnabled,
      hint: 'Run with: flutter run -t lib/inherited_version/main_dev.dart',
    );
  }
}
