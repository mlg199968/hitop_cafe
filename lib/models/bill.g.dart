// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BillAdapter extends TypeAdapter<Bill> {
  @override
  final int typeId = 4;

  @override
  Bill read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Bill(
      purchases: (fields[0] as List).cast<Purchase>(),
      payments: (fields[2] as List).cast<Payment>(),
      payable: fields[4] as num,
      discount: fields[8] as num,
      billDate: fields[9] as DateTime,
      billId: fields[10] as String,
      modifiedDate: fields[11] as DateTime,
      dueDate: fields[12] as DateTime?,
      isChecked: fields[13] as bool,
      isDone: fields[14] as bool,
      description: fields[3] as String,
      billNumber: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Bill obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.purchases)
      ..writeByte(1)
      ..write(obj.billNumber)
      ..writeByte(2)
      ..write(obj.payments)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.payable)
      ..writeByte(8)
      ..write(obj.discount)
      ..writeByte(9)
      ..write(obj.billDate)
      ..writeByte(10)
      ..write(obj.billId)
      ..writeByte(11)
      ..write(obj.modifiedDate)
      ..writeByte(12)
      ..write(obj.dueDate)
      ..writeByte(13)
      ..write(obj.isChecked)
      ..writeByte(14)
      ..write(obj.isDone)
      ..writeByte(5)
      ..write(obj.waresSum)
      ..writeByte(6)
      ..write(obj.cashSum)
      ..writeByte(7)
      ..write(obj.atmSum);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BillAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
