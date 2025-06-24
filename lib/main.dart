import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:habit_tracker/screens/habit.dart'; // Adjust if your path differs
import 'screens/phase1.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive & register the Habit model
  await Hive.initFlutter();
  Hive.registerAdapter(HabitAdapter());

  // Open the box to store Habit objects
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
      home:  Phase1(),
    );
  }
}
