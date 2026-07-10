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
flutter test test/widget_test.dart --plain-name "Splash screen shows the brand name and a progress indicator"  # run a single test
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

**SalatTime** is organized feature-first under `lib/`: `main.dart` builds shared services/repositories and wires a `MultiProvider` root; `app.dart` sets up `MaterialApp.router` with light/dark theme + `go_router`. `core/` holds cross-feature code (`theme/`, `router/`, `network/` — a shared `Dio` client, `storage/` — a `SharedPreferences` wrapper). `features/` has one folder per feature (`splash`, `auth`, `prayer_times`, `settings`, `shell`), each shaped as `data/` (models + API client + one concrete repository, no abstract interface/domain layer — see `docs/architecture.md` "Layering") and `presentation/` (`providers/` for `ChangeNotifier`s, `screens/`, `widgets/`).

Key decisions — state management is **Provider** (not Riverpod/Bloc), routing is **go_router** with auth-gated redirects, theming is built from `DESIGN.md`'s exact hex/typography tokens (light) with an algorithmically-derived dark scheme, and prayer times come from the real **Aladhan public API** via Dio. Login is a **mock OTP flow** (no real SMS backend). Full rationale for each of these, plus an explicit "not yet built" list (geolocation, real notifications/adhan audio, Qibla/Dua tabs, etc.), lives in `docs/architecture.md` — read it before making structural changes, and update it in the same change whenever a decision here gets revisited.

Project documentation lives in `docs/` (MkDocs Material, config in `mkdocs.yml`) and is meant to be kept current alongside the code — update the relevant page in the same change that adds or alters behavior. See `docs/contributing.md` for the convention.

### Design tokens

`DESIGN.md` at the repo root is the source of truth for colors, typography, spacing, and shape — it's what `lib/core/theme/` is generated from. Update it first if the design changes, then propagate to the theme files.

### Commits

A project skill at `.claude/skills/commit-push/SKILL.md` handles `/commit-push` (stage → commit → confirm → push). Commit subjects follow [Conventional Commits](https://www.conventionalcommits.org/) (`type(scope): description`) going forward — don't match the freeform style of commits made before that convention was adopted.

### Android build note

`android/gradle.properties` pins `org.gradle.java.home` to Android Studio's bundled JBR, and Flutter's own JDK selection is pinned via `flutter config --jdk-dir` (machine-level, not in the repo). This exists because this machine has multiple JDKs on PATH (including a Homebrew `openjdk` build newer than what the project's Gradle wrapper version supports), which previously caused IDE Gradle sync to fail with `The supplied phased action failed with an exception.` If Android/Gradle builds fail after a JDK or Android Studio reinstall, see the Troubleshooting section in `docs/getting-started.md`.
