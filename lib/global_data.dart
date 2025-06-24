// lib/global_data.dart
library;

import 'package:hive/hive.dart';
import 'screens/habit.dart';

class GlobalData {
  static Box<Habit> get habitBox => Hive.box<Habit>('habits');
}
