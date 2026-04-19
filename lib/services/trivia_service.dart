import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/question.dart';

class TriviaService {
  static const _apiKey = String.fromEnvironment('QUIZ_API_KEY');

  static const _baseUrl = 'https://quizapi.io/api/v1/questions';

  Future<List<Question>> fetchQuestions({
    int limit = 10,
    String category = 'Programming',
    String difficulty = 'EASY',
    String type = 'MULTIPLE_CHOICE',
  }) async {
    final uri = Uri.parse(
      '$_baseUrl?limit=$limit&offset=0&category=$category&difficulty=$difficulty&type=$type&random=true',
    );

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $_apiKey'},
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      if (body['success'] == true && body['data'] is List) {
        final data = body['data'] as List;
        return data
            .whereType<Map<String, dynamic>>()
            .map(Question.fromJson)
            .where((q) => q.text.isNotEmpty && q.options.length >= 2)
            .toList();
      }
    }

    if (response.statusCode == 401) {
      throw Exception('Invalid or missing API key (401).');
    }
    if (response.statusCode == 429) {
      throw Exception('Rate limited. Please wait and try again.');
    }

    throw Exception('Failed to load questions (${response.statusCode}).');
  }
}
