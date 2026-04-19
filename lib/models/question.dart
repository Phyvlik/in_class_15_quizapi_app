class Question {
  final String text;
  final List<String> options;
  final String correctAnswer;
  final String difficulty;
  final String category;

  Question({
    required this.text,
    required this.options,
    required this.correctAnswer,
    required this.difficulty,
    required this.category,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    final answers = (json['answers'] as List)
        .whereType<Map<String, dynamic>>()
        .where((a) => (a['text'] ?? '').toString().isNotEmpty)
        .toList();

    final correct = answers.firstWhere(
      (a) => a['isCorrect'] == true,
      orElse: () => answers.first,
    );

    final options = answers.map((a) => a['text'].toString()).toList();

    return Question(
      text: json['question'] as String? ?? '',
      options: options,
      correctAnswer: correct['text'].toString(),
      difficulty: json['difficulty'] as String? ?? '',
      category: json['category'] as String? ?? '',
    );
  }
}
