class QuizCategory {
  final String id;
  final String name;
  final String description;
  int quizCount;

  QuizCategory({
    required this.id,
    required this.name,
    required this.description,
    this.quizCount = 0,
  });
}

class QuizCategories {
  static final QuizCategories instance = QuizCategories._internal();

  factory QuizCategories() {
    return instance;
  }

  QuizCategories._internal() { 
    init();
  }

  List<QuizCategory> categories = [];

  void init() {
    categories = [
      QuizCategory(
        id: '1',
        name: 'Dart',
        description: 'Learn and do Quizzes of Dart for tests and exams.',
        quizCount: 0,
      ),
      QuizCategory(
        id: '2',
        name: 'Flutter',
        description: 'Practice Flutter Quizzes and prepare yourself!',
        quizCount: 1,
      ),
      QuizCategory(
        id: '3',
        name: 'Java',
        description: 'Learn and do Quizzes of Java for tests and exams.',
        quizCount: 1,
      ),
    ];
  }
}