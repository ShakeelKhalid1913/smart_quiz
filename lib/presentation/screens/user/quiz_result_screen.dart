import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/quiz.dart';

class QuizResult {
  final Quiz quiz;
  final List<int> userAnswers;
  final Duration timeTaken;

  QuizResult({
    required this.quiz,
    required this.userAnswers,
    required this.timeTaken,
  });

  int get totalQuestions => quiz.questions.length;
  int get correctAnswers =>
      userAnswers
          .asMap()
          .entries
          .where(
            (entry) =>
                entry.value == quiz.questions[entry.key].correctOptionIndex,
          )
          .length;
  int get incorrectAnswers => totalQuestions - correctAnswers;
  double get percentage => (correctAnswers / totalQuestions) * 100;

  String get grade {
    if (percentage == 100) return 'Outstanding!';
    if (percentage >= 90) return 'Excellent!';
    if (percentage >= 80) return 'Very Good!';
    if (percentage >= 70) return 'Good';
    if (percentage >= 60) return 'Fair';
    return 'Needs Improvement';
  }

  Color getGradeColor(BuildContext context) {
    if (percentage == 100) return Colors.green;
    if (percentage >= 90) return Colors.green[700]!;
    if (percentage >= 80) return Colors.blue;
    if (percentage >= 70) return Colors.orange;
    if (percentage >= 60) return Colors.orange[700]!;
    return Colors.red;
  }
}

class QuizResultScreen extends StatelessWidget {
  final QuizResult result;

  const QuizResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Result'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 150,
                        width: 150,
                        child: CircularProgressIndicator(
                          value: result.percentage / 100,
                          strokeWidth: 12,
                          backgroundColor: Colors.grey[300],
                          color: result.getGradeColor(context),
                        ),
                      ),
                      Text(
                        '${result.percentage.round()}%',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            result.percentage >= 60
                                ? Icons.emoji_events
                                : Icons.refresh,
                            size: 18,
                            color: result.getGradeColor(context),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            result.grade,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: result.getGradeColor(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatCard(
                        icon: Icons.check_circle,
                        iconColor: Colors.green,
                        count: result.correctAnswers,
                        label: 'Correct',
                      ),
                      _buildStatCard(
                        icon: Icons.cancel,
                        iconColor: Colors.red,
                        count: result.incorrectAnswers,
                        label: 'Incorrect',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.analytics_outlined),
                      SizedBox(width: 8),
                      Text(
                        'Detailed Analysis',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: result.quiz.questions.length,
                    itemBuilder: (context, index) {
                      final question = result.quiz.questions[index];
                      final userAnswer = result.userAnswers[index];
                      final isCorrect =
                          userAnswer == question.correctOptionIndex;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Theme(
                          data: Theme.of(
                            context,
                          ).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            leading: Icon(
                              isCorrect ? Icons.check_circle : Icons.cancel,
                              color: isCorrect ? Colors.green : Colors.red,
                            ),
                            title: Text(
                              'Question ${index + 1}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              question.text,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      question.text,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    if (!isCorrect) ...[
                                      _buildAnswerRow(
                                        'Your Answer:',
                                        question.options[userAnswer],
                                        Colors.red[50]!,
                                        Colors.red,
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                    _buildAnswerRow(
                                      'Correct Answer:',
                                      question.options[question
                                          .correctOptionIndex],
                                      Colors.green[50]!,
                                      Colors.green,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () => context.go('/'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Try Again'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required int count,
    required String label,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: 8),
            Text(
              count.toString(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerRow(
    String label,
    String answer,
    Color backgroundColor,
    Color textColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                label.contains('Your') ? Icons.person : Icons.check_circle,
                size: 16,
                color: textColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  answer,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
