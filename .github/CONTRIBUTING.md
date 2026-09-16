# Contributing to uni

First off, thank you for considering contributing to **uni**!

**uni** is primarily developed and maintained by **[NIAEFEUP](https://niaefeup.pt/)**. However, we believe that the best tools are built by the community, and outside contributions are always welcome!

### Important: University Account Required
Please note that to contribute effectively and explore all of the app's features (such as schedules, grades, and private student data), **you must have a valid University of Porto (Sigarra) account**. Most of the app's core functionality relies on authenticated requests to university systems.

### About this branch

This is `develop-native`, the ongoing migration of **uni** away from Flutter to native UI (Jetpack Compose on Android, SwiftUI on iOS) sharing business logic through Kotlin Multiplatform. See the [README](../README.md) for the full stack breakdown. It's an active migration, not a finished rewrite — expect gaps compared to the Flutter app.

---

## Documentation & Guides

Setup, building, testing and linting instructions for this branch live in the **[README](../README.md)** — check its **Getting started**, **Testing** and **Linting** sections before starting your development journey.

---

## Contribution Workflow

1.  **Find an Issue**: Browse our [open issues](https://github.com/niaefeup/uni/issues). If you have a new idea, open an issue first to discuss it with the team.
2.  **Fork & Branch**: Create a feature branch from `develop-native` (e.g., `feat/add-new-widget`).
3.  **Code & Lint**: Write your code and make sure it passes ktlint/SwiftLint (see the README's **Linting** section) — enable the repo's pre-commit hook so this is checked locally before you even push.
4.  **Submit a Pull Request**: Open a PR against the `develop-native` branch. Ensure you fill out the PR template provided.

### Pull Request Checklist
- [ ] I have synced my branch with the latest `develop-native`.
- [ ] My code follows the project's linting and formatting rules (ktlint/SwiftLint).
- [ ] I have tested the changes on an emulator/simulator or a real device, for whichever platform(s) I touched.

---

## Reporting Bugs

If you find a bug, please [open an issue](https://github.com/niaefeup/uni/issues/new). High-quality bug reports with reproduction steps and screenshots are greatly appreciated!

## Community & Support

Need help?
* Reach out via our [socials](https://linktr.ee/niaefeup) or our [website](https://niaefeup.pt).
