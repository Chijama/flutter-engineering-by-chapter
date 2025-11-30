import 'package:flutter/material.dart';
import 'environment_config_singleton.dart';
import 'app_singleton.dart';

void main() {
  EnvironmentConfigSingleton.instance.init(
    env: 'dev',
    label: 'Development',
    apiUrl: 'https://api.dev.example.com',
    featureEnabled: true,
  );
  runApp(const MyAppSingleton(title: 'Chapter 17 — Dev (Singleton)'));
}
