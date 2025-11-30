import 'package:flutter/material.dart';
import 'environment_config_singleton.dart';
import 'app_singleton.dart';

/// Staging environment entry point (Singleton approach).
void main() {
/// Staging environment entry point (Singleton approach).
  EnvironmentConfigSingleton.instance.init(
    env: 'staging',
    label: 'Staging',
    apiUrl: 'https://api.staging.example.com',
    featureEnabled: true,
  );

  // Run app using singleton config.
  runApp(
    const MyAppSingleton(title: 'Chapter 17 — Staging (Singleton)'),
  );
}
