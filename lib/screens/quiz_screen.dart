import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/question.dart';
import '../services/trivia_service.dart';
import 'results_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Future<List<Question>> _questionsFuture;
  List<Question> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  String? _selectedAnswer;
  bool _answered = false;
  List<String> _shuffledOptions = [];

  @override
  void initState() {
    super.initState();
    _questionsFuture = TriviaService().fetchQuestions();
    _questionsFuture.then((questions) {
      if (mounted) {
        setState(() {
          _questions = questions;
          _shuffleOptions();
        });
      }
    });
  }

  void _shuffleOptions() {
    if (_questions.isEmpty) return;
    final options = List<String>.from(_questions[_currentIndex].options);
    options.shuffle(Random());
    _shuffledOptions = options;
  }

  void _onAnswerTapped(String answer) {
    if (_answered) return;
    setState(() {
      _selectedAnswer = answer;
      _answered = true;
      if (answer == _questions[_currentIndex].correctAnswer) {
        _score++;
      }
    });
    Future.delayed(const Duration(seconds: 2), _nextQuestion);
  }

  void _nextQuestion() {
    if (!mounted) return;
    if (_currentIndex + 1 >= _questions.length) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultsScreen(
            score: _score,
            total: _questions.length,
            onReplay: _restartQuiz,
          ),
        ),
      );
      return;
    }
    setState(() {
      _currentIndex++;
      _selectedAnswer = null;
      _answered = false;
      _shuffleOptions();
    });
  }

  void _restartQuiz() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const QuizScreen()),
    );
  }

  Color _buttonColor(String option) {
    if (!_answered) return Colors.white;
    final correct = _questions[_currentIndex].correctAnswer;
    if (option == correct) return Colors.green.shade100;
    if (option == _selectedAnswer) return Colors.red.shade100;
    return Colors.white;
  }

  Color _buttonBorderColor(String option) {
    if (!_answered) return Colors.grey.shade300;
    final correct = _questions[_currentIndex].correctAnswer;
    if (option == correct) return Colors.green.shade600;
    if (option == _selectedAnswer) return Colors.red.shade600;
    return Colors.grey.shade300;
  }

  Widget? _trailingIcon(String option) {
    if (!_answered) return null;
    final correct = _questions[_currentIndex].correctAnswer;
    if (option == correct) {
      return SvgPicture.asset('assets/icons/correct.svg', width: 28, height: 28);
    }
    if (option == _selectedAnswer) {
      return SvgPicture.asset('assets/icons/incorrect.svg', width: 28, height: 28);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text('Quiz'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<List<Question>>(
        future: _questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoading();
          }
          if (snapshot.hasError) {
            return _buildError(snapshot.error.toString());
          }
          if (_questions.isEmpty) {
            return _buildError('No questions returned. Check filters or API key.');
          }
          return _buildQuiz();
        },
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/loading.svg', width: 120, height: 120),
          const SizedBox(height: 24),
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          const Text('Loading questions...', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Could not load questions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _restartQuiz,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuiz() {
    final question = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${_currentIndex + 1} of ${_questions.length}',
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                Text(
                  'Score: $_score',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              color: const Color(0xFF1565C0),
              minHeight: 6,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _difficultyChip(question.difficulty),
                const SizedBox(width: 8),
                _categoryChip(question.category),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  question.text,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: _shuffledOptions.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final option = _shuffledOptions[i];
                  return GestureDetector(
                    onTap: () => _onAnswerTapped(option),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: _buttonColor(option),
                        border: Border.all(
                            color: _buttonBorderColor(option), width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(option,
                                style: const TextStyle(fontSize: 16)),
                          ),
                          if (_trailingIcon(option) != null)
                            _trailingIcon(option)!,
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_answered)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: TextButton.icon(
                  onPressed: _nextQuestion,
                  icon: const Icon(Icons.arrow_forward),
                  label: Text(_currentIndex + 1 >= _questions.length
                      ? 'See Results'
                      : 'Next Question'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _difficultyChip(String difficulty) {
    final colors = {
      'EASY': Colors.green,
      'MEDIUM': Colors.orange,
      'HARD': Colors.red,
      'EXPERT': Colors.purple,
    };
    final color = colors[difficulty.toUpperCase()] ?? Colors.grey;
    return Chip(
      label: Text(difficulty,
          style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide(color: color.shade200),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _categoryChip(String category) {
    return Chip(
      label: Text(category,
          style: const TextStyle(fontSize: 11, color: Colors.blueGrey)),
      backgroundColor: Colors.blueGrey.shade50,
      side: BorderSide(color: Colors.blueGrey.shade100),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}
