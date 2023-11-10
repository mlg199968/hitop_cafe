// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderAdapter extends TypeAdapter<Order> {
  @override
  final int typeId = 2;

  @override
  Order read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Order()
      ..items = (fields[0] as List).cast<Item>()
      ..tableNumber = fields[1] as int?
      ..payments = (fields[2] as List).cast<Payment>()
      ..description = fields[3] as String
      ..payable = fields[4] as num
      ..discount = fields[8] as num
      ..orderDate = fields[9] as DateTime
      ..orderId = fields[10] as String
      ..modifiedDate = fields[11] as DateTime
      ..dueDate = fields[12] as DateTime?
      ..isChecked = fields[13] as bool
      ..isDone = fields[14] as bool
      ..billNumber = fields[15] as int?;
  }

  @override
  void write(BinaryWriter writer, Order obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.items)
      ..writeByte(1)
      ..write(obj.tableNumber)
      ..writeByte(2)
      ..write(obj.payments)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.payable)
      ..writeByte(8)
      ..write(obj.discount)
      ..writeByte(9)
      ..write(obj.orderDate)
      ..writeByte(10)
      ..write(obj.orderId)
      ..writeByte(11)
      ..write(obj.modifiedDate)
      ..writeByte(12)
      ..write(obj.dueDate)
      ..writeByte(13)
      ..write(obj.isChecked)
      ..writeByte(14)
      ..write(obj.isDone)
      ..writeByte(15)
      ..write(obj.billNumber)
      ..writeByte(5)
      ..write(obj.itemsSum)
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
      other is OrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
