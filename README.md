# SecureChat X 2.0

This repository contains the Phase 1 client foundation for SecureChat X 2.0.

The running shell provides typed configuration and errors, explicit future
storage/database/transport contracts, a dark-first design-token baseline, and
routed foundation destinations. Messaging, identity, encryption, database,
calls, and server connectivity are intentionally **not implemented**; the UI
does not claim otherwise.

## Development

```sh
flutter pub get
dart format .
flutter analyze
flutter test
flutter build apk --debug
```

Use non-secret Dart defines only for environment selection:

```sh
flutter run --dart-define=SECURECHAT_ENV=development --dart-define=SECURECHAT_PROTOCOL_VERSION=1
```

Release signing must be provided through protected local or CI configuration;
the Android project deliberately does not use the debug signing key for release builds.

A new Flutter project created with FlutLab - https://flutlab.io

## Getting Started

A few resources to get you started if this is your first Flutter project:

- https://flutter.dev/docs/get-started/codelab
- https://flutter.dev/docs/cookbook

For help getting started with Flutter, view our
https://flutter.dev/docs, which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Getting Started: FlutLab - Flutter Online IDE

- How to use FlutLab? Please, view our https://flutlab.io/docs
- Join the discussion and conversation on https://flutlab.io/residents
