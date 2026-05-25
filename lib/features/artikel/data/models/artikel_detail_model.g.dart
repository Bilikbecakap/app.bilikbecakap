// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artikel_detail_model.dart';

class ArtikelDetailModelAdapter extends TypeAdapter<ArtikelDetailModel> {
  @override
  final int typeId = 0;

  @override
  ArtikelDetailModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ArtikelDetailModel()
      ..slug = fields[0] as String
      ..judul = fields[1] as String
      ..kontenId = fields[2] as String
      ..tanggalPublish = fields[3] as String
      ..gambarThumbnail = fields[4] as String?;
  }

  @override
  void write(BinaryWriter writer, ArtikelDetailModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.slug)
      ..writeByte(1)
      ..write(obj.judul)
      ..writeByte(2)
      ..write(obj.kontenId)
      ..writeByte(3)
      ..write(obj.tanggalPublish)
      ..writeByte(4)
      ..write(obj.gambarThumbnail);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArtikelDetailModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
