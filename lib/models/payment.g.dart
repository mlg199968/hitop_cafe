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
      ..description = fields[5] as String?
      ..chequeDate = fields[6] as DateTime?
      ..chequeSerial = fields[7] as String?
      ..ownerName = fields[8] as String?
      ..ownerPhone = fields[9] as String?
      ..isDone = fields[10] as bool?;
  }

  @override
  void write(BinaryWriter writer, Payment obj) {
    writer
      ..writeByte(11)
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
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.chequeDate)
      ..writeByte(7)
      ..write(obj.chequeSerial)
      ..writeByte(8)
      ..write(obj.ownerName)
      ..writeByte(9)
      ..write(obj.ownerPhone)
      ..writeByte(10)
      ..write(obj.isDone);
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
