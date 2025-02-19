import 'package:flutter/material.dart';
import 'package:smart_quiz/models/quiz.dart';

class QuizCategory {
  final String id;
  final String name;
  final String description;
  final Color color;
  int quizCount;

  QuizCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
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
        id: 'cat_1',
        name: 'Mathematics',
        description: 'Math related quizzes',
        color: Colors.blue,
        quizCount: 0,
      ),
      QuizCategory(
        id: 'cat_2',
        name: 'Flutter',
        description: 'Flutter related quizzes',
        color: Colors.green,
        quizCount: 1,
      ),
      QuizCategory(
        id: 'cat_3',
        name: 'Java',
        description: 'Java related quizzes',
        color: Colors.red,
        quizCount: 1,
      ),
    ];
  }

  void addCategory(QuizCategory category) {
    if (categories.any(
      (c) => c.name.toLowerCase() == category.name.toLowerCase(),
    )) {
      throw Exception('A category with this name already exists');
    }
    categories.add(category);
  }

  void deleteCategory(String id) {
    categories.removeWhere((cat) => cat.id == id);

    // remove quiz if category is deleted
    Quizzes().allQuizzes.removeWhere((quiz) => quiz.categoryId == id);
  }

  String generateCategoryId() {
    return 'cat_${categories.length + 1}';
  }
}
