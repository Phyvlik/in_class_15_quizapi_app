import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'quiz_screen.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final List<String> missedCategories;
  final String currentDifficulty;

  const ResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.missedCategories,
    required this.currentDifficulty,
  });

  String get _message {
    final pct = score / total;
    if (pct == 1.0) return 'Perfect Score! 🏆';
    if (pct >= 0.8) return 'Excellent! 🎉';
    if (pct >= 0.6) return 'Good Job! 👍';
    if (pct >= 0.4) return 'Keep Practicing! 💪';
    return 'Better luck next time! 🎯';
  }

  // Option 2: Difficulty Personalization Engine
  String get _nextDifficulty {
    final pct = score / total;
    if (pct >= 0.8) {
      if (currentDifficulty == 'EASY') return 'MEDIUM';
      if (currentDifficulty == 'MEDIUM') return 'HARD';
      return 'HARD';
    }
    if (pct < 0.4) {
      if (currentDifficulty == 'HARD') return 'MEDIUM';
      if (currentDifficulty == 'MEDIUM') return 'EASY';
      return 'EASY';
    }
    return currentDifficulty;
  }

  String get _difficultyMessage {
    if (_nextDifficulty != currentDifficulty) {
      return _nextDifficulty.compareTo(currentDifficulty) > 0
          ? 'Great work! Next quiz: $_nextDifficulty difficulty'
          : 'Keep going! Next quiz: $_nextDifficulty difficulty';
    }
    return 'Next quiz: $_nextDifficulty difficulty';
  }

  // Option 3: Smart Review Summary
  Map<String, int> get _missedCategoryCount {
    final map = <String, int>{};
    for (final cat in missedCategories) {
      map[cat] = (map[cat] ?? 0) + 1;
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final missedMap = _missedCategoryCount;

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                Text(
                  'Quiz Complete!',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 28),
                SvgPicture.asset('assets/images/celebration.svg',
                    width: 140, height: 140),
                const SizedBox(height: 16),
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.teal.shade50,
                    border:
                        Border.all(color: Colors.teal.shade400, width: 4),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$score / $total',
                        style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal),
                      ),
                      const Text('Score',
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(_message, style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 12),

                // Option 2: Difficulty adaptation notice
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.teal.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.auto_graph,
                          color: Colors.teal, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        _difficultyMessage,
                        style: TextStyle(
                            color: Colors.teal.shade700,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Option 3: Smart Review Summary
                if (missedMap.isNotEmpty) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Review These Topics',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...missedMap.entries.map((entry) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: Colors.orange.shade200),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.bookmark_outline,
                                color: Colors.orange, size: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                entry.key,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Text(
                              '${entry.value} missed',
                              style: TextStyle(
                                  color: Colors.orange.shade700,
                                  fontSize: 13),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 16),
                ],

                if (missedMap.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Text(
                      'Perfect! No topics to review.',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),

                ElevatedButton.icon(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          QuizScreen(difficulty: _nextDifficulty),
                    ),
                  ),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Play Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
