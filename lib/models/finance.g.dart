// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FinanceAdapter extends TypeAdapter<Finance> {
  @override
  final int typeId = 1;

  @override
  Finance read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Finance(
      date: fields[0] as DateTime,
      amount: fields[1] as double,
      note: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Finance obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinanceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
