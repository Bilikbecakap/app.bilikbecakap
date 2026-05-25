import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../models/artikel_model.dart';

class ArtikelService {
  static const _endpoint = 'https://bilikbecakap.com/api/v1/artikel';
  static const boxName = 'artikelListBox';

  Future<List<ArtikelModel>> fetchTerbaru() async {
    final box = Hive.box<String>(boxName);
    final uri = Uri.parse(_endpoint).replace(queryParameters: {
      'sort': 'tanggal',
      'direction': 'desc',
      'per_page': '3',
    });

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        await box.put('terbaru', response.body);
        return _parse(response.body);
      }
    } catch (_) {
      final cached = box.get('terbaru');
      if (cached != null) return _parse(cached);
      rethrow;
    }

    final cached = box.get('terbaru');
    if (cached != null) return _parse(cached);
    throw Exception('Gagal memuat artikel');
  }

  List<ArtikelModel> _parse(String body) {
    final json = jsonDecode(body) as Map<String, dynamic>;
    final data = json['data'] as List<dynamic>;
    return data
        .map((e) => ArtikelModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
