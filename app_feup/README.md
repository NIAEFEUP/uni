# app_feup

An app to make the lives of FEUP students easier.
[View changelog here](changelog.md)

## Getting Started

This project is a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view the
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## Requirements

In order to submit bug reports to the Github API, a Github Personal Access Token is required.
If you don't have one, you can create it on https://github.com/settings/tokens. The only permission it needs is **repo > public_repo**.

The token is read from the file ```assets/env/env.json```, which you may need to create, and must be in the following format:

```json
{
  "gh_token" : "your super secret token"
}
```

## Release

To release the app, a few steps are required:

- Make sure the terms and conditions do not need updating
- Make sure you have completed the **Requirements** section of this README
- Increase the version in pubspec.yaml
- Fill the fields in android/key.properties. [This might require creation of a store](https://flutter.dev/docs/deployment/android)
- Run `flutter build appbundle lib/main.dart` to generate the bundle ready for upload
- Make sure the Play Store's Content Rating is accurate before rolling out the app

[Here's the full guide to releasing a flutter application](https://flutter.dev/docs/deployment/android)