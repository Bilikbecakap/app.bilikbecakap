import 'package:hive/hive.dart';

class KuisProfilService {
  static const boxName = 'kuisProfilBox';

  static String? getNama() => Hive.box<String>(boxName).get('nama');

  static Future<void> simpanNama(String nama) =>
      Hive.box<String>(boxName).put('nama', nama);
}
