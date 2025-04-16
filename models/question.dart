import 'package:html_unescape/html_unescape.dart';

class Question {
  final String question;
  final List<String> options;
  final String correctAnswer;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    final unescape = HtmlUnescape();

    // Decode question and correct answer
    String decodedQuestion = unescape.convert(json['question']);
    String decodedCorrectAnswer = unescape.convert(json['correct_answer']);

    // Decode incorrect answers properly
    List<String> decodedIncorrect =
        (json['incorrect_answers'] as List)
            .map((answer) => unescape.convert(answer.toString()))
            .toList();

    // Combine and shuffle
    List<String> allOptions = [...decodedIncorrect, decodedCorrectAnswer];
    allOptions.shuffle();

    return Question(
      question: decodedQuestion,
      options: allOptions,
      correctAnswer: decodedCorrectAnswer,
    );
  }
}
