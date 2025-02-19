import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/admin/add_category_screen.dart';
import '../../presentation/screens/admin/add_quiz_screen.dart';
import '../../presentation/screens/admin/admin_dashboard.dart';
import '../../presentation/screens/admin/all_quizzes_screen.dart';
import '../../presentation/screens/admin/manage_categories_screen.dart';
import '../../presentation/screens/user/user_home_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const UserHomeScreen()),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboard(),
      ),
      GoRoute(
        path: '/admin/manage-categories',
        name: 'manage_categories',
        builder: (context, state) => const ManageCategoriesScreen(),
      ),
      GoRoute(
        path: '/admin/add-category',
        name: 'add_category',
        builder: (context, state) => const AddCategoryScreen(),
      ),
      GoRoute(
        path: '/admin/all-quizzes',
        name: 'all_quizzes',
        builder: (context, state) => const AllQuizzesScreen(),
      ),
      GoRoute(
        path: '/admin/add-quiz',
        name: 'add_quiz',
        builder: (context, state) => const AddQuizScreen(),
      ),
    ],
  );
}
