// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PriceAdapter extends TypeAdapter<Price> {
  @override
  final int typeId = 22;

  @override
  Price read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Price()
      ..mainPrice = fields[0] as num
      ..discount = fields[1] as int?
      ..fixDiscount = fields[2] as num?
      ..startDate = fields[3] as DateTime?
      ..endDate = fields[4] as DateTime?
      ..priceId = fields[5] as int;
  }

  @override
  void write(BinaryWriter writer, Price obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.mainPrice)
      ..writeByte(1)
      ..write(obj.discount)
      ..writeByte(2)
      ..write(obj.fixDiscount)
      ..writeByte(3)
      ..write(obj.startDate)
      ..writeByte(4)
      ..write(obj.endDate)
      ..writeByte(5)
      ..write(obj.priceId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PriceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
