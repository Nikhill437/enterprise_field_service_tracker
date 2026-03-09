# Quick Start Guide

## Setup (5 minutes)

1. **Install dependencies**
```bash
flutter pub get
```

2. **Run the app**
```bash
flutter run
```

3. **Run tests**
```bash
flutter test
```

4. **Analyze code**
```bash
flutter analyze
```

## Using the App

### View Tasks
- App opens to the Task List screen
- Tasks are loaded automatically from the API
- Each task shows: title, description, priority badge, and status chip

### Filter Tasks
- Tap the filter icon (top right)
- Select: All Tasks, Pending, In Progress, or Completed
- List updates immediately

### View Task Details
- Tap any task in the list
- See full details: title, description, status, priority, dates
- Update status using the action button

### Create New Task
- Tap the floating action button (+)
- Fill in the form:
  - Title (required)
  - Description (required)
  - Priority (Low/Medium/High)
  - Due Date (optional)
- Tap "Create Task"
- New task appears at the top of the list

### Update Task Status
- Open task details
- Tap "Mark as In Progress" or "Mark as Completed"
- Status updates immediately
- Returns to task list

## Project Structure

```
lib/
├── bloc/           # State management
├── models/         # Data models
├── screens/        # UI screens
├── services/       # API integration
└── main.dart       # Entry point

test/
├── bloc/           # BLoC tests
├── models/         # Model tests
└── widget_test.dart # Widget tests
```

## Key Features Implemented

✅ 3 screens (List, Detail, Add)
✅ BLoC state management
✅ API integration (JSONPlaceholder)
✅ Status filtering
✅ Form validation
✅ Loading states
✅ Error handling
✅ Unit tests
✅ Widget tests
✅ CI/CD workflow

## Testing

### Run all tests
```bash
flutter test
```

### Run specific test file
```bash
flutter test test/bloc/task_bloc_test.dart
```

### Run with coverage
```bash
flutter test --coverage
```

## CI/CD

GitHub Actions workflow runs automatically on:
- Push to main/develop branches
- Pull requests to main/develop

Workflow steps:
1. Setup Flutter
2. Install dependencies
3. Format check
4. Analyze code
5. Run tests
6. Check dependencies

## Troubleshooting

### Dependencies not resolving
```bash
flutter clean
flutter pub get
```

### Tests failing
```bash
flutter test --verbose
```

### Build issues
```bash
flutter doctor
flutter clean
flutter pub get
flutter run
```

## Next Steps

1. Run the app and explore features
2. Review the code structure
3. Run tests to verify functionality
4. Check CI/CD workflow in GitHub Actions
5. Customize for your needs

## API Details

Using JSONPlaceholder (https://jsonplaceholder.typicode.com):
- GET /posts - Fetch tasks (mapped to tasks)
- POST /posts - Create task (simulated)
- Status updates are simulated locally

Tasks are enriched with:
- Random status (Pending/In Progress/Completed)
- Random priority (Low/Medium/High)
- Generated dates

## Requirements Met

✅ Minimum 3 screens
✅ Task list with filtering
✅ Task detail with status update
✅ Add new task with validation
✅ BLoC state management
✅ API integration
✅ Loading/error states
✅ GitHub Actions CI/CD
✅ Flutter null safety
✅ Android/iOS compatible
