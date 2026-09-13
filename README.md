<div align="center">

<img src="./readme-src/icon.png" width="15%">

<h3>uni, by NIAEFEUP</h3>

[![ktlint badge](https://img.shields.io/github/actions/workflow/status/NIAEFEUP/uni/ktlint.yaml?label=ktlint&branch=develop-native)](https://github.com/NIAEFEUP/uni/actions/workflows/ktlint.yaml)
[![SwiftLint badge](https://img.shields.io/github/actions/workflow/status/NIAEFEUP/uni/swiftlint.yaml?label=swiftlint&branch=develop-native)](https://github.com/NIAEFEUP/uni/actions/workflows/swiftlint.yaml)
[![Android build badge](https://img.shields.io/github/actions/workflow/status/NIAEFEUP/uni/android-build.yaml?label=android%20build&branch=develop-native)](https://github.com/NIAEFEUP/uni/actions/workflows/android-build.yaml)
[![iOS build badge](https://img.shields.io/github/actions/workflow/status/NIAEFEUP/uni/ios-build.yaml?label=ios%20build&branch=develop-native)](https://github.com/NIAEFEUP/uni/actions/workflows/ios-build.yaml)

</div>

## Overview

**uni** is a mobile application created by [NIAEFEUP](https://niaefeup.pt/) to help students at the University of Porto discover and manage academic information in one place. The app aggregates data from the college platform and other services to provide timely information such as schedules, exams, grades and useful campus resources.

## About this branch

`develop-native` is the base for migrating **uni** away from Flutter to fully native UI, with business logic shared between platforms through **Kotlin Multiplatform (KMP)**. This is an active migration, not a finished rewrite — expect gaps compared to the Flutter app for a while.

The stack:

- **`sharedLogic`** — the only module actually shared between platforms. Business logic, data models, networking, etc. live here as common Kotlin, with `expect`/`actual` for the bits that need a platform-specific implementation (`androidMain` / `iosMain`).
- **`androidApp`** + **`sharedUI`** — the Android app, built with **Jetpack Compose**. `sharedUI` holds the Compose UI code, kept in its own module for structure; it is Android-only, not shared with iOS.
- **`iosApp`** — the iOS app, built with **SwiftUI**. It consumes `sharedLogic` as a compiled framework, but has its own native UI, independent from the Android Compose code.

In short: **one shared logic layer, two separate native UIs** — not a cross-platform UI toolkit. If you're picturing Compose Multiplatform rendering on iOS too, that's *not* what this project does.

## Requirements

- **Android**: Android Studio (with the Kotlin Multiplatform plugin) or just a JDK 21 + the Android SDK for CLI builds.
- **iOS**: a Mac with Xcode 16+. Building/running the iOS app is only possible on macOS.

## Getting started

```bash
git clone git@github.com:NIAEFEUP/uni.git
cd uni
```

### Android

No extra setup needed. Open the project root in Android Studio, let it sync, and run the `androidApp` configuration — or from the CLI:

```bash
./gradlew :androidApp:assembleDebug   # build a debug APK
./gradlew :androidApp:installDebug    # install it on a connected device/emulator
```

### iOS

1. Copy `iosApp/Configuration/Local.xcconfig.example` to `iosApp/Configuration/Local.xcconfig` (gitignored — never commit this file).
2. Fill in `TEAM_ID` with the team's Apple Developer Team ID — ask a maintainer if you don't have it, or check Xcode → Settings → Apple Accounts if you're already on the team's account.
   - If you only have a personal/free Apple account (not the team's), also set `BUNDLE_ID_SUFFIX` (e.g. `.yourname.dev`) so you can sign with your own account without clashing with the app's real bundle identifier.
   - Only running on the Simulator? You can skip this whole step — the Simulator doesn't require code signing.
3. Open `iosApp/iosApp.xcodeproj` in Xcode, pick a simulator or device, and hit Run (⌘R). The `sharedLogic` framework is built automatically as part of the Xcode build (it shells out to Gradle behind the scenes).

## Testing

```bash
./gradlew :sharedLogic:testAndroidHostTest :sharedUI:testAndroidHostTest   # Android-side unit tests
./gradlew :sharedLogic:iosSimulatorArm64Test                               # iOS-side unit tests
```

## Linting

Kotlin is linted with [ktlint](https://github.com/pinterest/ktlint), Swift with [SwiftLint](https://github.com/realm/SwiftLint) — both using their default rule sets, no project-specific conventions to learn.

```bash
./gradlew ktlintCheck      # check only
./gradlew ktlintFormat     # auto-fix what it can, report the rest

cd iosApp
swiftlint lint             # check only
swiftlint lint --fix       # auto-fix what it can, report the rest
```

SwiftLint also runs automatically as an Xcode build phase (install it with `brew install swiftlint`, otherwise it just warns and the build still succeeds).

Both are enforced in CI on every PR, and both run locally before every commit once you enable the repo's git hook (one-time, per clone):

```bash
git config core.hooksPath .githooks
```

## License

This application is licensed under the [GNU General Public License v3.0](./LICENSE). See the `LICENSE` file for details.

## Disclaimer

This app is an independent project and is not officially affiliated with the University of Porto or its faculties. The reliability of the information provided by the app is not guaranteed.

## Contributing

We highly value community contributions, which can be submitted via a pull request. Please be aware, though, that a university account is necessary to utilize the majority of the app's functionalities.
