// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubscriptionAdapter extends TypeAdapter<Subscription> {
  @override
  final int typeId = 8;

  @override
  Subscription read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Subscription()
      ..name = fields[0] as String
      ..phoneNumber = fields[1] as String
      ..email = fields[2] as String?
      ..level = fields[3] as int
      ..startDate = fields[4] as DateTime?
      ..endDate = fields[5] as DateTime?
      ..payAmount = fields[6] as double?
      ..authority = fields[7] as String?
      ..status = fields[8] as String?
      ..refId = fields[9] as String?
      ..deviceId = fields[10] as String?
      ..description = fields[11] as String
      ..id = fields[12] as int?;
  }

  @override
  void write(BinaryWriter writer, Subscription obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.phoneNumber)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.level)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.endDate)
      ..writeByte(6)
      ..write(obj.payAmount)
      ..writeByte(7)
      ..write(obj.authority)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.refId)
      ..writeByte(10)
      ..write(obj.deviceId)
      ..writeByte(11)
      ..write(obj.description)
      ..writeByte(12)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
