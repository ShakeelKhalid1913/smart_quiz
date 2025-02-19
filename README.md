# Smart Quiz

A modern Flutter-based quiz application that allows administrators to create and manage quizzes while providing users with an engaging learning experience.

## Features

### Admin Dashboard
- Quick overview of total quizzes and categories
- Recent activity tracking
- Theme toggle (Light/Dark mode)
- Quick access to manage categories and quizzes

### Category Management
- Create, view, edit, and delete quiz categories
- Category details include:
  - Name
  - Description
  - Quiz count tracking

### Quiz Management
- Comprehensive quiz listing with search and filter capabilities
- Quiz details include:
  - Title
  - Category
  - Number of questions
  - Time limit
- MCQ (Multiple Choice Questions) support
  - Questions with multiple options
  - Correct answer tracking

## Project Structure

```
lib/
├── core/
│   ├── providers/
│   │   └── theme_provider.dart
│   ├── router/
│   │   └── app_router.dart
│   └── theme/
│       └── app_theme.dart
├── models/
│   ├── quiz_category.dart
│   ├── quiz.dart
│   └── recent_activity.dart
└── presentation/
    └── screens/
        └── admin/
            ├── admin_dashboard.dart
            ├── manage_categories_screen.dart
            ├── add_category_screen.dart
            └── all_quizzes_screen.dart
```

## State Management
- Provider for theme management
- Singleton pattern for data models:
  - QuizCategories
  - Quizzes
  - RecentActivity

## Dependencies
- flutter
- provider: State management
- go_router: Navigation
- google_fonts: Typography

## Getting Started

1. Ensure you have Flutter installed on your machine
2. Clone the repository
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## Development Status

### Completed
- Admin dashboard with statistics
- Theme switching (Light/Dark mode)
- Category management
- Quiz listing with search and filters
- Recent activity tracking

### In Progress
- Quiz creation interface
- Quiz editing capabilities
- User authentication
- Quiz attempt tracking

### Planned
- User dashboard
- Quiz results and analytics
- Performance tracking
- Leaderboards
