# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter pub get                  # install dependencies
flutter run                      # run the app (prompts for a device if multiple are connected)
flutter run -d chrome            # run on web
flutter run -d macos             # run on macOS desktop
flutter run -d <device-id>       # run on a specific device (see `flutter devices`)
flutter test                     # run all tests
flutter test test/widget_test.dart --plain-name "Counter increments smoke test"  # run a single test
flutter analyze                  # static analysis (uses flutter_lints, see analysis_options.yaml)
```

Project docs (MkDocs Material site under `docs/`):

```bash
pip install -r docs/requirements.txt
mkdocs serve                     # live preview at http://127.0.0.1:8000
mkdocs build                     # outputs static site to site/
```

## Architecture

This is a Flutter app targeting Android, iOS, web, macOS, Linux, and Windows (`android/`, `ios/`, `web/`, `macos/`, `linux/`, `windows/` are the standard Flutter-generated platform shells; don't hand-edit them except for platform config like permissions, bundle IDs, icons, entitlements).

`lib/main.dart` is currently the sole source file and is still the unmodified `flutter create` counter template: `main()` boots `MyApp` (`StatelessWidget`, sets up `MaterialApp`), which shows `MyHomePage` (`StatefulWidget`, a counter screen with a FAB). There is no routing, state management library, or data layer yet — as those get introduced, record the decision and reasoning in `docs/architecture.md`, not just in code.

Project documentation lives in `docs/` (MkDocs Material, config in `mkdocs.yml`) and is meant to be kept current alongside the code — update the relevant page in the same change that adds or alters behavior. See `docs/contributing.md` for the convention.

### Android build note

`android/gradle.properties` pins `org.gradle.java.home` to Android Studio's bundled JBR, and Flutter's own JDK selection is pinned via `flutter config --jdk-dir` (machine-level, not in the repo). This exists because this machine has multiple JDKs on PATH (including a Homebrew `openjdk` build newer than what the project's Gradle wrapper version supports), which previously caused IDE Gradle sync to fail with `The supplied phased action failed with an exception.` If Android/Gradle builds fail after a JDK or Android Studio reinstall, see the Troubleshooting section in `docs/getting-started.md`.
