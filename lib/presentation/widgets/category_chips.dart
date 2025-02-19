import 'package:flutter/material.dart';
import '../../models/quiz_category.dart';

class CategoryChips extends StatelessWidget {
  final String selectedCategoryId;
  final Function(String) onCategorySelected;
  final bool showAllOption;

  const CategoryChips({
    super.key,
    required this.selectedCategoryId,
    required this.onCategorySelected,
    this.showAllOption = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = QuizCategories().categories;
    final chips = [
      if (showAllOption)
        FilterChip(
          label: Text(
            'All',
            style: TextStyle(
              color:
                  selectedCategoryId.isEmpty
                      ? Colors.white
                      : theme.brightness == Brightness.dark
                      ? Colors.white70
                      : Colors.black87,
            ),
          ),
          selected: selectedCategoryId.isEmpty,
          showCheckmark: false,
          selectedColor: theme.colorScheme.primary,
          backgroundColor:
              theme.brightness == Brightness.dark
                  ? Colors.grey[800]
                  : Colors.grey[200],
          onSelected: (_) => onCategorySelected(''),
        ),
      ...categories.map((category) {
        final isSelected = category.id == selectedCategoryId;
        return FilterChip(
          label: Text(
            category.name,
            style: TextStyle(
              color:
                  isSelected
                      ? Colors.white
                      : theme.brightness == Brightness.dark
                      ? Colors.white70
                      : Colors.black87,
            ),
          ),
          selected: isSelected,
          showCheckmark: false,
          selectedColor: category.color,
          backgroundColor:
              theme.brightness == Brightness.dark
                  ? Colors.grey[800]
                  : Colors.grey[200],
          onSelected: (_) => onCategorySelected(category.id),
        );
      }).toList(),
    ];

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children:
            chips
                .map(
                  (chip) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: chip,
                  ),
                )
                .toList(),
      ),
    );
  }
}
