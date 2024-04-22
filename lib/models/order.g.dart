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
      ..description = fields[3] as String?
      ..orderType = fields[4] as String?
      ..orderDate = fields[5] as DateTime
      ..orderId = fields[6] as String
      ..modifiedDate = fields[7] as DateTime
      ..dueDate = fields[8] as DateTime?
      ..isChecked = fields[9] as bool
      ..isDone = fields[10] as bool
      ..billNumber = fields[11] as int?
      ..tax = fields[12] as int?
      ..user = fields[13] as User?
      ..customer = fields[14] as Customer?
      ..takeaway = fields[15] as bool?;
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
      ..write(obj.orderType)
      ..writeByte(5)
      ..write(obj.orderDate)
      ..writeByte(6)
      ..write(obj.orderId)
      ..writeByte(7)
      ..write(obj.modifiedDate)
      ..writeByte(8)
      ..write(obj.dueDate)
      ..writeByte(9)
      ..write(obj.isChecked)
      ..writeByte(10)
      ..write(obj.isDone)
      ..writeByte(11)
      ..write(obj.billNumber)
      ..writeByte(12)
      ..write(obj.tax)
      ..writeByte(13)
      ..write(obj.user)
      ..writeByte(14)
      ..write(obj.customer)
      ..writeByte(15)
      ..write(obj.takeaway);
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
