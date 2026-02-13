# 🤝 Contributing Guide

Thank you for your interest in contributing to **Flutter Engineering — Chapter by Chapter**.

This repository is an educational companion project that recreates engineering concepts from *Flutter Engineering* as runnable Flutter demos. We welcome contributions that improve clarity, structure, correctness, and learning value.

---

## 🎯 Project Philosophy

This repository follows these principles:

- Stay close to the original book concepts
- Prioritize clarity over abstraction
- Keep implementations educational and readable
- Avoid unnecessary architectural complexity
- Keep chapters independent and self-contained

---

## 📂 Repository Structure Rules

Each chapter must:

- Live inside its own folder
- Be a standalone runnable Flutter project
- Include its own README with instructions
- Avoid cross-dependencies with other chapters

**Do not merge multiple chapters into a single Flutter app.**

---

## 🆕 Proposing a New Chapter

To prevent duplicate work and maintain organization, please follow this workflow before starting a new chapter.

### Step 1: Open a Proposal Issue

Create a new issue with the title:

```
Proposal: Chapter XX — Title
```

In the issue description, include:

- What the chapter will demonstrate
- How it aligns with the book
- Expected folder structure
- Any additional dependencies

### Step 2: Wait for Approval

**Do not begin implementation until:**

- The proposal is reviewed
- You are assigned to the issue

This ensures:

- No two contributors work on the same chapter
- Structure remains consistent
- Scope is aligned with the repository goals

---

## 🏷 Claiming an Issue

If you would like to work on an open issue:

1. Comment:
   ```
   I'd like to work on this.
   ```

2. Wait to be assigned before beginning development.

Assigned issues will be considered in progress. This workflow prevents overlapping work.

---

## 📝 Commit Message Convention

We follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add new feature
fix: fix bug
docs: update documentation
refactor: improve structure without changing behavior
chore: maintenance changes
```

**Example:**

```
feat: add digital signature demo to chapter 19
```

---

## 🧪 Before Submitting a Pull Request

Please ensure:

- ✅ The chapter builds successfully
- ✅ `flutter analyze` reports no critical issues
- ✅ Code is formatted (`flutter format .`)
- ✅ README is updated if necessary
- ✅ You tested on at least one platform

---

## 🐛 Reporting Issues

When opening an issue, include:

- Chapter number
- Platform (Windows, macOS, Android, etc.)
- Flutter version (`flutter doctor -v`)
- Steps to reproduce

Clear issues help maintain quality.

---

## 🎓 Educational Contributions Encouraged

We especially welcome:

- Improved explanations
- Better comments
- Accessibility improvements
- Security clarifications
- CI/CD examples
- Additional test coverage

---

## 🚫 What Not to Do

Please avoid:

- Large architectural rewrites
- Mixing multiple chapters into one app
- Removing educational comments
- Introducing unrelated features

---

## 📜 Licensing Note

This repository is educational. Please respect the licensing terms of the original book.

---

## ⭐ Final Note

All contributions should improve learning value and maintain structural consistency.

If you're unsure about a change, open an issue first — discussion is encouraged.

**Thank you for helping make this repository better** 🚀
