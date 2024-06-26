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
      ..printer2 = (fields[13] as Map?)?.cast<dynamic, dynamic>()
      ..printerIp = fields[14] as String?
      ..printerIp2 = fields[15] as String?
      ..printTemplate = fields[16] as String?
      ..printTemplate2 = fields[17] as String?
      ..fontFamily = fields[18] as String?
      ..activeUser = fields[19] as User?
      ..appType = fields[20] as String?
      ..userLevel = fields[21] as int?
      ..port = fields[22] as int?
      ..ipAddress = fields[23] as String?
      ..subnet = fields[24] as String?
      ..backupDirectory = fields[25] as String?
      ..subscription = fields[26] as Subscription?
      ..descriptionList = (fields[27] as List?)
          ?.map((dynamic e) => (e as Map).cast<dynamic, dynamic>())
          .toList()
      ..saveBackupOnExist = fields[28] as bool?;
  }

  @override
  void write(BinaryWriter writer, Shop obj) {
    writer
      ..writeByte(29)
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
      ..write(obj.printer2)
      ..writeByte(14)
      ..write(obj.printerIp)
      ..writeByte(15)
      ..write(obj.printerIp2)
      ..writeByte(16)
      ..write(obj.printTemplate)
      ..writeByte(17)
      ..write(obj.printTemplate2)
      ..writeByte(18)
      ..write(obj.fontFamily)
      ..writeByte(19)
      ..write(obj.activeUser)
      ..writeByte(20)
      ..write(obj.appType)
      ..writeByte(21)
      ..write(obj.userLevel)
      ..writeByte(22)
      ..write(obj.port)
      ..writeByte(23)
      ..write(obj.ipAddress)
      ..writeByte(24)
      ..write(obj.subnet)
      ..writeByte(25)
      ..write(obj.backupDirectory)
      ..writeByte(26)
      ..write(obj.subscription)
      ..writeByte(27)
      ..write(obj.descriptionList)
      ..writeByte(28)
      ..write(obj.saveBackupOnExist);
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
