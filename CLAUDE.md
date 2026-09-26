# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

A single-page developer portfolio for R M Naresh Kumar, built as a **Flutter Web** app and deployed to **Firebase Hosting**. Despite the multi-platform Flutter scaffolding (android/ios/macos/linux/windows), the web target is the only one that ships.

## Commands

```bash
flutter pub get                 # install dependencies
flutter run -d chrome --dart-define-from-file=.env   # local dev (hot reload)
flutter analyze                 # lint (flutter_lints via analysis_options.yaml)
flutter test                    # run all tests
flutter test test/widget_test.dart --plain-name "name"   # run a single test

flutter build web --dart-define-from-file=.env   # production build -> build/web
firebase deploy --only hosting:site_alias   # deploy build/web (project "narychats", site naresh-portfolio-sde)
```

## Environment

Config lives in the gitignored `.env` and is compiled in with `--dart-define-from-file=.env` (read via `String.fromEnvironment`) — it ends up in `main.dart.js`, so it is **not** a secret:

- `WEB3FORMS_ACCESS_KEY` — Web3Forms key for the contact form (`lib/core/utils/portfolio_data.dart`). Build without the flag and the form shows "not configured" instead of sending.

The chatbot needs no client key: it calls a Cloudflare Worker proxy (`naresh-gemini-proxy.nary-vip.workers.dev`) that holds the Gemini key.

## Architecture

Feature-first layout under `lib/`:

- **`core/`** — cross-cutting concerns:
  - `theme/` — `AppTheme` (static light/dark `ThemeData`, built once) and `ThemeProvider` (a `ChangeNotifier`, default dark). The toggle animation is `MaterialApp`'s own `themeAnimationDuration`.
  - `services/gemini_service.dart` — all AI chatbot logic.
  - `utils/portfolio_data.dart` — the single source of truth for **all portfolio content** (bio, skills, experience, projects, certs, FAQs, metrics) as a const `nareshPortfolioData` object plus the typed model classes. Edit content here, not in widgets.
  - `utils/responsive.dart` — `Responsive` widget + breakpoints: mobile `<768`, tablet `768–1200`, desktop `≥1200`.
- **`features/portfolio/presentation/`** — `portfolio_screen.dart` is the whole page: a scrolling `Stack` that composes the section widgets in `widgets/` and holds `GlobalKey`s used for nav-driven `Scrollable.ensureVisible` smooth scrolling. Each section (hero, metrics, skills, experience, projects, etc.) is its own widget in `widgets/`.

### State management

No external state library. State flows through:
- `ThemeProvider` exposed via a custom `AppScope` `InheritedNotifier` in `main.dart` — access with `AppScope.of(context)`.
- `MaterialApp` rebuilds via `ListenableBuilder` on the provider.
- Local `StatefulWidget` state elsewhere (e.g. chat open/closed in `portfolio_screen.dart`).

### Chatbot (Gemini)

`GeminiService` is static/stateless. The system prompt is built once from `nareshPortfolioData` (`_buildSystemContext`), then each request goes to the proxy — `getChatResponse` (single-shot) or `getChatResponseStream` (SSE streaming). OpenAI-style `user`/`assistant` roles are mapped to Gemini `user`/`model`.

When editing portfolio content, remember it feeds both the rendered UI **and** the chatbot's system context. The downloadable resume is `web/resume.pdf` (served at `/resume.pdf` by the "View Resume" button) — replace it whenever the resume changes.
