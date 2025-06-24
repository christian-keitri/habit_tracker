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
      isBad: fields[1] as bool,
      icon: fields[2] as String,
      progress: fields[3] as double,
      isFavorite: fields[4] as bool,
      dailyProgress: (fields[5] as Map?)?.cast<String, double>(),
    );
  }

  @override
  void write(BinaryWriter writer, Habit obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.isBad)
      ..writeByte(2)
      ..write(obj.icon)
      ..writeByte(3)
      ..write(obj.progress)
      ..writeByte(4)
      ..write(obj.isFavorite)
      ..writeByte(5)
      ..write(obj.dailyProgress);
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
