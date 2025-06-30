import 'package:hive/hive.dart';

part 'journal.g.dart';

@HiveType(typeId: 1)
class JournalEntry extends HiveObject {
  @HiveField(0)
  String habitId;

  @HiveField(1)
  String content;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  String mood; // e.g. "Happy", "Sad", "Anxious"

  @HiveField(4)
  String emoji; // e.g. "😊", "😢"

  JournalEntry({
    required this.habitId,
    required this.content,
    required this.date,
    this.mood = '',
    this.emoji = '',
  });
}
