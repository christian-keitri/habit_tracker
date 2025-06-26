import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:habit_tracker/screens/habit.dart';
import 'package:habit_tracker/screens/journal.dart'; // JournalEntry model
import 'package:habit_tracker/screens/phase1.dart'; // Entry point screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register Adapters
  Hive.registerAdapter(HabitAdapter());
  Hive.registerAdapter(JournalEntryAdapter());

  // Open Hive boxes
  await Hive.openBox<Habit>('habits');
  await Hive.openBox<JournalEntry>('journals');

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
      home: const Phase1(), // Change to Phase2(), Phase4(), etc. as needed
    );
  }
}
