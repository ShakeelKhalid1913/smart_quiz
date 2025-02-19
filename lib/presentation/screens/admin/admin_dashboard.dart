import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_quiz/models/quiz.dart';
import 'package:smart_quiz/models/recent_activity.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../models/quiz_category.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    final categories = QuizCategories().categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          // logout button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // take to main screen
              context.go('/');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome Admin',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Manage your quiz application overview',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              _buildSummaryCards(context, categories),
              const SizedBox(height: 24),
              _buildCategoryStatistics(context, categories),
              const SizedBox(height: 24),
              _buildRecentActivity(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards(
    BuildContext context,
    List<QuizCategory> categories,
  ) {
    final totalQuizzes = Quizzes().allQuizzes.length;

    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            context,
            count: categories.length.toString(),
            title: 'Total Categories',
            icon: Icons.category,
            onTap: () async {
              final result = await context.pushNamed('manage_categories');
              if (result == true) {
                setState(
                  () {},
                ); // Refresh dashboard when returning with changes
              }
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            context,
            count: totalQuizzes.toString(),
            title: 'Total Quizzes',
            icon: Icons.quiz,
            onTap: () async {
              await context.pushNamed('all_quizzes');
              setState(() {}); // Refresh dashboard when returning
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    BuildContext context, {
    required String count,
    required String title,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 32, color: theme.colorScheme.primary),
              const SizedBox(height: 8),
              Text(
                count,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryStatistics(
    BuildContext context,
    List<QuizCategory> categories,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quiz Statistics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...categories.map(
              (category) => _buildCategoryItem(context, category),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, QuizCategory category) {
    final theme = Theme.of(context);
    final successRate =
        (category.id.hashCode % 30 + 70).toDouble(); // Mock success rate

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category.name,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                '${successRate.toStringAsFixed(1)}%',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: successRate / 100,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    final activities = RecentActivity().getAllActivities();
    if (activities.isEmpty) {
      return const Text('No recent activity');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        // sart loop and show recent activities
        for (var activity in activities)
          _buildActivityItem(context, activity.description, activity.date),
      ],
    );
  }

  Widget _buildActivityItem(
    BuildContext context,
    String title,
    DateTime dateTime,
  ) {
    final theme = Theme.of(context);
    String timeAgo = _getTimeAgo(dateTime);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        child: ListTile(
          leading: Icon(Icons.history, color: theme.colorScheme.primary),
          title: Text(title),
          subtitle: Text(timeAgo),
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }
}
