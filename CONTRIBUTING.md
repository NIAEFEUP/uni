# Contributing to uni

Want to make life easier for students at the University of Porto? Amazing!

**uni** is primarily developed and maintained by **[NIAEFEUP](https://niaefeup.pt/)**. However, we believe that the best tools are built by the community, and outside contributions are always welcome!

### Important: University Account Required
Please note that to contribute effectively and explore all of the app's features (such as schedules, grades, and private student data), **you must have a valid University of Porto (Sigarra) account**. Most of the app's core functionality relies on authenticated requests to university systems.

## Topics

- [Documentation & Guides](#documentation--guides)
- [Reporting Security Issues](#reporting-security-issues)
- [Reporting Other Issues](#reporting-other-issues)
- [How to Contribute to uni](#how-to-contribute-to-uni)
- [Conventions](#conventions)
- [Useful Commands](#useful-commands)
- [uni Community Guidelines](#uni-community-guidelines)
- [Coding Style](#coding-style)
- [Community & Support](#community--support)

## Documentation & Guides

To keep our documentation fresh and accessible, our technical guides are at the **[Project Wiki](https://github.com/niaefeup/uni/wiki)**. Please consult the wiki before starting your development journey.

### Getting Started
* **New to the project?** Start with the **[Development Setup](https://github.com/niaefeup/uni/wiki/Development-Setup)** guide.
* **Need to run the app?** Check out **[Running the App](https://github.com/niaefeup/uni/wiki/Running-the-App)**.
* **Want to understand the code?** Read the **[Architecture Overview](https://github.com/niaefeup/uni/wiki/Architecture-Overview)**.

## Reporting Security Issues
We take the security of our users' data very seriously. If you found some security issue in the code please contact us right away!

Please **DO NOT** file a public issue, instead contact us via Report bug page or via email to ni@aefeup.pt.

## Reporting Other Issues
Reporting issues is an amazing way to help build a better uni.

You can report bugs via Bug report page right on your uni app and we receive it via Sentry, but if you wish you can check our open issues and add a new issue to the bug if not there yet.

When reporting a bug please try to be as specific as possible by:
- write an extensive description of the bug
- describe the path to find that bug
- screenshots (if applicable)
- Operating System and App version

The more information you give, the easier it is to fix the bug and make uni even better!

## How to Contribute to uni

1.  **Find an Issue**: Browse our [open issues](https://github.com/niaefeup/uni/issues). If you have a new idea, open an issue first to discuss it with the team.
2.  **Fork & Branch**: Create a feature branch from `develop` using our [Conventional Branching](https://github.com/niaefeup/uni/wiki/Branching-&-Commits) rules (e.g., `feat/add-new-widget`).
3.  **Code & Lint**: Write your code and ensure it passes our linting checks. We use a [pre-commit hook](https://github.com/niaefeup/uni/wiki/Code-Formatting-&-Linting) to maintain code quality.
4.  **Submit a Pull Request**: Open a PR against the `develop` branch. Ensure you fill out the PR template provided.

### Pull Request Checklist
- [ ] I have synced my branch with the latest `develop`.
- [ ] My code follows the project's [linting and formatting](https://github.com/niaefeup/uni/wiki/Code-Formatting-&-Linting) rules.
- [ ] I have run [build_runner](https://github.com/niaefeup/uni/wiki/Code-Generation) if I modified any database entities or providers.
- [ ] I have tested the changes an emulator or device.

## Useful Commands

```bash
# Dependencies
flutter pub get

# Code quality (run in this order before committing)
dart fix --apply && dart format . && dart analyze .

# Tests
flutter test
flutter test test/path/to/test_file.dart   # single file

# Code generation (ObjectBox, JsonSerializable, Mockito)
dart pub run build_runner build --delete-conflicting-outputs

# Localization — after editing .arb files in /l10n/
dart pub global activate intl_utils 2.1.0
dart pub global run intl_utils:generate
```

Linter: `leancode_lint` + `custom_lint`. Generated files (`**.g.dart`, `**.mocks.dart`, `**/generated/**`) are excluded from analysis and must be committed.

## uni Community Guidelines
We want to keep uni community together and collaborative. To help us achieve that follow these simple rules:

- Be nice: Be respectful and nice to other collaborators and to maintainers. No type of discrimination will be tolerated.

- Keep it legal: Try not to get us in trouble. Make sure that the code you push is yours and not protected by any type of rights that might get us in trouble in the future.

- Encourage participation: If you like to work with us, then bring your friends and colleagues with you, we are thrilled to grow our community.

## Coding Style
You may notice that our codebase has lots of different code styles. That's what happens when you have an old codebase that had little refactors.

However we appreciate that you follow the recent architecture that you can see on newer files like using Riverpod for providers and others.

All your code must:
- Be formatted using the format command stated above
- Pass all the tests (if not, update the current tests)
- Pass all the linter requirements
- Follow our file naming convention
- Be readable: keep variable names short and comment your code every time you feel it is not obvious to understand it

## Community & Support

Need help?
* Reach out via our [socials](https://linktr.ee/niaefeup) or our [website](https://niaefeup.pt).
