// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PurchaseAdapter extends TypeAdapter<Purchase> {
  @override
  final int typeId = 5;

  @override
  Purchase read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Purchase(
      wareName: fields[0] as String,
      unit: fields[1] as String,
      description: fields[3] as String,
      price: fields[2] as num,
      quantity: fields[4] as double,
      createDate: fields[5] as DateTime,
      purchaseId: fields[6] as String,
      isChecked: fields[7] as bool,
      discount: fields[9] as num,
      tax: fields[10] as num,
    );
  }

  @override
  void write(BinaryWriter writer, Purchase obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.wareName)
      ..writeByte(1)
      ..write(obj.unit)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.quantity)
      ..writeByte(5)
      ..write(obj.createDate)
      ..writeByte(6)
      ..write(obj.purchaseId)
      ..writeByte(7)
      ..write(obj.isChecked)
      ..writeByte(9)
      ..write(obj.discount)
      ..writeByte(10)
      ..write(obj.tax)
      ..writeByte(8)
      ..write(obj.sum);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PurchaseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
