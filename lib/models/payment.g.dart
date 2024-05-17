// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PaymentAdapter extends TypeAdapter<Payment> {
  @override
  final int typeId = 3;

  @override
  Payment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Payment()
      ..amount = fields[0] as num
      ..method = fields[1] as String?
      ..paymentId = fields[2] as String
      ..deliveryDate = fields[3] as DateTime
      ..isChecked = fields[4] as bool
      ..description = fields[5] as String?;
  }

  @override
  void write(BinaryWriter writer, Payment obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.amount)
      ..writeByte(1)
      ..write(obj.method)
      ..writeByte(2)
      ..write(obj.paymentId)
      ..writeByte(3)
      ..write(obj.deliveryDate)
      ..writeByte(4)
      ..write(obj.isChecked)
      ..writeByte(5)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
