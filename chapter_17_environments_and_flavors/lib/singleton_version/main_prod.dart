import 'package:flutter/material.dart';
import 'environment_config_singleton.dart';
import 'app_singleton.dart';

void main() {
  EnvironmentConfigSingleton.instance.init(
    env: 'prod',
    label: 'Production',
    apiUrl: 'https://api.example.com',
    featureEnabled: false,
  );
  runApp(const MyAppSingleton(title: 'Chapter 17 — Prod (Singleton)'));
}
