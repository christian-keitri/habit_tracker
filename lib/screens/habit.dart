import 'package:hive/hive.dart';

part 'habit.g.dart';

@HiveType(typeId: 0)
class Habit extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String iconPath;

  @HiveField(2)
  bool isBad;

  @HiveField(3)
  bool isDailyRoutine;

  @HiveField(4)
  bool isWeeklyRoutine;

  @HiveField(5)
  bool isMonthlyRoutine;

  @HiveField(6)
  bool isFavorite;

  @HiveField(7)
  Map<String, int> dailyProgress;

  @HiveField(8)
  int? dailyGoal;

 Habit({
  required this.title,
  required this.iconPath,
  this.isBad = false,
  this.isDailyRoutine = false,
  this.isWeeklyRoutine = false,
  this.isMonthlyRoutine = false,
  this.isFavorite = false,
  this.dailyGoal = 1,
  Map<String, int>? dailyProgress,
}) : dailyProgress = dailyProgress ?? {};


  /// Calculates how many consecutive days up to today this habit
  /// has been marked complete.
 int getStreak() {
  final now = DateTime.now();
  int streak = 0;

  for (int i = 0; i < 30; i++) {
    final date = now.subtract(Duration(days: i));
    final key = '${date.year}-${date.month}-${date.day}';
    final progress = dailyProgress[key] ?? 0;

    if (dailyGoal != null) {
      if (progress >= dailyGoal!) {
        streak++;
      } else {
        break;
      }
    } else {
      if (progress >= 1) {
        streak++;
      } else {
        break;
      }
    }
  }

  return streak;
}
}