import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResultsScreen extends StatelessWidget {
  final int score;
  final int total;
  final VoidCallback onReplay;

  const ResultsScreen({
    super.key,
    required this.score,
    required this.total,
    required this.onReplay,
  });

  String get _grade {
    final pct = score / total;
    if (pct >= 0.8) return 'Excellent!';
    if (pct >= 0.6) return 'Good job!';
    if (pct >= 0.4) return 'Keep practicing!';
    return 'Better luck next time!';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/celebration.svg',
                  width: 160,
                  height: 160,
                ),
                const SizedBox(height: 24),
                Text(
                  _grade,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1565C0),
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  '$score / $total correct',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  '${((score / total) * 100).round()}%',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: score >= total * 0.6
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: onReplay,
                  icon: const Icon(Icons.replay),
                  label: const Text('Play Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
