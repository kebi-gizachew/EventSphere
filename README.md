# EventSphere – Smart Event Organizer

A modern Flutter mobile application that performs full **CRUD** (Create, Read, Update, Delete) operations on events using the public [JSONPlaceholder](https://jsonplaceholder.typicode.com) REST API. Todo items from the API are interpreted as smart events with rich metadata, categories, and a polished UI.

---

## Project Overview

**EventSphere** helps users browse, search, filter, create, edit, and delete events. The app maps JSONPlaceholder `/todos` data to events:

| API Field   | App Field        |
|------------|------------------|
| `title`    | Event title      |
| `completed`| Event status     |
| `id`       | Event ID         |
| `userId`   | Organizer ID     |

Additional fields (category, date, location, banner) are generated deterministically for a rich user experience.

---

## App Features

- **Fetch & display** events from JSONPlaceholder API
- **Create** new events with form validation
- **Update** existing event details
- **Delete** events with confirmation dialog
- **Search & filter** by title, location, organizer, and category
- **Pull-to-refresh** on the event list
- **Loading states** and graceful **error handling**
- **Success/error Snackbars** for user feedback
- **Favorite/bookmark** toggle per event
- **Countdown labels** (e.g. "Starts in 2 days")
- **Dark/light theme** toggle
- **Category-colored** cards and chips
- **Animated** event cards and screen transitions

---

## Architecture

The project follows **clean, layered architecture** with separation of concerns:

```
lib/
├── main.dart                 # App entry, BlocProvider, theme
├── models/                   # Data models (EventModel)
├── blocs/events/             # BLoC: events_bloc, events_event, events_state
├── services/                 # ApiService (Dio), EventRepository
├── screens/                  # HomeScreen, EventFormScreen
├── widgets/                  # Reusable UI components
├── utils/                    # Constants, helpers, metadata generator
└── themes/                   # AppColors, AppTheme
```

### Data Flow

1. **UI** dispatches `EventsEvent` to `EventsBloc`
2. **Bloc** calls `EventRepository`
3. **Repository** uses `ApiService` (Dio) for HTTP
4. **Bloc** emits `EventsState` (loading, loaded, empty, error)
5. **UI** rebuilds via `BlocBuilder` / `BlocListener`

---

## Dependencies

| Package        | Purpose                          |
|----------------|----------------------------------|
| `flutter_bloc` | State management (BLoC pattern)  |
| `dio`          | HTTP client for REST API         |
| `equatable`    | Value equality for Bloc/events   |
| `intl`         | Date formatting                  |
| `google_fonts` | Plus Jakarta Sans typography     |

---

## Setup Instructions

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.2.0 or higher)
- Android Studio / VS Code with Flutter extensions
- An emulator or physical device

### Steps

1. **Clone or open** the project folder:
   ```bash
   cd EventSphere
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Generate platform files** (if `android/` or `ios/` folders are missing):
   ```bash
   flutter create .
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

5. **(Optional) Run analyzer:**
   ```bash
   flutter analyze
   ```

> **Note:** Internet access is required to fetch events from JSONPlaceholder. Create/update/delete operations use the simulated API (changes may not persist server-side).

---

## Screenshots

| Home Screen | Add Event | Dark Mode |
|-------------|-----------|-----------|
| *Add screenshot here* | *Add screenshot here* | *Add screenshot here* |

| Event Card | Empty State | Delete Dialog |
|------------|-------------|---------------|
| *Add screenshot here* | *Add screenshot here* | *Add screenshot here* |

---

## Folder Structure

```
EventSphere/
├── lib/
│   ├── main.dart
│   ├── models/
│   │   └── event_model.dart
│   ├── blocs/events/
│   │   ├── events_bloc.dart
│   │   ├── events_event.dart
│   │   └── events_state.dart
│   ├── services/
│   │   ├── api_service.dart
│   │   └── event_repository.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   └── event_form_screen.dart
│   ├── widgets/
│   │   ├── event_card.dart
│   │   ├── category_chip.dart
│   │   ├── status_badge.dart
│   │   ├── search_bar_widget.dart
│   │   ├── empty_state.dart
│   │   ├── loading_overlay.dart
│   │   └── delete_dialog.dart
│   ├── utils/
│   │   ├── constants.dart
│   │   ├── event_metadata_generator.dart
│   │   └── snackbar_helper.dart
│   └── themes/
│       ├── app_colors.dart
│       └── app_theme.dart
├── pubspec.yaml
└── README.md
```

---

## API Endpoint

- **Base URL:** `https://jsonplaceholder.typicode.com`
- **Endpoint:** `/todos`

---

## License

This project is created for educational purposes.
