import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/quiz.dart';
import '../../../models/quiz_category.dart';
import '../../widgets/category_chips.dart';

class AllQuizzesScreen extends StatefulWidget {
  const AllQuizzesScreen({super.key});

  @override
  State<AllQuizzesScreen> createState() => _AllQuizzesScreenState();
}

class _AllQuizzesScreenState extends State<AllQuizzesScreen> {
  String _selectedCategoryId = '';
  final _searchController = TextEditingController();
  List<Quiz> _filteredQuizzes = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadQuizzes();
  }

  void _loadQuizzes() {
    setState(() {
      _filteredQuizzes = Quizzes().allQuizzes;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterQuizzes();
  }

  void _filterQuizzes() {
    var quizzes = Quizzes().allQuizzes;

    // Apply category filter
    if (_selectedCategoryId.isNotEmpty) {
      quizzes = quizzes
          .where((quiz) => quiz.categoryId == _selectedCategoryId)
          .toList();
    }

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      quizzes = quizzes
          .where((quiz) =>
              quiz.title.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    }

    setState(() {
      _filteredQuizzes = quizzes;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Quizzes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await context.pushNamed('add_quiz');
              _loadQuizzes();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search quizzes...',
                filled: true,
                fillColor: theme.brightness == Brightness.dark
                    ? Colors.grey[800]
                    : Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          CategoryChips(
            selectedCategoryId: _selectedCategoryId,
            onCategorySelected: (categoryId) {
              setState(() {
                _selectedCategoryId = categoryId;
              });
              _filterQuizzes();
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _filteredQuizzes.isEmpty
                ? Center(
                    child: Text(
                      'No quizzes found',
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredQuizzes.length,
                    itemBuilder: (context, index) {
                      final quiz = _filteredQuizzes[index];
                      final category = QuizCategories()
                          .categories
                          .firstWhere((c) => c.id == quiz.categoryId);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: category.color,
                            child: Text(
                              quiz.title[0].toUpperCase(),
                              style: TextStyle(
                                color: ThemeData.estimateBrightnessForColor(
                                            category.color) ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            quiz.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(category.name),
                              Text(
                                '${quiz.questions.length} ${quiz.questions.length == 1 ? 'Question' : 'Questions'} • ${quiz.timeInMinutes} mins',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          isThreeLine: true,
                          trailing: IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {
                              // TODO: Show edit/delete options
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
