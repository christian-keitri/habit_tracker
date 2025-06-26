import 'package:hive/hive.dart';

part 'journal.g.dart';

@HiveType(typeId: 1)
class JournalEntry extends HiveObject {
  @HiveField(0)
  String habitId; // Link to Habit key

  @HiveField(1)
  String content;

  @HiveField(2)
  DateTime date;

  JournalEntry({
    required this.habitId,
    required this.content,
    required this.date,
  });
}
