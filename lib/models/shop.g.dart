// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShopAdapter extends TypeAdapter<Shop> {
  @override
  final int typeId = 6;

  @override
  Shop read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Shop()
      ..shopName = fields[0] as String
      ..address = fields[1] as String
      ..phoneNumber = fields[2] as String
      ..phoneNumber2 = fields[3] as String
      ..description = fields[4] as String
      ..logoImage = fields[5] as String?
      ..signatureImage = fields[6] as String?
      ..stampImage = fields[7] as String?
      ..shopCode = fields[8] as String
      ..currency = fields[9] as String
      ..preTax = fields[10] as double
      ..preBillNumber = fields[11] as int
      ..printer = (fields[12] as Map?)?.cast<dynamic, dynamic>()
      ..fontFamily = fields[13] as String?;
  }

  @override
  void write(BinaryWriter writer, Shop obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.shopName)
      ..writeByte(1)
      ..write(obj.address)
      ..writeByte(2)
      ..write(obj.phoneNumber)
      ..writeByte(3)
      ..write(obj.phoneNumber2)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.logoImage)
      ..writeByte(6)
      ..write(obj.signatureImage)
      ..writeByte(7)
      ..write(obj.stampImage)
      ..writeByte(8)
      ..write(obj.shopCode)
      ..writeByte(9)
      ..write(obj.currency)
      ..writeByte(10)
      ..write(obj.preTax)
      ..writeByte(11)
      ..write(obj.preBillNumber)
      ..writeByte(12)
      ..write(obj.printer)
      ..writeByte(13)
      ..write(obj.fontFamily);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShopAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
