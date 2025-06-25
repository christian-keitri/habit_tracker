import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:habit_tracker/screens/habit.dart';
import 'package:habit_tracker/screens/phase1.dart'; // Your initial screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(HabitAdapter());

  // ⚠️ Temporarily clear old corrupted data for development
  await Hive.deleteBoxFromDisk('habits');

  await Hive.openBox<Habit>('habits');

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
      home: const Phase1(), // Set this to Phase2(), Phase4(), etc. if needed
    );
  }
}
