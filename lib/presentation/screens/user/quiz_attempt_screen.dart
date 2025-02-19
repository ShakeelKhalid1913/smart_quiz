import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/quiz.dart';
import 'quiz_result_screen.dart';

class QuizAttemptScreen extends StatefulWidget {
  final String quizId;

  const QuizAttemptScreen({super.key, required this.quizId});

  @override
  State<QuizAttemptScreen> createState() => _QuizAttemptScreenState();
}

class _QuizAttemptScreenState extends State<QuizAttemptScreen> {
  late Quiz quiz;
  int currentQuestionIndex = 0;
  int? selectedOptionIndex;
  bool hasAnswered = false;
  late Timer timer;
  int remainingSeconds = 0;
  late DateTime startTime;
  List<int> userAnswers = [];

  @override
  void initState() {
    super.initState();
    quiz = Quizzes().allQuizzes.firstWhere((q) => q.id == widget.quizId);
    remainingSeconds = quiz.timeInMinutes * 60;
    startTime = DateTime.now();
    userAnswers = List.filled(quiz.questions.length, -1);
    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--;
        } else {
          timer.cancel();
          // TODO: Handle time up scenario
        }
      });
    });
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void handleOptionTap(int index) {
    if (hasAnswered) return;

    setState(() {
      selectedOptionIndex = index;
      hasAnswered = true;
      userAnswers[currentQuestionIndex] = index;
    });
  }

  void goToNextQuestion() {
    if (currentQuestionIndex < quiz.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedOptionIndex = null;
        hasAnswered = false;
      });
    } else {
      final timeTaken = DateTime.now().difference(startTime);
      context.pushReplacement('/quiz-result', extra: QuizResult(
        quiz: quiz,
        userAnswers: userAnswers,
        timeTaken: timeTaken,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = quiz.questions[currentQuestionIndex];
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                          title: const Text('Quit Quiz?'),
                          content: const Text(
                            'Are you sure you want to quit? Your progress will be lost.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close dialog
                                Navigator.pop(context); // Close quiz screen
                              },
                              child: const Text('Quit'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.timer, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          formatTime(remainingSeconds),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            LinearProgressIndicator(
              value: (currentQuestionIndex + 1) / quiz.questions.length,
              backgroundColor: Colors.grey[200],
              minHeight: 2,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Question ${currentQuestionIndex + 1}',
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      question.text,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ...List.generate(question.options.length, (index) {
                      final option = question.options[index];
                      final isSelected = selectedOptionIndex == index;
                      final isCorrect = index == question.correctOptionIndex;
                      Color? backgroundColor;
                      Color? borderColor;

                      if (hasAnswered) {
                        if (isSelected) {
                          backgroundColor =
                              isCorrect ? Colors.green[50] : Colors.red[50];
                          borderColor = isCorrect ? Colors.green : Colors.red;
                        } else if (isCorrect) {
                          backgroundColor = Colors.green[50];
                          borderColor = Colors.green;
                        }
                      } else if (isSelected) {
                        backgroundColor = theme.colorScheme.primary.withOpacity(
                          0.1,
                        );
                        borderColor = theme.colorScheme.primary;
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () => handleOptionTap(index),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: backgroundColor ?? theme.cardColor,
                              border: Border.all(
                                color: borderColor ?? Colors.grey[300]!,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color:
                                          hasAnswered && isCorrect
                                              ? Colors.green
                                              : null,
                                      fontWeight:
                                          isSelected ||
                                                  (hasAnswered && isCorrect)
                                              ? FontWeight.bold
                                              : null,
                                    ),
                                  ),
                                ),
                                if (hasAnswered)
                                  Icon(
                                    isCorrect
                                        ? Icons.check_circle
                                        : (isSelected ? Icons.cancel : null),
                                    color:
                                        isCorrect ? Colors.green : Colors.red,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: hasAnswered ? goToNextQuestion : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  currentQuestionIndex < quiz.questions.length - 1
                      ? 'Next Question'
                      : 'Finish Quiz',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
