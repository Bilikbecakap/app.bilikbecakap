import 'package:hive/hive.dart';

part 'artikel_detail_model.g.dart';

@HiveType(typeId: 0)
class ArtikelDetailModel extends HiveObject {
  @HiveField(0)
  late String slug;

  @HiveField(1)
  late String judul;

  @HiveField(2)
  late String kontenId;

  @HiveField(3)
  late String tanggalPublish;

  @HiveField(4)
  String? gambarThumbnail;
}
