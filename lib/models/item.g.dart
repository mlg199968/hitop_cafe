// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemAdapter extends TypeAdapter<Item> {
  @override
  final int typeId = 1;

  @override
  Item read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Item()
      ..itemName = fields[0] as String
      ..unit = fields[1] as String
      ..category = fields[2] as String
      ..description = fields[3] as String
      ..sale = fields[4] as num
      ..ingredients = (fields[5] as List).cast<RawWare>()
      ..modifiedDate = fields[6] as DateTime
      ..createDate = fields[7] as DateTime
      ..itemId = fields[8] as String
      ..isChecked = fields[9] as bool?
      ..imagePath = fields[10] as String?
      ..color = fields[11] as String?
      ..quantity = fields[12] as num
      ..discount = fields[13] as num?;
  }

  @override
  void write(BinaryWriter writer, Item obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.itemName)
      ..writeByte(1)
      ..write(obj.unit)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.sale)
      ..writeByte(5)
      ..write(obj.ingredients)
      ..writeByte(6)
      ..write(obj.modifiedDate)
      ..writeByte(7)
      ..write(obj.createDate)
      ..writeByte(8)
      ..write(obj.itemId)
      ..writeByte(9)
      ..write(obj.isChecked)
      ..writeByte(10)
      ..write(obj.imagePath)
      ..writeByte(11)
      ..write(obj.color)
      ..writeByte(12)
      ..write(obj.quantity)
      ..writeByte(13)
      ..write(obj.discount)
      ..writeByte(14)
      ..write(obj.sum);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
