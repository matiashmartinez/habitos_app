# Habitos App - Copilot Instructions

## Project Overview
Habitos App is a Flutter habit-tracking application using **Riverpod** for state management, **Drift** for local persistence, and a layered architecture (Domain/Application/Infrastructure/Presentation).

## Architecture & Key Patterns

### Layered Feature Structure
Each feature (auth, habits, dashboard) follows clean architecture layers:
- **Domain**: Business logic and entities (`Habit`, `HabitState`)
- **Application**: State notifiers (`HabitNotifier`) managing state transitions
- **Infrastructure**: Data access and repositories (`HabitLocalRepository`, `app_database.dart`)
- **Presentation**: UI screens and widgets

Example: `lib/src/features/habits/{domain,application,infrastructure,presentation}/`

### State Management: Riverpod & Sealed Classes
- Use **sealed classes** for exhaustive state modeling (see `auth_state.dart`, `habit_state.dart`)
  ```dart
  sealed class AuthState {}
  final class AuthLoading extends AuthState {}
  final class AuthAuthenticated extends AuthState { ... }
  ```
- Use `StateNotifierProvider` for mutable state (e.g., `authProvider`, `habitNotifierProvider`)
- Use `ConsumerWidget` in UI to access providers via `ref.watch()` and `ref.read()`
- Pattern: Watch for state changes, read to perform actions

### Data Persistence
- **SharedPreferences** for simple auth tokens (via `LocalStorageService` in `lib/src/core/services/`)
- **Drift** for relational data (Habits, Users, Completions tables defined in `app_database.dart`)
- Repositories in infrastructure layer abstract data sources

### Authentication Flow
- Check session on app start in `AuthNotifier._checkSession()`
- Login credential validation happens in notifier before storage
- `App` widget uses pattern matching on `AuthState` to route to LoginScreen or DashboardScreen
- Hard-coded test credentials: `test@correo.com` / `123456`

### Habit Tracking Data Model
- `Habit` entity tracks `completedDates` list (DateTime history)
- `toggleHabit()` adds/removes completion date for today
- Statistic methods like `habitsCompletedToday()` filter by date
- Use `copyWith()` for immutable updates (standard Dart pattern)

## Key Files & Conventions

| Path | Purpose |
|------|---------|
| `lib/src/main.dart` | App entry with `ProviderScope` wrapper |
| `lib/src/app.dart` | Material app with auth routing logic |
| `lib/src/core/services/local_storage_service.dart` | SharedPreferences wrapper for tokens |
| `lib/src/features/auth/presentation/auth_notifier.dart` | Auth state management |
| `lib/src/features/habits/infrastructure/app_database.dart` | Drift database schema |
| `lib/src/features/dashboard/presentation/screens/dashboard_screen.dart` | Main navigation hub |

## Development Workflow

### Add a New Habit Feature
1. Define domain model in `domain/` (e.g., `my_feature.dart`)
2. Create sealed state class in `domain/my_feature_state.dart`
3. Build notifier in `application/my_feature_notifier.dart`
4. Implement repository in `infrastructure/`
5. Create presentation screen that watches provider

### Add UI State Toggle
Use `StateProvider` for simple UI state:
```dart
final myUiToggleProvider = StateProvider<bool>((ref) => false);
// In widget: ref.read(myUiToggleProvider.notifier).state = !value;
```

## Testing & Build
- **Tests**: Place in `test/` directory (follow Dart conventions)
- **Build Runner**: Used for Drift code generation
  ```bash
  dart run build_runner build
  ```
- **Flutter Commands**: 
  - `flutter pub get` - fetch dependencies
  - `flutter run` - run on connected device
  - `flutter build <platform>` - build for target

## Language & Localization
- App uses Spanish UI strings (see login screen: "Debe completar todos los campos")
- Email validation and credential messages are localized
- Future i18n integration should preserve this convention

## Common Pitfalls
- **Don't** mutate state directly; use `copyWith()` or `StateNotifier` methods
- **Don't** call async operations in widget `build()` methods
- **Do** use `ref.watch()` for reactive updates, `ref.read()` for one-time actions
- **Do** seal auth/habit state classes to enforce exhaustive pattern matching in app.dart
