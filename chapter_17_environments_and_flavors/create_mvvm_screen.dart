import 'dart:convert';
import 'dart:io';

/// Generates the full Chapter 17 demo structure (folders + files).
/// Run from project root:
///   dart run tool/create_mvvm_screen.dart
/// Add --force to overwrite existing files.

void main(List<String> args) async {
  final force = args.contains('--force');
  final files = <String, String>{
    // pubspec & gitignore
    'pubspec.yaml': _pubspecYaml,
    '.gitignore': _gitignore,

    // core
    'lib/core/flavor.dart': _coreFlavor,
    'lib/core/app.dart': _coreApp,
    'lib/core/home_page.dart': _coreHome,

    // inherited version
    'lib/inherited_version/environment_config.dart': _inheritedEnvConfig,
    'lib/inherited_version/main_dev.dart': _inheritedMainDev,
    'lib/inherited_version/main_staging.dart': _inheritedMainStaging,
    'lib/inherited_version/main_prod.dart': _inheritedMainProd,
    'lib/inherited_version/main_beta.dart': _inheritedMainBeta,

    // singleton version
    'lib/singleton_version/environment_config_singleton.dart': _singletonEnvConfig,
    'lib/singleton_version/app_singleton.dart': _singletonApp,
    'lib/singleton_version/main_dev.dart': _singletonMainDev,
    'lib/singleton_version/main_staging.dart': _singletonMainStaging,
    'lib/singleton_version/main_prod.dart': _singletonMainProd,
    'lib/singleton_version/main_beta.dart': _singletonMainBeta,

    // dart-define version
    'lib/dart_define_version/main.dart': _dartDefineMain,
    'lib/dart_define_version/README_DART_DEFINE.md': _dartDefineReadme,

    // env files
    'env/dev.env': _envDev,
    'env/staging.json': _envStagingJson,
    'env/prod.env': _envProd,

    // scripts
    'scripts/run_with_env.sh': _scriptSh,
    'scripts/run_with_env.bat': _scriptBat,
  };

  int created = 0, skipped = 0, overwritten = 0;

  for (final entry in files.entries) {
    final path = entry.key;
    final content = entry.value;
    final file = File(path);
    await file.parent.create(recursive: true);

    if (await file.exists()) {
      if (force) {
        await file.writeAsString(content);
        overwritten++;
      } else {
        skipped++;
        continue;
      }
    } else {
      await file.writeAsString(content);
      created++;
    }

    // Make shell script executable on Unix
    if (path.endsWith('.sh')) {
      try {
        await Process.run('chmod', ['+x', path]);
      } catch (_) {}
    }
  }

  final report = jsonEncode({
    'created': created,
    'overwritten': overwritten,
    'skipped_existing': skipped,
    'total': files.length,
  });
  stdout.writeln('Scaffold complete: $report');

  stdout.writeln('\nQuick start:\n'
      '  flutter run -t lib/inherited_version/main_dev.dart\n'
      '  flutter run -t lib/singleton_version/main_dev.dart\n'
      '  sh scripts/run_with_env.sh env/dev.env\n');
}

// ----------------- file contents -----------------

const _pubspecYaml = r'''
name: chapter_17_environments_flavors
description: Runnable demos for Flutter Engineering Ch.17 — Environments & Flavors
environment:
  sdk: ">=3.4.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.6

flutter:
  uses-material-design: true
''';

const _gitignore = r'''
# Flutter/Dart defaults
.dart_tool/
.packages
build/
ios/Pods/
pubspec.lock

# Env & secrets
env/*.env
env/*.json

# Platform-specific
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
''';

// core
const _coreFlavor = r'''
enum Flavor { dev, staging, prod, beta }

String flavorLabel(Flavor f) {
  switch (f) {
    case Flavor.dev:
      return 'Development';
    case Flavor.staging:
      return 'Staging';
    case Flavor.prod:
      return 'Production';
    case Flavor.beta:
      return 'Beta';
  }
}
''';

const _coreApp = r'''
import 'package:flutter/material.dart';

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
''';

const _coreHome = r'''
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.envLabel,
    required this.flavorName,
    required this.apiUrl,
    required this.featureEnabled,
    this.hint,
  });

  final String envLabel;
  final String flavorName;
  final String apiUrl;
  final bool featureEnabled;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$envLabel • $flavorName')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _row('Environment', envLabel),
          _row('Flavor', flavorName),
          _row('API URL', apiUrl),
          _row('Feature Enabled', featureEnabled.toString()),
          if (hint != null) ...[
            const SizedBox(height: 16),
            const Text('Try this:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(hint!),
          ],
        ],
      ),
    );
  }

  Widget _row(String k, String v) {
    return ListTile(
      title: Text(k, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(v),
      contentPadding: EdgeInsets.zero,
    );
  }
}
''';

// inherited
const _inheritedEnvConfig = r'''
import 'package:flutter/widgets.dart';
import '../core/flavor.dart';

class EnvironmentConfig extends InheritedWidget {
  const EnvironmentConfig({
    super.key,
    required this.flavor,
    required this.label,
    required this.apiUrl,
    required this.featureEnabled,
    required super.child,
  });

  final Flavor flavor;
  final String label;
  final String apiUrl;
  final bool featureEnabled;

  static EnvironmentConfig of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<EnvironmentConfig>();
    assert(result != null, 'No EnvironmentConfig found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(EnvironmentConfig oldWidget) => false;
}
''';

const _inheritedMainDev = r'''
import 'package:flutter/material.dart';
import '../core/app.dart';
import '../core/home_page.dart';
import '../core/flavor.dart';
import 'environment_config.dart';

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
  const _InheritedHome({super.key});

  @override
  Widget build(BuildContext context) {
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
''';

const _inheritedMainStaging = r'''
import 'package:flutter/material.dart';
import '../core/app.dart';
import '../core/home_page.dart';
import '../core/flavor.dart';
import 'environment_config.dart';

void main() {
  runApp(
    EnvironmentConfig(
      flavor: Flavor.staging,
      label: 'Staging',
      apiUrl: 'https://api.staging.example.com',
      featureEnabled: true,
      child: AppShell(
        title: 'Chapter 17 — Staging',
        home: const _InheritedHome(),
      ),
    ),
  );
}

class _InheritedHome extends StatelessWidget {
  const _InheritedHome({super.key});

  @override
  Widget build(BuildContext context) {
    final cfg = EnvironmentConfig.of(context);
    return HomePage(
      envLabel: cfg.label,
      flavorName: cfg.flavor.name,
      apiUrl: cfg.apiUrl,
      featureEnabled: cfg.featureEnabled,
      hint: 'Run with: flutter run -t lib/inherited_version/main_staging.dart',
    );
  }
}
''';

const _inheritedMainProd = r'''
import 'package:flutter/material.dart';
import '../core/app.dart';
import '../core/home_page.dart';
import '../core/flavor.dart';
import 'environment_config.dart';

void main() {
  runApp(
    EnvironmentConfig(
      flavor: Flavor.prod,
      label: 'Production',
      apiUrl: 'https://api.example.com',
      featureEnabled: false,
      child: AppShell(
        title: 'Chapter 17 — Production',
        home: const _InheritedHome(),
      ),
    ),
  );
}

class _InheritedHome extends StatelessWidget {
  const _InheritedHome({super.key});

  @override
  Widget build(BuildContext context) {
    final cfg = EnvironmentConfig.of(context);
    return HomePage(
      envLabel: cfg.label,
      flavorName: cfg.flavor.name,
      apiUrl: cfg.apiUrl,
      featureEnabled: cfg.featureEnabled,
      hint: 'Run with: flutter run -t lib/inherited_version/main_prod.dart',
    );
  }
}
''';

const _inheritedMainBeta = r'''
import 'package:flutter/material.dart';
import '../core/app.dart';
import '../core/home_page.dart';
import '../core/flavor.dart';
import 'environment_config.dart';

void main() {
  runApp(
    EnvironmentConfig(
      flavor: Flavor.beta,
      label: 'Beta',
      apiUrl: 'https://api.beta.example.com',
      featureEnabled: true,
      child: AppShell(
        title: 'Chapter 17 — Beta',
        home: const _InheritedHome(),
      ),
    ),
  );
}

class _InheritedHome extends StatelessWidget {
  const _InheritedHome({super.key});

  @override
  Widget build(BuildContext context) {
    final cfg = EnvironmentConfig.of(context);
    return HomePage(
      envLabel: cfg.label,
      flavorName: cfg.flavor.name,
      apiUrl: cfg.apiUrl,
      featureEnabled: cfg.featureEnabled,
      hint: 'Run with: flutter run -t lib/inherited_version/main_beta.dart',
    );
  }
}
''';

// singleton
const _singletonEnvConfig = r'''
class EnvironmentConfigSingleton {
  static final EnvironmentConfigSingleton instance = EnvironmentConfigSingleton._();
  EnvironmentConfigSingleton._();

  late final String env;
  late final String label;
  late final String apiUrl;
  late final bool featureEnabled;

  void init({
    required String env,
    required String label,
    required String apiUrl,
    required bool featureEnabled,
  }) {
    this.env = env;
    this.label = label;
    this.apiUrl = apiUrl;
    this.featureEnabled = featureEnabled;
  }
}
''';

const _singletonApp = r'''
import 'package:flutter/material.dart';
import '../core/app.dart';
import '../core/home_page.dart';
import 'environment_config_singleton.dart';

class MyAppSingleton extends StatelessWidget {
  const MyAppSingleton({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final cfg = EnvironmentConfigSingleton.instance;
    return AppShell(
      title: title,
      home: HomePage(
        envLabel: cfg.label,
        flavorName: cfg.env,
        apiUrl: cfg.apiUrl,
        featureEnabled: cfg.featureEnabled,
        hint: 'Accessed via global singleton (no BuildContext needed).',
      ),
    );
  }
}
''';

const _singletonMainDev = r'''
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
''';

const _singletonMainStaging = r'''
import 'package:flutter/material.dart';
import 'environment_config_singleton.dart';
import 'app_singleton.dart';

void main() {
  EnvironmentConfigSingleton.instance.init(
    env: 'staging',
    label: 'Staging',
    apiUrl: 'https://api.staging.example.com',
    featureEnabled: true,
  );
  runApp(const MyAppSingleton(title: 'Chapter 17 — Staging (Singleton)'));
}
''';

const _singletonMainProd = r'''
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
''';

const _singletonMainBeta = r'''
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
''';

// dart-define
const _dartDefineMain = r'''
import 'package:flutter/material.dart';
import '../core/app.dart';
import '../core/home_page.dart';

String _envOrDefault(String key, String def) =>
    const String.fromEnvironment(key, defaultValue: def);

void main() {
  final flavor = _envOrDefault('FLAVOR', 'dev');
  final label = _envOrDefault('LABEL', 'Development');
  final apiUrl = _envOrDefault('API_URL', 'https://api.dev.example.com');
  final featureEnabled = _envOrDefault('FEATURE_ENABLED', 'true').toLowerCase() == 'true';

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
''';

const _dartDefineReadme = r'''
# dart-define version

Run:

```bash
flutter run -t lib/dart_define_version/main.dart \
  --dart-define=FLAVOR=staging \
  --dart-define=LABEL=Staging \
  --dart-define=API_URL=https://api.staging.example.com \
  --dart-define=FEATURE_ENABLED=true
''';

// env
const _envDev = r'''
FLAVOR=dev
LABEL=Development
API_URL=https://api.dev.example.com

FEATURE_ENABLED=true
''';

const _envStagingJson = r'''
{
"FLAVOR": "staging",
"LABEL": "Staging",
"API_URL": "https://api.staging.example.com
",
"FEATURE_ENABLED": "true"
}
''';

const _envProd = r'''
FLAVOR=prod
LABEL=Production
API_URL=https://api.example.com

FEATURE_ENABLED=false
''';

// scripts
const _scriptSh = r'''#!/usr/bin/env bash
set -e

if [ -z "$1" ]; then
echo "Usage: scripts/run_with_env.sh <env-file> [-- extra flutter args]"
exit 1
fi

ENV_FILE="$1"
shift || true

DEFINES=()
ext="${ENV_FILE##*.}"

if [ "$ext" = "env" ]; then
while IFS='=' read -r key val; do
[[ -z "$key" || "$key" =~ ^# ]] && continue
DEFINES+=(--dart-define="${key}=${val}")
done < "$ENV_FILE"
elif [ "$ext" = "json" ]; then
if ! command -v jq >/dev/null 2>&1; then
echo "jq is required for JSON mode. Install jq and retry."
exit 2
fi
for k in $(jq -r 'keys[]' "$ENV_FILE"); do
v=$(jq -r --arg k "$k" '.[$k]' "$ENV_FILE")
DEFINES+=(--dart-define="${k}=${v}")
done
else
echo "Unsupported file extension: .$ext (use .env or .json)"
exit 3
fi

flutter run -t lib/dart_define_version/main.dart "${DEFINES[@]}" "$@"
''';

const _scriptBat = r'''@echo off
setlocal enabledelayedexpansion

if "%~1"=="" (
echo Usage: scripts\run_with_env.bat path\to\envfile
exit /b 1
)

set ENV_FILE=%~1
for %%I in ("%ENV_FILE%") do set EXT=%%~xI

set DEFINES=

if /I "%EXT%"==".env" (
for /f "usebackq tokens=1,2 delims==" %%A in ("%ENV_FILE%") do (
if not "%%A"=="" if not "%%A"=="#" (
set DEFINES=!DEFINES! --dart-define=%%A=%%B
)
)
) else if /I "%EXT%"==".json" (
echo JSON expansion not supported in this .bat example. Use .env or WSL with the .sh script.
exit /b 2
) else (
echo Unsupported extension %EXT%
exit /b 3
)

flutter run -t lib/dart_define_version/main.dart %DEFINES% %*
''';