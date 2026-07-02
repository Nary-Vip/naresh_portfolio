# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

A single-page developer portfolio for R M Naresh Kumar, built as a **Flutter Web** app and deployed to **Firebase Hosting**. Despite the multi-platform Flutter scaffolding (android/ios/macos/linux/windows), the web target is the only one that ships.

## Commands

```bash
flutter pub get                 # install dependencies
flutter run -d chrome           # local dev (hot reload)
flutter analyze                 # lint (flutter_lints via analysis_options.yaml)
flutter test                    # run all tests
flutter test test/widget_test.dart --plain-name "name"   # run a single test

flutter build web               # production build -> build/web
firebase deploy --only hosting:site_alias   # deploy build/web (project "narychats", site naresh-portfolio-sde)
```

Note: `main.dart` sets `showPerformanceOverlay: true`, so the FPS overlay renders in every run — remove it before a real release if it is undesired.

## Environment

Secrets live in `.env` (bundled as a Flutter asset via `pubspec.yaml`, **not** a server-side secret — it ships in the web build):

- `GEMINI_API_KEY` — Google AI Studio key for the chatbot
- `WEB3FORMS_ACCESS_KEY` — Web3Forms key for the contact form

Both are read lazily through getters in `lib/core/utils/portfolio_data.dart`; missing keys degrade gracefully (chatbot returns null → local fallback, form uses a placeholder key).

## Architecture

Feature-first layout under `lib/`:

- **`core/`** — cross-cutting concerns:
  - `theme/` — `AppTheme` (static light/dark `ThemeData`), `ThemeProvider` (a `ChangeNotifier`, default dark), and `CircularThemeReveal`/`AnimatedTheme` for the animated theme toggle.
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

`GeminiService` is static/stateless. On each request it:
1. Extracts text from the bundled `resume.pdf` via `syncfusion_flutter_pdf` (cached in `_cachedResumeText`).
2. Builds a system prompt from `nareshPortfolioData` + resume text in `_buildSystemContext`.
3. Calls `gemini-2.5-flash-lite` — `getChatResponse` (single-shot) or `getChatResponseStream` (SSE streaming). OpenAI-style `user`/`assistant` roles are mapped to Gemini `user`/`model`.

When editing portfolio content, remember it feeds both the rendered UI **and** the chatbot's system context.
