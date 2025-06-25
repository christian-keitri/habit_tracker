// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitAdapter extends TypeAdapter<Habit> {
  @override
  final int typeId = 0;

  @override
  Habit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Habit(
      title: fields[0] as String,
      iconPath: fields[1] as String,
      isBad: fields[2] as bool,
      isDailyRoutine: fields[3] as bool,
      isWeeklyRoutine: fields[4] as bool,
      isMonthlyRoutine: fields[5] as bool,
      isFavorite: fields[6] as bool,
      dailyGoal: fields[8] as int?,
      dailyProgress: (fields[7] as Map?)?.cast<String, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, Habit obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.iconPath)
      ..writeByte(2)
      ..write(obj.isBad)
      ..writeByte(3)
      ..write(obj.isDailyRoutine)
      ..writeByte(4)
      ..write(obj.isWeeklyRoutine)
      ..writeByte(5)
      ..write(obj.isMonthlyRoutine)
      ..writeByte(6)
      ..write(obj.isFavorite)
      ..writeByte(7)
      ..write(obj.dailyProgress)
      ..writeByte(8)
      ..write(obj.dailyGoal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
