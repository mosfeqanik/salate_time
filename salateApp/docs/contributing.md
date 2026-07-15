# Contributing

## Code

- Run `flutter analyze` and `flutter test` before committing.
- Follow the lint rules in `analysis_options.yaml` (`flutter_lints`).
- Prefer small, focused commits with messages that explain *why*, not just *what*.

## Keeping docs current

These docs live in `docs/` and are versioned alongside the code. When a change affects how the app is run, structured, or built:

1. Update the relevant page in the same PR/commit as the code change.
2. If you introduce a new architectural decision (state management, routing, a new top-level `lib/` folder, etc.), add it to [Architecture](architecture.md) instead of leaving it implicit in the diff.
3. For notable user-facing or structural changes, add an entry to [Changelog](changelog.md).

Docs that drift from the code are worse than no docs — if you're not sure a page is still accurate, flag it rather than leaving it silently stale.

## Previewing changes

```bash
pip install -r docs/requirements.txt
mkdocs serve
```

This serves the site locally with live reload at `http://127.0.0.1:8000`.
