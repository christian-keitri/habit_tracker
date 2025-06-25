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
  Map<String, double> dailyProgress;

  Habit({
    required this.title,
    required this.iconPath,
    this.isBad = false,
    this.isDailyRoutine = false,
    this.isWeeklyRoutine = false,
    this.isMonthlyRoutine = false,
    this.isFavorite = false,
    Map<String, double>? dailyProgress,
  }) : dailyProgress = dailyProgress ?? {};

  /// Calculates how many consecutive days up to today this habit
  /// has been marked complete.
  int getStreak() {
    final now = DateTime.now();
    int streak = 0;

    for (int i = 0; i < 30; i++) {
      final date = now.subtract(Duration(days: i));
      final key = '${date.year}-${date.month}-${date.day}';

      if (dailyProgress[key] == 1.0) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }
}
