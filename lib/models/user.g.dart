// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 11;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User()
      ..name = fields[0] as String
      ..userName = fields[1] as String?
      ..password = fields[2] as String
      ..accessList = (fields[3] as List).cast<dynamic>()
      ..userType = fields[4] as String
      ..image = fields[5] as String?
      ..socialCode = fields[6] as String?
      ..email = fields[7] as String?
      ..phone = fields[8] as String?
      ..description = fields[9] as String?
      ..score = fields[10] as double?
      ..createDate = fields[11] as DateTime
      ..modifiedDate = fields[12] as DateTime
      ..userId = fields[13] as String
      ..userDevice = fields[14] as String?;
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.userName)
      ..writeByte(2)
      ..write(obj.password)
      ..writeByte(3)
      ..write(obj.accessList)
      ..writeByte(4)
      ..write(obj.userType)
      ..writeByte(5)
      ..write(obj.image)
      ..writeByte(6)
      ..write(obj.socialCode)
      ..writeByte(7)
      ..write(obj.email)
      ..writeByte(8)
      ..write(obj.phone)
      ..writeByte(9)
      ..write(obj.description)
      ..writeByte(10)
      ..write(obj.score)
      ..writeByte(11)
      ..write(obj.createDate)
      ..writeByte(12)
      ..write(obj.modifiedDate)
      ..writeByte(13)
      ..write(obj.userId)
      ..writeByte(14)
      ..write(obj.userDevice);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
