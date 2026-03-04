# API key setup

The project does not store TheCatAPI key in source code.

Use `--dart-define` at run/build time:

```bash
flutter run --dart-define=CAT_API_KEY=your_key_here
```

```bash
flutter build apk --dart-define=CAT_API_KEY=your_key_here
```
