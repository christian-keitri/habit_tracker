import 'package:hive/hive.dart';

part 'habit.g.dart';

@HiveType(typeId: 0)
class Habit extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  bool isBad;

  @HiveField(2)
  String icon;

  @HiveField(3)
  double progress;

  @HiveField(4)
  bool isFavorite;

  @HiveField(5)
  Map<String, double> dailyProgress;

  Habit({
    required this.title,
    required this.isBad,
    required this.icon,
    this.progress = 0.0,
    this.isFavorite = false,
    Map<String, double>? dailyProgress,
  }) : dailyProgress = dailyProgress ?? {};

  /// ✅ Method to calculate the current streak based on dailyProgress
  int getStreak() {
    final now = DateTime.now();
    int streak = 0;

    for (int i = 0; i < 30; i++) {
      final date = now.subtract(Duration(days: i));
      final key = '${date.year}-${date.month}-${date.day}';

      if (dailyProgress.containsKey(key) && dailyProgress[key]! >= 1.0) {
        streak++;
      } else {
        break; // Stop counting if a day is missed
      }
    }

    return streak;
  }
}
