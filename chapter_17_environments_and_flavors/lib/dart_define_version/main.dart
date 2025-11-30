import 'package:flutter/material.dart';
import '../core/app.dart';
import '../core/home_page.dart';

void main() {
  // Use const - this is CRITICAL for String.fromEnvironment to work!
  const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
  const label = String.fromEnvironment('LABEL', defaultValue: 'Development');
  const apiUrl = String.fromEnvironment('API_URL', defaultValue: 'https://api.dev.example.com');
  const featureEnabledStr = String.fromEnvironment('FEATURE_ENABLED', defaultValue: 'false');
  
  // Parse the boolean (has to be done separately because .toLowerCase() isn't const)
  final featureEnabled = featureEnabledStr.toLowerCase() == 'true';

  runApp(
    AppShell(
      title: 'Chapter 17 — $label (dart-define)',
      home: HomePage(
        envLabel: label,
        flavorName: flavor,
        apiUrl: apiUrl,
        featureEnabled: featureEnabled,
        hint: 'Run with many --dart-define or scripts/run_with_env.*',
      ),
    ),
  );
}