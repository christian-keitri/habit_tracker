import 'package:flutter/material.dart';
import 'dart:math';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:habit_tracker/screens/habit.dart';

class StreaksScreen extends StatelessWidget {
  const StreaksScreen({super.key});

  final List<String> quotes = const [
    "“Small steps every day lead to big changes.”",
    "“Discipline is choosing between what you want now and what you want most.”",
    "“Your only limit is your mind.”",
    "“Don’t watch the clock; do what it does. Keep going.”",
    "“Success is the sum of small efforts, repeated daily.”",
    "“You don’t have to see the whole staircase, just take the first step.”",
    "“You’ll never change your life until you change something you do daily.”",
    "“You are not your bad habits. You are the person who can change them.”",
  ];

  int calculateTotalStreak(List<Habit> habits) {
    int total = 0;
    for (var habit in habits) {
      total += habit.getStreak();
    }
    return total;
  }

  Habit? getTopHabit(List<Habit> habits) {
    if (habits.isEmpty) return null;
    habits.sort((a, b) => b.getStreak().compareTo(a.getStreak()));
    return habits.first;
  }

  @override
  Widget build(BuildContext context) {
    final habitBox = Hive.box<Habit>('habits');
    final habits = habitBox.values.toList();
    final topHabit = getTopHabit(habits);
    final random = Random();
    final quote = quotes[random.nextInt(quotes.length)];

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/image/black.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Streaks'),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                const Text(
                  'Keep it up and stay consistent 🔥',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),

                if (topHabit != null) ...[
                  const SizedBox(height: 24),
                  Text(
                    '🏆 Longest Streak: "${topHabit.title}"',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${topHabit.getStreak()} days',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],

                const SizedBox(height: 30),
                const Divider(color: Colors.white70),

                const SizedBox(height: 10),
                const Text(
                  'Top Habits',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),

                ...habits
                    .where((h) => h.getStreak() > 0)
                    .take(3)
                    .map(
                      (habit) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              habit.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: (habit.getStreak() / 30).clamp(0.0, 1.0),
                              backgroundColor: Colors.white30,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                habit.getStreak() >= 7
                                    ? Colors.orange
                                    : Colors.greenAccent,
                              ),
                              minHeight: 8,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${habit.getStreak()} day streak',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                const SizedBox(height: 30),
                const Divider(color: Colors.white70),

                const SizedBox(height: 16),
                const Text(
                  '📖 Daily Motivation',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  quote,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
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
