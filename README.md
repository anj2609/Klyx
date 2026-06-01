# Klyx

A premium dark-themed Flutter application for competitive programmers to track their coding stats across **LeetCode**, **GitHub**, and **Codeforces** — all in one place.

## Features

- **Unified Dashboard** — View LeetCode problems solved, GitHub contributions, Codeforces rating, and streak data in a single glance via animated stat cards.
- **Customizable Home Grid** — Drag-and-drop widget builder lets you arrange and resize dashboard widgets to your preference (persisted locally).
- **GitHub Deep-Dive** — Full contribution heatmap, top repos, follower count, and streak tracking via the GitHub GraphQL API.
- **Competitive Programming View** — LeetCode difficulty breakdown (Easy/Medium/Hard), Codeforces rating graph, recent submissions, and upcoming contests.
- **Contest Notifications** — Auto-scheduled local notifications for upcoming Codeforces contests at 8 hours, 1 hour, 15 minutes, and start time.
- **Friends System** — Add friends by their platform usernames, compare stats side-by-side, and track their progress.
- **Leaderboard** — Rank yourself against your friends using a composite score (LC Solved + GH Contribs + CF Rating).
- **Skip Login** — Users can explore the app with empty-state dashboards before connecting any platform.

---

## Architecture

```
lib/
├── main.dart                        # App entry point, GoRouter, theme
├── core/
│   └── theme/
│       └── colors.dart              # KlyxColors design tokens
├── features/
│   ├── auth/                        # Authentication feature
│   │   ├── auth_model.dart          # UserProfile model
│   │   ├── auth_notifier.dart       # Riverpod AsyncNotifier for auth state
│   │   ├── auth_provider.dart       # Provider definitions
│   │   └── login_screen.dart        # Login / connect-platforms UI
│   ├── friends/                     # Friends feature
│   │   ├── friend_model.dart        # Friend data model (JSON serialisation)
│   │   ├── friend_stats_model.dart  # FriendStats computed from APIs
│   │   ├── friends_repository.dart  # SharedPreferences CRUD layer
│   │   ├── friends_notifier.dart    # AsyncNotifier for friends list
│   │   ├── friends_provider.dart    # Provider definitions + friendStatsProvider
│   │   ├── friends_screen.dart      # Friends list UI
│   │   ├── friend_detail_screen.dart# Friend detail + compare + remove
│   │   └── add_friend_sheet.dart    # Bottom sheet to add a friend
│   └── widget_builder/             # Customisable home grid
│       ├── widget_config_model.dart # WidgetConfig serialisation
│       ├── widget_type.dart         # Enum of available widget types
│       ├── widget_size.dart         # Small / Medium / Large sizing
│       ├── widget_renderer.dart     # Renders each widget type
│       ├── widget_builder_screen.dart # Drag & drop editor
│       ├── widget_builder_notifier.dart
│       ├── widget_builder_provider.dart
│       └── home_grid_view.dart      # Staggered grid on dashboard
├── models/
│   ├── dashboard_stats.dart         # Aggregated stats model
│   └── github_stats.dart            # GitHub-specific stats model
├── services/
│   ├── platform_services.dart       # GitHubService, LeetCodeService, CodeforcesService
│   ├── api_providers.dart           # Riverpod providers for services
│   ├── notification_service.dart    # flutter_local_notifications wrapper
│   └── persistence_service.dart     # SharedPreferences + FlutterSecureStorage
├── ui/
│   ├── views/
│   │   ├── dashboard_view.dart      # Main dashboard (bottom nav host)
│   │   ├── github_view.dart         # GitHub stats page
│   │   ├── competitive_view.dart    # LeetCode + Codeforces combined view
│   │   ├── leaderboard_view.dart    # Friends leaderboard
│   │   ├── connect_stack_view.dart  # Stack of connect-platform cards
│   │   └── settings_view.dart       # Settings / profile management
│   └── widgets/
│       ├── klyx_card.dart           # Reusable rounded card component
│       ├── klyx_badge.dart          # Small badge/pill widget
│       └── contribution_grid.dart   # GitHub heatmap grid
└── viewmodels/
    ├── dashboard_viewmodel.dart     # Orchestrates API calls → DashboardStats
    └── github_viewmodel.dart        # GitHub-specific data fetching
```

### Design Patterns

| Pattern | Usage |
|---------|-------|
| **Riverpod (AsyncNotifier)** | All state management — auth, dashboard, friends, widget builder |
| **Repository Pattern** | `FriendsRepository` abstracts SharedPreferences CRUD |
| **Feature-first Organisation** | Each feature (`auth`, `friends`, `widget_builder`) is self-contained |
| **Service Layer** | `platform_services.dart` wraps Dio HTTP calls to external APIs |
| **GoRouter** | Declarative routing with auth-guard redirect logic |

---

## API Integrations

| Platform | API | Data Retrieved |
|----------|-----|----------------|
| **LeetCode** | `https://leetcode-api-faisalshehbaz.vercel.app/` | Total solved, easy/medium/hard breakdown, recent submissions, contest rating |
| **GitHub** | REST v3 + GraphQL (`api.github.com`) | Profile, repos, stars, contribution calendar, streak, followers |
| **Codeforces** | `https://codeforces.com/api/` | Rating, max rating, rank, solved count, rating history, upcoming contests |

---

## Tech Stack

| Dependency | Purpose |
|-----------|---------|
| `flutter_riverpod` | Reactive state management |
| `dio` | HTTP client for API calls |
| `go_router` | Declarative navigation with auth guards |
| `shared_preferences` | Local persistence (friends, widget layout, auth) |
| `flutter_secure_storage` | Encrypted storage for tokens |
| `fl_chart` | Codeforces rating graph |
| `flutter_staggered_grid_view` | Dashboard widget grid layout |
| `flutter_local_notifications` | Scheduled contest reminders |
| `timezone` / `flutter_timezone` | Timezone-aware notification scheduling |
| `shimmer` | Loading skeleton placeholders |
| `font_awesome_flutter` | Platform brand icons |
| `haptic_feedback` | Tactile responses on interactions |
| `intl` | Date formatting |

---

## Design System

- **Font**: Clash Display (all weights)
- **Background**: `#000000` (pure black)
- **Card Background**: `#131313`
- **Accent Red**: `#EB4335` — primary brand / total score
- **Accent Green**: `#4BD37B` — GitHub / LC Easy
- **Accent Yellow**: `#F7CE46` — LeetCode / LC Medium
- **Accent Blue**: `#3B3BFF` — Codeforces
- **LC Hard**: `#EB4335` (red)

---

## Getting Started

### Prerequisites

- Flutter SDK `>=3.11.4`
- Android SDK with `cmdline-tools` installed
- Java 17+

### Run in Debug

```bash
flutter pub get
flutter run
```

### Build Signed AAB (Play Store)

1. A release keystore is pre-configured at `android/app/upload-keystore.jks`.
2. Credentials are read from `android/key.properties`.

```bash
flutter build appbundle
```

The signed `.aab` is output to `build/app/outputs/bundle/release/app-release.aab`.

---

## Notifications

Klyx automatically schedules local notifications for every upcoming Codeforces contest at:
- **8 hours** before
- **1 hour** before
- **15 minutes** before
- **At start time**

The `SCHEDULE_EXACT_ALARM` permission is declared in `AndroidManifest.xml`. If the device denies exact alarms, the service gracefully falls back to `inexactAllowWhileIdle`.

---

## Project Status

- **Version**: 1.0.0+1
- **Min SDK**: Android (defined by Flutter)
- **Package**: `com.example.klyx`
