# Architecture

## Current structure

```
lib/
  main.dart   # app entry point; defines MyApp and MyHomePage
```

`lib/main.dart` is currently the unmodified `flutter create` template:

- `main()` boots `MyApp`.
- `MyApp` (`StatelessWidget`) sets up a `MaterialApp` with a single seeded color scheme.
- `MyHomePage` (`StatefulWidget`) renders a counter screen with a floating action button.

There is no routing, state management library, or data layer yet.

## Platform targets

The `android/`, `ios/`, `web/`, `macos/`, `linux/`, and `windows/` directories are the standard Flutter-generated platform shells. They're not usually hand-edited except for platform configuration (permissions, bundle IDs, app icons, entitlements).

## Conventions to establish as the app grows

This section is intentionally sparse — update it as real decisions are made, rather than pre-deciding an architecture the code doesn't have yet. When you introduce one of the following, document the choice and the reasoning here:

- **State management** (e.g. Provider, Riverpod, Bloc)
- **Navigation/routing** approach
- **Folder structure** under `lib/` (e.g. feature-first vs. layer-first)
- **Data/networking layer**, if the app talks to external services
