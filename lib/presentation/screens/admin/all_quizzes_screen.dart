import 'package:flutter/material.dart';
import '../../../models/quiz.dart';
import '../../../models/quiz_category.dart';

class AllQuizzesScreen extends StatefulWidget {
  const AllQuizzesScreen({super.key});

  @override
  State<AllQuizzesScreen> createState() => _AllQuizzesScreenState();
}

class _AllQuizzesScreenState extends State<AllQuizzesScreen> {
  String _selectedCategoryId = '';
  final _searchController = TextEditingController();
  List<Quiz> _filteredQuizzes = Quizzes().allQuizzes;
  final _categories = QuizCategories().categories;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
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
      quizzes = Quizzes().getQuizzesByCategory(_selectedCategoryId);
    }
    
    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      quizzes = Quizzes().searchQuizzes(_searchController.text);
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
          icon: const Icon(Icons.add),
          onPressed: () {
            // TODO: Navigate to add quiz screen
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Quizzes',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedCategoryId.isEmpty ? null : _selectedCategoryId,
                  hint: const Text('All Categories'),
                  items: [
                    const DropdownMenuItem<String>(
                      value: '',
                      child: Text('All Categories'),
                    ),
                    ..._categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category.id,
                        child: Text(category.name),
                      );
                    }).toList(),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCategoryId = value ?? '';
                      _filterQuizzes();
                    });
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredQuizzes.length,
              itemBuilder: (context, index) {
                final quiz = _filteredQuizzes[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.quiz,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    title: Text(
                      quiz.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Icon(
                          Icons.question_answer,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text('${quiz.totalQuestions} Questions'),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.timer,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text('${quiz.timeInMinutes} mins'),
                      ],
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
