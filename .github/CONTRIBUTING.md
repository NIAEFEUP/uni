# Contributing

Thank you for contributing your time and skills to **uni**. Your work is valued and we aim to make the integration process as efficient as possible.

This document offers a **brief overview** outlining the primary steps required for successfully introducing your ideas and code into our main codebase.

For **in-depth information and technical documentation**, please ensure you consult our [Wiki](https://github.com/NIAEFEUP/uni/wiki).

> **Heads up:** You need a university account to access most of the app's features. Trying to develop or properly test without one will be tough since so much of the functionality will be locked out.

## Getting started

### Prerequisites

- Flutter SDK - Follow the installation instructions [here](https://flutter.dev/).
- Android SDK if you're building for Android.
- XCode if you're building for iOS.

### Running

1. Clone the repository:

```bash
git clone git@github.com:NIAEFEUP/uni.git

cd uni
```

2. Open the main app directory and fetch packages:

```bash
cd packages/uni_app
flutter pub get
```

3. Run in `debug` mode

```bash
flutter run
```

## Contribution workflow

### Branch naming

We follow the [Conventional Branching](https://conventional-branch.github.io/) strategy. This ensures that the purpose and scope of a branch are immediately clear to reviewers and maintainers.

Use descriptive names structured as: `<type>/<short-description>`

For example: `feat/login-page`, `fix/error-map-page`

### Committing and Formatting

This project requires formatted files. CI/CD will fail if your code is not formatted, making merging unavailable.

**Code Style and Linters:**
- Follow the project's Dart/Flutter style.
- **Crucially, run `dart format`** on changed code before committing.
- **Static Analysis:** Run `flutter analyze` in `packages/uni_app` and fix warnings/errors where possible.

**Manual Formatting:** You can manually format files using `dart format` or by enabling **formatting on save** on your IDE.

**Automated Formatting (Pre-Commit Hook):** Install a git pre-commit hook that formats your changed files when you commit:

```bash
# Make sure you are on the repository root
chmod +x pre-commit-hook.sh && ./pre-commit-hook.sh
```

To remove the hook:
```bash
# Make sure you are on the repository root
rm .git/hooks/pre-commit
```

**Commit Message Format:** Use [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/) style where possible.

**Generated Files and Code Generation:**
- Generated `.dart` files (from `build_runner`, ObjectBox, etc.) **should be committed**.
- If you change code that affects generated files, run the generator and include the results in your PR:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```
- You can also watch for changes in `.dart` files and automatically run the `build_runner` on those file changes (useful if you find yourself in need to generate code very frequently):
```bash
flutter pub run build_runner watch
```

**Translation Files:**
- `Intl` package allows the internationalization of the app, currently supporting Portuguese (`pt_PT`) and English (`en_EN`), by generating `.dart` files (one for each language). The generated files maps a key to the corresponding translated string as you can see at `generated/intl` files.

- How to create:
    1. Add the translations you want in the `.arb` files of the I10n folder:
    
    `intl_en.arb`
    ```json
    {
        "hello": "Hello",
        "@hello": {
            "description": "A conventional newborn greeting"
        }
    }
    ```

    `intl_pt.arb`
    ```json
    {
        "hello": "Olá",
        "@hello": {
            "description": "Uma saudação convencional para cansados"
        }
    }
    ```

    **Note:** [ARB Editor](https://marketplace.visualstudio.com/items?itemName=Google.arb-editor) VS Code extension it's useful to edit .arb files.

    2. Generate the .dart files by running:
    ```bash
    dart pub global activate intl_utils 2.1.0
    dart pub global run intl_utils:generate
    ```

- How to use:
    1. Import the generated file:

    ```dart
    import 'package:uni/generated/l10n.dart';
    ```

    2. And use the translations like this:
    ```dart
    S.of(context).hello
    ```

### Running Tests and CI

**Local Testing:** Run unit and widget tests before opening a PR:
- From the project root: `cd packages/uni_app && flutter test`

**CI Checks:** The project CI will automatically run formatting checks, static analysis, and tests. **Fix any CI failures** shown in the Pull Request view before requesting a review.

### Submitting a Pull Request (PR)

Open a PR against the `develop` branch. This repository fills the description of the PR with a template, which you will need and update with the required information. Associate an issue with the PR if it exists.

### Dependency updates

When updating dependencies, prefer the minimum required version bump. Run the app and tests after updating.