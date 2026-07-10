# Architecture

## Current structure

The app is organized feature-first under `lib/`:

```
lib/
  main.dart              # builds shared services/repositories, wires MultiProvider, runApp
  app.dart               # MaterialApp.router: light/dark theme + GoRouter

  core/
    theme/                # design tokens (DESIGN.md) -> Color/TextTheme/ThemeData
    router/                # GoRouter config + route path constants
    network/                # shared Dio instance (core/network/dio_client.dart)
    storage/                # SharedPreferences wrapper (core/storage/local_storage_service.dart)

  features/
    splash/presentation/screens/splash_screen.dart
    auth/                  # mock OTP login, persisted auth status
    prayer_times/          # Aladhan API integration, home screen
    settings/               # notification/sound prefs, calculation method, danger zone
    shell/                 # bottom-nav shell hosting the tabs above
```

Each feature under `features/` follows the same shape: `data/` (models + API client + one concrete repository — see "Layering" below) and `presentation/` (`providers/` for `ChangeNotifier`s, `screens/`, `widgets/`). `splash` and `shell` have no `data/`, since they don't touch external data.

## Decisions

### State management: Provider

`ChangeNotifier` + `ChangeNotifierProvider`/`Consumer`/`context.watch`/`context.read`, not Riverpod or Bloc. Chosen directly by the project owner; revisit only with an explicit decision, not silently.

### Routing: go_router, auth-gated

`core/router/app_router.dart` builds a `GoRouter` with `refreshListenable: authProvider`. `SplashScreen` (not the router) owns the initial navigation away from `/splash`: it waits for both its own minimum-display animation (~2.4s) and `AuthProvider` finishing its async restore from `SharedPreferences`, then calls `context.go()` to `/login` or `/home`. The router's `redirect` callback only guards `/login` and `/home` afterward (e.g. if auth status changes while already on one of those routes, or a deep link lands on the wrong one) — it deliberately does *not* redirect away from `/splash`, since that would race the animation timer.

### Theming: exact light palette + seeded dark

`core/theme/app_colors.dart` holds every DESIGN.md hex token as a `Color` constant. `core/theme/app_theme.dart`'s `lightColorScheme` is built directly from those (not seeded) since they're designer-specified. `darkColorScheme` is `ColorScheme.fromSeed(seedColor: AppColors.primaryContainer, brightness: Brightness.dark)` — DESIGN.md only specifies a light palette, so dark is algorithmically derived from the brand's primary emerald rather than hand-authored. `background`/`onBackground`/`surfaceVariant` from DESIGN.md are deliberately **not** set on `ColorScheme` (deprecated since Flutter 3.18); their values are folded into `surface`/`onSurface`/`surfaceContainerHighest` instead. Typography (`core/theme/app_typography.dart`) uses `google_fonts` (Source Serif 4 for display/headline roles, Manrope for body/label), fetched at runtime — fine for development, but should be bundled as local font assets (`GoogleFonts.config.allowRuntimeFetching = false`) before any offline/store release.

### Networking: Dio + Aladhan public API

`core/network/dio_client.dart` builds one shared `Dio` instance (base URL, timeouts, debug-only logging). `features/prayer_times/data/prayer_times_api_client.dart` calls Aladhan's `GET /v1/timingsByCity?city=&country=&method=`. `method` is no longer hardcoded — it's `SettingsProvider.calculationMethod.id`, defaulting to Muslim World League (3) but user-selectable in Settings (`features/settings/data/models/calculation_method.dart` lists the five options with their Aladhan method ids). `features/prayer_times/data/prayer_times_repository.dart` wraps the client and maps `DioException`s to a short user-facing `PrayerTimesFailure` message.

### Layering: simplified, not flattened

Each feature has a concrete `data/` repository (no abstract repository interface) and the DTO doubles as the UI-facing entity (no separate domain layer). This is proportionate for a single real data source with no requirement yet to swap implementations or test against fakes-via-interface — a concrete repository class is still kept (rather than calling Dio straight from a provider) so JSON parsing/error mapping stays out of UI-facing state code. Revisit if a second data source or serious unit-test coverage arrives.

### Auth: real OTP backend (send + verify), persisted locally

`features/auth/data/auth_api_client.dart` calls a real PHP backend at `https://www.bdappsdigitalapps.com/mosfeqanik/` (a second `Dio` instance, separate from the Aladhan one — wired in `main.dart`): `POST send_otp.php` and `POST verify_otp.php`, both `application/x-www-form-urlencoded` (required — the PHP reads `$_POST`, and Dio's `FormData` sends `multipart/form-data` instead, a different wire format, so every call sets `Options(contentType: Headers.formUrlEncodedContentType)` explicitly). The field is `user_mobile`, the local 11-digit BD number as typed (no transformation, no country code). Both endpoints return `{"success": bool, "message"?: string, "referenceNo"?: string, ...}`; a `success: false` response's `message` is surfaced to the user as-is.

**Unconfirmed:** the verify request's field name for the code itself (`otp_code` in `auth_api_client.dart`) was never confirmed against the real `verify_otp.php` script — if verification always fails with a generic message, check this first. Also unconfirmed: whether this backend sends CORS headers, so Flutter web may fail here even though Android/iOS work (Dio's native stack isn't subject to browser CORS) — if hit, the fix is server-side, not a client workaround.

`AuthRepository.sendOtp` only calls the API — it does not persist anything (sending an OTP isn't authentication). `AuthRepository.verifyOtp` persists via `SharedPreferences` (`LocalStorageService.setAuthenticated`) only on a successful verify. `AuthProvider` models the login screen's two steps with a separate `LoginStep` enum (`enterPhone`/`enterCode`) rather than adding a third `AuthStatus` value, since the router's redirect logic only ever branches on `authenticated`/`unauthenticated` and shouldn't need to know about the in-between "OTP sent, awaiting code" state.

### City selection: hardcoded list, no geolocation

`features/prayer_times/data/models/selected_city.dart` ships ~7 hardcoded `(name, country)` pairs, default Mecca/SA, switchable via a bottom sheet with local text filtering, persisted via `SharedPreferences`. Deliberately **no device geolocation** ("Current Location") in v1 — real permission flows across Android/iOS/web were judged disproportionate scope for this first version.

### Settings: real prefs + danger zone, no notification/audio delivery yet

`features/settings/presentation/providers/settings_provider.dart` persists notification/sound toggle state and the calculation method via `LocalStorageService`. The toggles are **UI-only preferences right now** — no `flutter_local_notifications` or adhan audio playback is wired up, so flipping them doesn't yet change runtime behavior beyond being remembered. The calculation method *is* fully functional (see "Networking" above). "Reset App Data" clears all `SharedPreferences` (`LocalStorageService.clearAll()`, exposed app-wide via a plain `Provider<LocalStorageService>` in `main.dart`), resets `SettingsProvider`/`CityProvider`/`PrayerTimesProvider` in-memory state to defaults, and logs out via `AuthProvider.logout()` — which the router picks up and redirects to `/login`.

## Not yet built (explicitly deferred, not forgotten)

- Device geolocation for auto-detecting the user's city.
- Free-text city search (currently a fixed list only).
- Confirming the verify-OTP code field name and this backend's CORS headers against the real server (see "Auth" above — both currently unconfirmed assumptions).
- A resend cooldown timer, and OTP length validation (currently accepts any non-empty code).
- Actual notification delivery and adhan audio playback (Settings toggles currently only persist a preference).
- Qibla and Dua tabs (currently `ComingSoonTab` placeholders in `features/shell/`).
- Bundled Google Fonts as local assets (currently fetched at runtime).
- go_router `StatefulShellRoute.indexedStack` (nested per-tab navigation) — only worth adding once the placeholder tabs above get real content/deep links; the shell currently uses a plain `IndexedStack` + local tab-index state.

## Platform targets

The `android/`, `ios/`, `web/`, `macos/`, `linux/`, and `windows/` directories are the standard Flutter-generated platform shells. They're not usually hand-edited except for platform configuration (permissions, bundle IDs, app icons, entitlements).
