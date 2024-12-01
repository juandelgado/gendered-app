# Development

The Gendered app is built with [Flutter](https://flutter.dev/) using the [Very Good Ventures Starter App template](https://cli.vgv.dev/docs/templates/core).

## Setup and configuration

These are our recommendations:

- Xcode through [Xcodes](https://www.xcodes.app/), then [Configure iOS development](https://docs.flutter.dev/get-started/install/macos/mobile-ios#configure-ios-development).
- [Android Studio](https://developer.android.com/studio), then [Configure Android development](https://docs.flutter.dev/get-started/install/macos/mobile-android#configure-android-development).
- Flutter `3.24.5` through [FVM](https://fvm.app/).
- [VSCode](https://code.visualstudio.com/) with the Flutter plugin.


Mobile development toolchains are never straight forward, but `flutter doctor` provides decent support for troubleshooting.

## Run

The Gendered app comes with 2 flavours, `development` and `production`:

```sh
flutter run --flavor development --target lib/main_development.dart
flutter run --flavor production --target lib/main_production.dart
```

## Test

```sh
flutter test --coverage --test-randomize-ordering-seed random
```

## CI

TBD