// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'raw_ware.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RawWareAdapter extends TypeAdapter<RawWare> {
  @override
  final int typeId = 0;

  @override
  RawWare read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RawWare()
      ..wareName = fields[0] as String
      ..unit = fields[1] as String
      ..category = fields[2] as String
      ..description = fields[3] as String
      ..cost = fields[4] as num
      ..quantity = fields[5] as double
      ..demand = fields[6] as double
      ..modifiedDate = fields[7] as DateTime
      ..createDate = fields[8] as DateTime
      ..wareId = fields[9] as String
      ..isChecked = fields[10] as bool
      ..imagePath = fields[11] as String?
      ..color = fields[12] as String?
      ..warningQuantity = fields[13] as double?;
  }

  @override
  void write(BinaryWriter writer, RawWare obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.wareName)
      ..writeByte(1)
      ..write(obj.unit)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.cost)
      ..writeByte(5)
      ..write(obj.quantity)
      ..writeByte(6)
      ..write(obj.demand)
      ..writeByte(7)
      ..write(obj.modifiedDate)
      ..writeByte(8)
      ..write(obj.createDate)
      ..writeByte(9)
      ..write(obj.wareId)
      ..writeByte(10)
      ..write(obj.isChecked)
      ..writeByte(11)
      ..write(obj.imagePath)
      ..writeByte(12)
      ..write(obj.color)
      ..writeByte(13)
      ..write(obj.warningQuantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RawWareAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
