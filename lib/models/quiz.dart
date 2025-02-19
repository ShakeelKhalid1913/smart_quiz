import 'package:smart_quiz/models/quiz_category.dart';

class Quiz {
  final String id;
  final String title;
  final String categoryId;
  final List<Question> questions;
  final int timeInMinutes;
  final DateTime createdAt;

  const Quiz({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.questions,
    required this.timeInMinutes,
    required this.createdAt,
  });

  int get totalQuestions => questions.length;
}

class Question {
  final String id;
  final String text;
  final List<String> options;
  final int correctOptionIndex;

  const Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctOptionIndex,
  });
}

class Quizzes {
  List<Quiz> allQuizzes = [];

  static final Quizzes instance = Quizzes._internal();

  Quizzes._internal() {
    init();
  }

  factory Quizzes() {
    return instance;
  }

  void init() {
    allQuizzes = [
      Quiz(
        id: '1',
        title: 'Basics of Flutter',
        categoryId: 'cat_2', // Flutter category
        timeInMinutes: 5,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        questions: [
          Question(
            id: '1',
            text: 'What is Flutter?',
            options: [
              'A mobile framework',
              'A programming language',
              'Both',
            ],
            correctOptionIndex: 0,
          ),
          Question(
            id: '2',
            text: 'How many widgets can you fit in a screen?',
            options: [
              'Infinity',
              'Until there is no more room',
              'Until you run out of time',
            ],
            correctOptionIndex: 1,
          ),
        ],
      ),

      Quiz(
        id: '2',
        title: 'Basic Java',
        categoryId: 'cat_3', // Java category
        timeInMinutes: 10,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        questions: [],
      ),
    ];
  }

  List<Quiz> getQuizzesByCategory(String categoryId) {
    return allQuizzes.where((quiz) => quiz.categoryId == categoryId).toList();
  }

  List<Quiz> searchQuizzes(String query) {
    query = query.toLowerCase();
    return allQuizzes
        .where((quiz) => quiz.title.toLowerCase().contains(query))
        .toList();
  }

  void addQuiz(Quiz quiz) {
    allQuizzes.add(quiz);
    // Update category quiz count
    final categories = QuizCategories();
    final category = categories.categories.firstWhere(
      (cat) => cat.id == quiz.categoryId,
      orElse: () => throw Exception('Category not found'),
    );
    category.quizCount++;
  }

  String generateQuizId() {
    return 'quiz_${allQuizzes.length + 1}';
  }
}
