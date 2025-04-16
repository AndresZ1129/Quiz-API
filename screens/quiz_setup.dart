import 'package:flutter/material.dart';

import '../services/api_service.dart';
import 'quiz_screen.dart';

class QuizSetupScreen extends StatefulWidget {
  const QuizSetupScreen({super.key});

  @override
  _QuizSetupScreenState createState() => _QuizSetupScreenState();
}

class _QuizSetupScreenState extends State<QuizSetupScreen> {
  Map<String, String> _categories = {};
  String? _selectedCategory;
  String _selectedDifficulty = 'easy';
  bool _loading = true;

  final List<String> _difficulties = ['easy', 'medium', 'hard'];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await ApiService.fetchCategories();
      setState(() {
        _categories = categories;
        _selectedCategory = categories.keys.first;
        _loading = false;
      });
    } catch (e) {
      print(e);
      setState(() => _loading = false);
    }
  }

  void _startQuiz() {
    if (_selectedCategory != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => QuizScreen(
                category: _categories[_selectedCategory!]!,
                difficulty: _selectedDifficulty,
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text('Quiz Setup')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Quiz Setup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(labelText: 'Select Category'),
              items:
                  _categories.keys
                      .map(
                        (name) =>
                            DropdownMenuItem(value: name, child: Text(name)),
                      )
                      .toList(),
              onChanged: (value) => setState(() => _selectedCategory = value),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedDifficulty,
              decoration: InputDecoration(labelText: 'Select Difficulty'),
              items:
                  _difficulties
                      .map(
                        (difficulty) => DropdownMenuItem(
                          value: difficulty,
                          child: Text(difficulty),
                        ),
                      )
                      .toList(),
              onChanged:
                  (value) => setState(() => _selectedDifficulty = value!),
            ),
            SizedBox(height: 30),
            ElevatedButton(onPressed: _startQuiz, child: Text('Start Quiz')),
          ],
        ),
      ),
    );
  }
}
