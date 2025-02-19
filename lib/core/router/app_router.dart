import 'package:go_router/go_router.dart';
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
      // Add more routes here as we create new screens
    ],
  );
}
