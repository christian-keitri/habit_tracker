import 'package:flutter/material.dart';
import 'screens/phase1.dart'; // Make sure this path is correct

void main() {
  runApp(const HabitTrackerApp());
}

class HabitTrackerApp extends StatelessWidget {
  const HabitTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Habit Tracker',
      theme: ThemeData(primarySwatch: Colors.teal),
      home:  Phase1(),
    );
  }
}
