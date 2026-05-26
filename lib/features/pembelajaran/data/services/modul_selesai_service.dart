import 'package:hive/hive.dart';

class ModulSelesaiService {
  static const boxName = 'modulSelesaiBox';

  static bool isSelesai(String slug) =>
      Hive.box<bool>(boxName).get(slug, defaultValue: false)!;

  static Future<void> toggle(String slug) {
    final box = Hive.box<bool>(boxName);
    return box.put(slug, !isSelesai(slug));
  }

  static Set<String> getAllSelesai() {
    final box = Hive.box<bool>(boxName);
    return box.keys
        .where((k) => box.get(k) == true)
        .map((k) => k.toString())
        .toSet();
  }
}
