import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/question.dart';

class ApiService {
  static Future<List<Question>> fetchQuestions({
    required String category,
    required String difficulty,
  }) async {
    final response = await http.get(
      Uri.parse(
        'https://opentdb.com/api.php?amount=10&category=$category&difficulty=$difficulty&type=multiple',
      ),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Question> questions =
          (data['results'] as List)
              .map((questionData) => Question.fromJson(questionData))
              .toList();
      return questions;
    } else {
      throw Exception('Failed to load questions');
    }
  }

  static Future<Map<String, String>> fetchCategories() async {
    final response = await http.get(
      Uri.parse('https://opentdb.com/api_category.php'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List categories = data['trivia_categories'];
      return {for (var item in categories) item['name']: item['id'].toString()};
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
