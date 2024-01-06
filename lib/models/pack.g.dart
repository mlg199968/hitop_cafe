// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pack.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PackAdapter extends TypeAdapter<Pack> {
  @override
  final int typeId = 12;

  @override
  Pack read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Pack()
      ..type = fields[0] as String?
      ..message = fields[1] as String?
      ..device = fields[2] as String?
      ..object = (fields[3] as List?)?.cast<dynamic>()
      ..date = fields[4] as DateTime
      ..packId = fields[5] as String;
  }

  @override
  void write(BinaryWriter writer, Pack obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.message)
      ..writeByte(2)
      ..write(obj.device)
      ..writeByte(3)
      ..write(obj.object)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.packId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PackAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
