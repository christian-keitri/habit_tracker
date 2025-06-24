import 'package:flutter/material.dart';
import 'dart:math';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:habit_tracker/screens/habit.dart';

class StreaksScreen extends StatelessWidget {
  const StreaksScreen({super.key});

  // List of motivational quotes
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

  @override
  Widget build(BuildContext context) {
    final habitBox = Hive.box<Habit>('habits');
    final habits = habitBox.values.toList();
    final totalStreak = calculateTotalStreak(habits);

    final random = Random();
    final quote = quotes[random.nextInt(quotes.length)];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Streaks'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/image/qoutes.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.local_fire_department, size: 100, color: Colors.orange),
                  const SizedBox(height: 20),
                  Text(
                    'You’re on a $totalStreak-day streak!',
                    style: const TextStyle(
                      color: Color.fromARGB(224, 17, 17, 16),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Keep it up and stay consistent 🔥',
                    style: TextStyle(
                      color: Color.fromARGB(179, 14, 13, 13),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Divider(color: Colors.white38),
                  const SizedBox(height: 16),
                  const Text(
                    'Daily Quotes',
                    style: TextStyle(
                      color: Color.fromARGB(255, 14, 14, 13),
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    quote,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 8, 8, 8),
                      fontSize: 28,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}