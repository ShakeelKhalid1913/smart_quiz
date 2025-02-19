import 'package:go_router/go_router.dart';
import 'package:smart_quiz/presentation/screens/admin/add_category_screen.dart';
import 'package:smart_quiz/presentation/screens/admin/add_quiz_screen.dart';
import 'package:smart_quiz/presentation/screens/admin/all_quizzes_screen.dart';
import '../../presentation/screens/admin/admin_dashboard.dart';
import '../../presentation/screens/admin/manage_categories_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'admin_dashboard',
        builder: (context, state) => const AdminDashboard(),
      ),
      GoRoute(
        path: '/manage-categories',
        name: 'manage_categories',
        builder: (context, state) => const ManageCategoriesScreen(),
      ),
      GoRoute(
        path: '/all-quizzes',
        name: 'all_quizzes',
        builder: (context, state) => const AllQuizzesScreen(),
      ),
      GoRoute(
        path: '/add-category',
        name: 'add_category',
        builder: (context, state) => const AddCategoryScreen(),
      ),
      GoRoute(
        path: '/add-quiz',
        name: 'add_quiz',
        builder: (context, state) => const AddQuizScreen(),
      ),
      // Add more routes here as we create new screens
    ],
  );
}
