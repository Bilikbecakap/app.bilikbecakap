import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

class ProfilService {
  static const String boxName = 'profilBox';

  static Box<String> get _box => Hive.box<String>(boxName);

  static Map<String, dynamic> _getData() {
    final raw = _box.get('data');
    if (raw == null) return {};
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  static String? getNama() => _getData()['nama'] as String?;
  static String? getPeran() => _getData()['peran'] as String?;
  static String? getKontak() => _getData()['kontak'] as String?;
  static bool sudahSetup() => getNama() != null;

  static Future<void> simpan({
    required String nama,
    required String peran,
    String? kontak,
  }) async {
    final data = <String, String>{
      'nama': nama,
      'peran': peran,
      if (kontak != null && kontak.isNotEmpty) 'kontak': kontak,
    };
    await _box.put('data', jsonEncode(data));
  }
}
