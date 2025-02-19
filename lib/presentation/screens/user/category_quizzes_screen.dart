import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/quiz.dart';
import '../../../models/quiz_category.dart';

class CategoryQuizzesScreen extends StatelessWidget {
  final String categoryId;

  const CategoryQuizzesScreen({
    super.key,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    final category = QuizCategories()
        .categories
        .firstWhere((category) => category.id == categoryId);
    final quizzes = Quizzes()
        .allQuizzes
        .where((quiz) => quiz.categoryId == categoryId)
        .toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: category.color,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.quiz,
                        size: 48,
                        color: ThemeData.estimateBrightnessForColor(
                                    category.color) ==
                                Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        category.name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: ThemeData.estimateBrightnessForColor(
                                      category.color) ==
                                  Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${quizzes.length} ${quizzes.length == 1 ? 'Quiz' : 'Quizzes'}',
                        style: TextStyle(
                          fontSize: 16,
                          color: ThemeData.estimateBrightnessForColor(
                                      category.color) ==
                                  Brightness.dark
                              ? Colors.white70
                              : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: quizzes.isEmpty
                ? SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.quiz_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No quizzes available',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Check back later for new quizzes',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final quiz = quizzes[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: category.color.withOpacity(0.2),
                              child: Text(
                                quiz.title[0].toUpperCase(),
                                style: TextStyle(
                                  color: category.color,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              quiz.title,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '${quiz.questions.length} ${quiz.questions.length == 1 ? 'Question' : 'Questions'} • ${quiz.timeInMinutes} mins',
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              // if quiz does not have any question
                              if (quiz.questions.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('This quiz has no questions')),
                                );
                                return;
                              }
                              context.pushNamed('quiz_attempt',
                                  pathParameters: {'id': quiz.id});
                            },
                          ),
                        );
                      },
                      childCount: quizzes.length,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
