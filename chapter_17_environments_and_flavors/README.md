# Chapter 17 — Environments & Flavors (Flutter Engineering)

This project implements all the concepts discussed in **Chapter 17: Environments and Flavors** from *Flutter Engineering* — in a clear, runnable, chapter-by-chapter format.

The goal is to help readers understand, run, and experiment with multiple environment setups in Flutter using:

- **InheritedWidget**
- **Singleton**
- **dart-define**

Each approach is isolated in its own directory and reuses a shared core UI so learners can compare results easily.

---

## 🚀 What This Chapter Covers

- The difference between **Environments** and **Flavors**
- Why multiple environments matter
- Entry-point based configuration (`main_dev.dart`, `main_prod.dart`, etc.)
- How to use **InheritedWidget** for configuration
- How to use a **Singleton** for global config
- How to use **`--dart-define`** for compile-time variables
- How environment data flows through an app
- How this supports **CI/CD pipelines**

This repo provides fully runnable examples of all these techniques.

---

## 📂 Project Structure
```
lib/
├─ core/                        # Shared UI logic
│  ├─ app.dart
│  ├─ home_page.dart
│  └─ flavor.dart
│
├─ inherited_version/           # InheritedWidget approach
│  ├─ environment_config.dart
│  ├─ main_dev.dart
│  ├─ main_staging.dart
│  ├─ main_prod.dart
│  └─ main_beta.dart
│
├─ singleton_version/           # Singleton approach
│  ├─ environment_config_singleton.dart
│  ├─ app_singleton.dart
│  ├─ main_dev.dart
│  ├─ main_staging.dart
│  ├─ main_prod.dart
│  └─ main_beta.dart
│
└─ dart_define_version/         # Compile-time config via --dart-define
   ├─ main.dart
   └─ README_DART_DEFINE.md
```

**Additional files:**
```
env/          # Example .env and .json configs
scripts/      # Helper scripts to load many defines
tool/         # Code generation scripts
```

---

## 🟦 Running Each Version

### 1. InheritedWidget
```bash
flutter run -t lib/inherited_version/main_dev.dart
flutter run -t lib/inherited_version/main_staging.dart
flutter run -t lib/inherited_version/main_prod.dart
flutter run -t lib/inherited_version/main_beta.dart
```

### 2. Singleton
```bash
flutter run -t lib/singleton_version/main_dev.dart
flutter run -t lib/singleton_version/main_staging.dart
flutter run -t lib/singleton_version/main_prod.dart
flutter run -t lib/singleton_version/main_beta.dart
```

### 3. dart-define

**Example: Staging**
```bash
flutter run -t lib/dart_define_version/main.dart `
  --dart-define=FLAVOR=staging `
  --dart-define=LABEL=Staging `
  --dart-define=API_URL=https://api.staging.example.com `
  --dart-define=FEATURE_ENABLED=true
```

Other flavors listed in `dart_define_version/README_DART_DEFINE.md`.

---

## 🔍 InheritedWidget vs Singleton — What's the Difference?

Below is the official comparison included in your chapter's README.

### InheritedWidget

- Configuration flows through the widget tree
- Accessed with: `EnvironmentConfig.of(context)`
- More Flutter-idiomatic
- Widgets depending on it can auto-rebuild if the data changes
- **Best for:** values the UI responds to

### Singleton

- Configuration stored in one global instance
- Accessed anywhere, even without a context: `EnvironmentConfigSingleton.instance.apiUrl`
- Very simple and convenient
- Does not rebuild widgets automatically if values change
- **Best for:** config that stays the same for the entire app lifecycle

---

## ✔ Summary Table

| Feature                  | InheritedWidget | Singleton |
|--------------------------|-----------------|-----------|
| Scoped to widget tree    | ✅ Yes          | ❌ No     |
| Global access            | ❌ No           | ✅ Yes    |
| Auto-rebuild on change   | ✅ Yes          | ❌ No     |
| Requires BuildContext    | ✅ Yes          | ❌ No     |
| **Ideal for config**     | UI-related      | App-wide constants |

**Both are valid** — the project includes both so you can learn when to use each.

---

## 📱 Android Flavors Configuration

To enable Android-specific flavors (different app IDs, names, and icons per environment), add this to your `android/app/build.gradle`:
```gradle
android {
    // ... other config ...
    
    flavorDimensions += "version"
    
    productFlavors {
        create("dev") {
            dimension = "version"
            applicationIdSuffix = ".dev"
            resValue("string", "app_name", "My App Dev")
        }
        create("staging") {
            dimension = "version"
            applicationIdSuffix = ".staging"
            resValue("string", "app_name", "My App Staging")
        }
        create("beta") {
            dimension = "version"
            applicationIdSuffix = ".beta"
            resValue("string", "app_name", "My App Beta")
        }
        create("prod") {
            dimension = "version"
            resValue("string", "app_name", "My App")
        }
    }
}
```

### What This Does

- **`flavorDimensions`**: Groups related flavors together (required by Android)
- **`applicationIdSuffix`**: Adds a suffix to your app's package name (e.g., `com.example.myapp.dev`)
  - This allows multiple versions (dev, staging, prod) to be installed on the same device simultaneously
- **`resValue`**: Creates a string resource for the app name that appears on the home screen
  - Dev: "My App Dev"
  - Staging: "My App Staging"
  - Beta: "My App Beta"
  - Prod: "My App"


## 🛠 How to Contribute

- Open issues for corrections, improvements, or suggestions
- Submit PRs for new examples or clearer explanations
- Follow Flutter's standard folder layout and formatting

---

## ⭐ Author Notes

This chapter is designed to make the book's concepts **practical and runnable**, especially for students, teams, and open-source contributors who prefer real code over theory.

**If you find this helpful, give the repo a ⭐ on GitHub!**