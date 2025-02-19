import 'package:flutter/material.dart';
import 'package:smart_quiz/models/recent_activity.dart';
import '../../../models/quiz.dart';
import '../../../models/quiz_category.dart';
import '../../widgets/category_chips.dart';

class AddQuizScreen extends StatefulWidget {
  const AddQuizScreen({super.key});

  @override
  State<AddQuizScreen> createState() => _AddQuizScreenState();
}

class _AddQuizScreenState extends State<AddQuizScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _timeController = TextEditingController();
  String _selectedCategoryId = '';
  final List<QuestionFormField> _questions = [];

  @override
  void dispose() {
    _titleController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _addQuestion() {
    setState(() {
      _questions.add(
        QuestionFormField(
          key: GlobalKey<_QuestionFormFieldState>(),
          onDelete: _removeQuestion,
        ),
      );
    });
  }

  void _removeQuestion(Key key) {
    setState(() {
      _questions.removeWhere((question) => question.key == key);
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedCategoryId.isNotEmpty) {
      final quizzes = Quizzes();

      // Create questions list from form fields
      final questions =
          _questions.map((questionField) {
            final state =
                questionField.key as GlobalKey<_QuestionFormFieldState>;
            final questionState = state.currentState!;

            return Question(
              id: 'q_${DateTime.now().millisecondsSinceEpoch}',
              text: questionState._questionController.text,
              options:
                  questionState._optionControllers.asMap().entries.map((entry) {
                    return Option(
                      id: entry.key.toString(),
                      text: entry.value.text,
                    );
                  }).toList(),
              correctOptionIndex: questionState._correctOptionIndex,
            );
          }).toList();

      // Create and add the new quiz
      final quiz = Quiz(
        id: quizzes.generateQuizId(),
        title: _titleController.text,
        categoryId: _selectedCategoryId,
        timeInMinutes: int.parse(_timeController.text),
        questions: questions,
        createdAt: DateTime.now(),
      );

      try {
        quizzes.addQuiz(quiz);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Quiz created successfully')),
        );

        // add in activity
        RecentActivity().addActivity(
          Activity(
            description: "${_titleController.text} quiz created",
            date: DateTime.now(),
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating quiz: ${e.toString()}')),
        );
      }
    } else if (_selectedCategoryId.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a category')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Add Quiz'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Quiz Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Quiz Title',
                prefixIcon: const Icon(Icons.title),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a quiz title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Select Category',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            CategoryChips(
              selectedCategoryId: _selectedCategoryId,
              onCategorySelected: (categoryId) {
                setState(() {
                  _selectedCategoryId = categoryId;
                });
              },
              showAllOption: false,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _timeController,
              decoration: InputDecoration(
                labelText: 'Time Limit (in minutes)',
                prefixIcon: const Icon(Icons.timer),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter time limit';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Questions',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: _addQuestion,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Question'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._questions,
            if (_questions.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'No questions added yet',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Create Quiz', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionFormField extends StatefulWidget {
  final Function(Key) onDelete;

  const QuestionFormField({required Key key, required this.onDelete})
    : super(key: key);

  @override
  State<QuestionFormField> createState() => _QuestionFormFieldState();
}

class _QuestionFormFieldState extends State<QuestionFormField> {
  final _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  int _correctOptionIndex = 0;

  @override
  void dispose() {
    _questionController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.question_mark),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _questionController,
                    decoration: const InputDecoration(
                      hintText: 'Question Title',
                      border: UnderlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a question';
                      }
                      return null;
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => widget.onDelete(widget.key!),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...List.generate(4, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Radio<int>(
                      value: index,
                      groupValue: _correctOptionIndex,
                      onChanged: (value) {
                        setState(() {
                          _correctOptionIndex = value!;
                        });
                      },
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _optionControllers[index],
                        decoration: InputDecoration(
                          hintText: 'Option ${index + 1}',
                          border: const UnderlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter option ${index + 1}';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
