// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NoticeAdapter extends TypeAdapter<Notice> {
  @override
  final int typeId = 9;

  @override
  Notice read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Notice()
      ..title = fields[0] as String
      ..content = fields[1] as String?
      ..link = fields[2] as String?
      ..linkTitle = fields[3] as String?
      ..image = fields[4] as String?
      ..noticeDate = fields[5] as DateTime?
      ..seen = fields[6] as bool
      ..important = fields[7] as bool
      ..noticeId = fields[8] as String;
  }

  @override
  void write(BinaryWriter writer, Notice obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.link)
      ..writeByte(3)
      ..write(obj.linkTitle)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.noticeDate)
      ..writeByte(6)
      ..write(obj.seen)
      ..writeByte(7)
      ..write(obj.important)
      ..writeByte(8)
      ..write(obj.noticeId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoticeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
