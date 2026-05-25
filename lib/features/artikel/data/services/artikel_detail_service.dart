import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../models/artikel_detail_model.dart';

class ArtikelDetailService {
  static const _baseUrl = 'https://bilikbecakap.com/api/v1';
  static const boxName = 'artikelBox';

  Future<ArtikelDetailModel> getDetail(String slug) async {
    final box = Hive.box<ArtikelDetailModel>(boxName);
    final uri = Uri.parse('$_baseUrl/artikel/$slug');

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final data = body['data'] as Map<String, dynamic>;

        final judulRaw = data['judul'];
        final kontenRaw = data['konten'];

        final artikel = ArtikelDetailModel()
          ..slug = data['slug'] as String
          ..judul = judulRaw is Map
              ? (judulRaw['id'] ?? '') as String
              : judulRaw as String
          ..kontenId = kontenRaw is Map
              ? (kontenRaw['id'] ?? '') as String
              : kontenRaw as String
          ..tanggalPublish = data['tanggal_publish'] as String
          ..gambarThumbnail = data['gambar_thumbnail'] as String?;

        await box.put(slug, artikel);
        return artikel;
      }
    } catch (_) {
      // Tidak ada koneksi — coba dari cache
      if (box.containsKey(slug)) return box.get(slug)!;
      rethrow;
    }

    // HTTP error — coba dari cache sebelum lempar exception
    if (box.containsKey(slug)) return box.get(slug)!;
    throw Exception('Gagal memuat artikel');
  }
}
