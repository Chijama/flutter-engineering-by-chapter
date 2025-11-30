import 'package:flutter/material.dart';
import 'environment_config_singleton.dart';
import 'app_singleton.dart';

void main() {
  EnvironmentConfigSingleton.instance.init(
    env: 'beta',
    label: 'Beta',
    apiUrl: 'https://api.beta.example.com',
    featureEnabled: true,
  );
  runApp(const MyAppSingleton(title: 'Chapter 17 — Beta (Singleton)'));
}
