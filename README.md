# Enterprise Field Service Tracker

A lightweight Flutter mobile application for field agents to log, view, and update service tasks. Built with BLoC state management and integrated with JSONPlaceholder API.

## Features

### Core Functionality
- **Task List Screen**: View all service tasks with filtering by status (Pending, In Progress, Completed)
- **Task Detail Screen**: View full task details and update task status
- **Add New Task Screen**: Create new tasks with form validation

### Technical Features
- BLoC pattern for state management
- API integration with JSONPlaceholder
- Loading and error state handling
- Persistent state across navigation
- Material Design UI
- Null safety enforced

## Screenshots

### Task List
- Displays tasks with title, description, priority, and status
- Filter tasks by status using the filter menu
- Tap any task to view details

### Task Details
- View complete task information
- Update task status with action buttons
- Visual indicators for priority and status

### Add Task
- Form with validation
- Priority selection (Low, Medium, High)
- Due date picker
- Real-time validation feedback

## Architecture

```
lib/
├── bloc/
│   ├── task_bloc.dart       # BLoC implementation
│   ├── task_event.dart      # Event definitions
│   └── task_state.dart      # State definitions
├── models/
│   └── task.dart            # Task model with JSON serialization
├── screens/
│   ├── task_list_screen.dart    # Main task list view
│   ├── task_detail_screen.dart  # Task details view
│   └── add_task_screen.dart     # Create task form
├── services/
│   └── task_api_service.dart    # API integration
└── main.dart                     # App entry point
```

## State Management

Uses **BLoC (Business Logic Component)** pattern:
- Separates business logic from UI
- Reactive state updates
- Testable architecture
- State persistence across navigation

## API Integration

Connects to JSONPlaceholder (https://jsonplaceholder.typicode.com):
- Fetches task list on app load
- Simulates task status updates
- Creates new tasks
- Handles loading and error states

## Getting Started

### Prerequisites
- Flutter SDK (3.16.0 or higher)
- Dart SDK (3.2.3 or higher)
- Android Studio / Xcode for mobile development

### Installation

1. Clone the repository
```bash
git clone <repository-url>
cd enterprise_field_service_tracker
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

### Code Analysis

```bash
# Analyze code
flutter analyze

# Format code
flutter format .
```

## CI/CD

GitHub Actions workflow included (`.github/workflows/flutter_ci.yml`):
- Runs on push and pull requests
- Executes `flutter analyze`
- Runs `flutter test`
- Checks code formatting
- Validates dependencies

## Dependencies

### Production
- `flutter_bloc: ^8.1.3` - State management
- `equatable: ^2.0.5` - Value equality
- `http: ^1.1.0` - HTTP client
- `intl: ^0.18.1` - Internationalization

### Development
- `bloc_test: ^9.1.5` - BLoC testing utilities
- `mocktail: ^1.0.1` - Mocking framework
- `flutter_lints: ^2.0.0` - Linting rules

## Platform Support

- ✅ Android
- ✅ iOS
- ⚠️ Web (not optimized)
- ⚠️ Desktop (not optimized)

## Project Structure

### Models
- `Task`: Core data model with status, priority, dates
- Enums: `TaskStatus`, `TaskPriority`
- JSON serialization support

### BLoC Events
- `LoadTasks`: Fetch tasks from API
- `AddTask`: Create new task
- `UpdateTaskStatus`: Update task status
- `FilterTasks`: Filter by status

### BLoC States
- `TaskInitial`: Initial state
- `TaskLoading`: Loading data
- `TaskLoaded`: Data loaded successfully
- `TaskError`: Error occurred

## Future Enhancements

- Offline support with local database
- Push notifications for task updates
- Task assignment to multiple agents
- Photo attachments for tasks
- GPS location tracking
- Task search functionality
- Dark mode support

## License

This project is created for educational purposes.
