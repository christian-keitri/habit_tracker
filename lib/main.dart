import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:habit_tracker/screens/habit.dart';
import 'package:habit_tracker/screens/journal.dart'; // JournalEntry model
import 'package:habit_tracker/screens/phase1.dart'; // First screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register Hive adapters (must match your model's typeId)
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
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const Phase1(), // Change to Phase2, Phase3, etc. during testing
    );
  }
}
