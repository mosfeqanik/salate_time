# Getting Started

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) matching the constraint in `pubspec.yaml` (`sdk: ^3.11.5`)
- A configured target: Android Studio/SDK for Android, Xcode for iOS/macOS, or a Chrome install for web

Verify your setup:

```bash
flutter doctor
```

## Install dependencies

```bash
flutter pub get
```

## Run the app

```bash
flutter run
```

`flutter run` will prompt for a target device if more than one is available. To target a specific platform directly:

```bash
flutter run -d chrome    # web
flutter run -d macos     # macOS desktop
```

## Run tests

```bash
flutter test
```

## Static analysis

The project uses `flutter_lints` (see `analysis_options.yaml`). Run:

```bash
flutter analyze
```

## Working on these docs

Docs are built with [MkDocs](https://www.mkdocs.org/) and the [Material theme](https://squidfunk.github.io/mkdocs-material/).

```bash
pip install -r docs/requirements.txt
mkdocs serve   # live preview at http://127.0.0.1:8000
mkdocs build   # outputs static site to site/
```

## Troubleshooting

### "The supplied phased action failed with an exception" / a bare version number like `26.0.1` during Gradle sync

This happens when the IDE's Gradle sync (Android Studio, or VS Code's Dart/Flutter extension) picks up a JDK that the project's Gradle wrapper doesn't support running on — e.g. a newer JDK installed via Homebrew (`brew install openjdk` installs an unversioned, always-latest formula alongside any pinned `openjdk@N` you may already have) that ends up ahead of the intended JDK depending on how the IDE resolves its environment (GUI-launched apps don't always inherit shell PATH ordering from `~/.zshrc`/`~/.bashrc` the way a terminal does).

**Fix:** the Gradle JVM is pinned explicitly in `android/gradle.properties` via `org.gradle.java.home`, and Flutter's own JDK selection is pinned via `flutter config --jdk-dir`. Both currently point at Android Studio's bundled JBR. If this recurs (e.g. after reinstalling Android Studio or a JDK), check:

- `android/gradle/wrapper/gradle-wrapper.properties` for the Gradle version in use, and confirm it supports the JDK version referenced by `org.gradle.java.home`.
- Re-point `org.gradle.java.home` in `android/gradle.properties` and re-run `flutter config --jdk-dir=<path>` at a supported JDK.
- Verify with `cd android && ./gradlew --version` — the `Daemon JVM` line should show the pinned JDK regardless of the current shell's `JAVA_HOME`/PATH.
