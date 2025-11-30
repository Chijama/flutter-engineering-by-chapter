# dart-define version

Run:

Staging
```bash
flutter run -t lib/dart_define_version/main.dart `
  --dart-define=FLAVOR=staging `
  --dart-define=LABEL=Staging `
  --dart-define=API_URL=https://api.staging.example.com `
  --dart-define=FEATURE_ENABLED=true
```



Development
```bash
flutter run -t lib/dart_define_version/main.dart `
  --dart-define=FLAVOR=dev `
  --dart-define=LABEL=Development `
  --dart-define=API_URL=https://api.dev.example.com `
  --dart-define=FEATURE_ENABLED=true
```

Production
```bash
flutter run -t lib/dart_define_version/main.dart `
  --dart-define=FLAVOR=prod `
  --dart-define=LABEL=Production `
  --dart-define=API_URL=https://api.example.com `
  --dart-define=FEATURE_ENABLED=false
```

Beta
```bash
flutter run -t lib/dart_define_version/main.dart `
  --dart-define=FLAVOR=beta `
  --dart-define=LABEL=Beta `
  --dart-define=API_URL=https://api.beta.example.com `
  --dart-define=FEATURE_ENABLED=true
  ```