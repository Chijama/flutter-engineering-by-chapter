# 📘 Flutter Engineering — Chapter by Chapter

A structured, runnable implementation of concepts from the book **Flutter Engineering** by Majid Hajian. This repository recreates selected chapters as practical Flutter demos, preserving the core ideas and code structure while making everything executable and easy to experiment with.

---

## 🎯 Purpose

This project exists to:

- Transform architectural concepts into runnable Flutter examples
- Preserve code structure and intent from the book
- Provide practical demonstrations of engineering patterns
- Serve as a learning reference for Flutter developers
- Encourage structured, educational open-source contributions

Each chapter lives in its own self-contained Flutter project.

---

## 📂 Repository Structure

```
flutter-engineering-by-chapter/
│
├── README.md
├── CONTRIBUTING.md
├── CHANGELOG.md
├── LICENSE
│
├── chapter_17_environments_and_flavors/
├── chapter_19_cryptography/
└── chapter_21_accessibility/
```

Each chapter contains its own README with detailed explanations and running instructions.

---

## 🚀 Implemented Chapters

### 🔧 Chapter 17 — Environments & Flavors

Demonstrates multiple approaches to managing environments in Flutter:

- InheritedWidget configuration
- Singleton configuration
- `dart-define` compile-time configuration
- Entry-point based environment setup
- Environment file loading

**📁 Folder:** `chapter_17_environments_and_flavors/`

---

### 🔐 Chapter 19 — Cryptography in Flutter

UI-driven demonstration of cryptographic concepts:

- Argon2id key derivation
- AES encryption (CBC + PKCS7)
- SHA-256, MD5, and HMAC hashing
- Secure storage examples
- Educational visualization of encryption and hashing workflows

**📁 Folder:** `chapter_19_cryptography/`

---

### ♿ Chapter 21 — Accessibility

Practical demo implementing accessibility best practices:

- Semantics & screen reader support
- WCAG contrast compliance
- Tap target guidelines
- Focus traversal order
- Reduced motion support
- Accessibility testing examples

**📁 Folder:** `chapter_21_accessibility/`

---

## ▶️ Running a Chapter

Navigate into any chapter folder:

```bash
cd chapter_17_environments_and_flavors
flutter pub get
flutter run
```

Each chapter runs independently.

---

## 🛠 Requirements

- Flutter 3.x+
- Dart 3.x+
- Android Studio / VS Code
- Android Emulator, iOS Simulator, or Desktop/Web target

---

## 🤝 Contributing

Contributions are welcome. Please read [CONTRIBUTING.md](CONTRIBUTING.md) before submitting pull requests.

This repository is educational, so improvements that increase clarity, structure, and correctness are highly encouraged.

---

## 📜 License

MIT License for original demo implementations.

All book content and concepts remain the intellectual property of the original author and publisher. This repository is for educational purposes only.

---

## ⭐ Final Note

This project is intended as a companion learning resource — bridging theory from the book with runnable Flutter applications.

**Happy building** 🚀
