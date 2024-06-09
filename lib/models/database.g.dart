// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DBAdapter extends TypeAdapter<DB> {
  @override
  final int typeId = 7;

  @override
  DB read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DB()
      ..orders = (fields[0] as List).cast<Order>()
      ..bills = (fields[1] as List).cast<Bill>()
      ..items = (fields[2] as List).cast<Item>()
      ..wares = (fields[3] as List).cast<RawWare>()
      ..databaseId = fields[4] as String
      ..customers = (fields[5] as List?)?.cast<User>()
      ..notes = (fields[6] as List?)?.cast<Note>()
      ..expenses = (fields[7] as List?)?.cast<Payment>();
  }

  @override
  void write(BinaryWriter writer, DB obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.orders)
      ..writeByte(1)
      ..write(obj.bills)
      ..writeByte(2)
      ..write(obj.items)
      ..writeByte(3)
      ..write(obj.wares)
      ..writeByte(4)
      ..write(obj.databaseId)
      ..writeByte(5)
      ..write(obj.customers)
      ..writeByte(6)
      ..write(obj.notes)
      ..writeByte(7)
      ..write(obj.expenses);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DBAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
