// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'production.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductionAdapter extends TypeAdapter<Production> {
  @override
  final int typeId = 0;

  @override
  Production read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Production(
      date: fields[0] as DateTime,
      eggs: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Production obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.eggs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
