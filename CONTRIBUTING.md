# Contributing to UNI
 
Want to make life easier for students at the University of Porto? Amazing! 

We have a full guide on how to run UNI locally.

## Topics

- [Project Structure](#project-structure)
- [Reporting Security Issues](#reporting-security-issues)
- [Reporting other issues](#reporting-other-issues)
- [How to contribute to UNI (guide)](#how-to-contribute-to-uni-guide)
- [Conventions](#conventions)
- [Useful commands](#useful-commands)
- [UNI community guidelines](#uni-community-guidelines)
- [Coding Style](#coding-style)

## Project Structure

The UNI code base is divided into packages:
```
uni_ui/ -> UI components that can be reused and themes definitions
uni_app/ -> Includes the main.dart file as well as all the views, providers and controllers
uni_lint/ -> linter configurations
```

When fixing bugs or creating new features, you will mostly work on uni_app

### Layer overview of uni_app

```
view/          → Riverpod consumer widgets; never call fetchers or controllers directly
model/
  providers/   → CachedAsyncNotifier subclasses; reactive state + cache management
  entities/    → ObjectBox @Entity models (pure data)
controller/
  fetchers/    → HTTP + HTML → entity; implement SessionDependantFetcher
  parsers/     → HTML → entity (called by fetchers)
  local_storage/ → ObjectBox DB, SharedPreferences, migrations
  networking/  → NetworkRouter; builds Sigarra URLs from session
http/client/   → AuthenticatedClient (cookie injection), TimeoutClient
session/       → two auth flows (credentials vs federated OIDC)
sigarra/       → typed Sigarra endpoint definitions
```

## Reporting Security Issues
We take the security of our users' data very seriously. If you found some security issue in the code please contact us right away!

Please **DO NOT** file a public issue, instead contact us via Report bug page or via email to ni@aefeup.pt.

## Reporting other issues
Reporting issues is an amazing way to help build a better UNI.

You can report bugs via Bug report page right on your UNI app and we receive it via Sentry, but if you wish you can check our open issues and add a new issue to the bug if not there yet.

When reporting a bug please try to be as specific as possible by:
- write an extensive description of the bug
- describe the path to find that bug
- screenshots (if applicable)
- Operating System and App version

The more information you give, the easier it is to fix the bug and make UNI even better!

## How to contribute to UNI (guide)

1. Find an issue you really want to work with (make sure it's not already assigned to anyone) and assign yourself or ask a maintainer to do it for you.

2. Fork the UNI repository.

3. Clone your forked repo to your machine.

4. Make changes to the codebase and commit them.

5. Go to your forked repo on GitHub and click on `Contribute` when opening a PR

6. Wait for a maintainer to review and approve your code, or ask for changes

## Conventions
When creating a new issue or when pushing code make sure you follow the branch naming conventions:

- feat/ or feature/ for new functionalities
- fix/ or bugfix/ for error correction
- hotfix/ for critical corrections in production
- refactor/ for refactoring of existing code
- docs/ for changes in the documentation
- chore/ for maintenance tasks
- test/ for creation or changes of tests

## Useful commands

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

## UNI community guidelines
We want to keep UNI community together and collaborative. To help us achieve that follow these simple rules:

- Be nice: be respectful and nice to other collaborators and to maintainers. No type of discrimination will be tolerated.

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
