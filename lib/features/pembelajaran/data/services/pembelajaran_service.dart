import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../models/modul_model.dart';
import '../models/modul_detail_model.dart';

class PembelajaranListResponse {
  final List<ModulModel> data;
  final int currentPage;
  final int lastPage;
  final int total;

  const PembelajaranListResponse({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });
}

class PembelajaranService {
  static const _baseUrl = 'https://bilikbecakap.com/api/v1';
  static const listBoxName = 'modulListBox';
  static const detailBoxName = 'modulDetailBox';

  Future<PembelajaranListResponse> fetchDaftarModul({int page = 1}) async {
    final box = Hive.box<String>(listBoxName);
    final cacheKey = 'daftar_page_$page';
    final uri = Uri.parse('$_baseUrl/pembelajaran').replace(
      queryParameters: {'page': '$page'},
    );

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        await box.put(cacheKey, response.body);
        return _parseListResponse(response.body);
      }
    } catch (_) {
      final cached = box.get(cacheKey);
      if (cached != null) return _parseListResponse(cached);
      rethrow;
    }

    final cached = box.get(cacheKey);
    if (cached != null) return _parseListResponse(cached);
    throw Exception('Gagal memuat daftar modul');
  }

  Future<ModulDetailModel> fetchDetailModul(String slug) async {
    final box = Hive.box<String>(detailBoxName);
    final uri = Uri.parse('$_baseUrl/pembelajaran/$slug');

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        await box.put(slug, response.body);
        return _parseDetail(response.body);
      }
    } catch (_) {
      final cached = box.get(slug);
      if (cached != null) return _parseDetail(cached);
      rethrow;
    }

    final cached = box.get(slug);
    if (cached != null) return _parseDetail(cached);
    throw Exception('Gagal memuat detail modul');
  }

  PembelajaranListResponse _parseListResponse(String body) {
    final json = jsonDecode(body) as Map<String, dynamic>;
    final data = (json['data'] as List<dynamic>)
        .map((e) => ModulModel.fromJson(e as Map<String, dynamic>))
        .toList();
    final meta = json['meta'] as Map<String, dynamic>? ?? {};
    return PembelajaranListResponse(
      data: data,
      currentPage: meta['current_page'] as int? ?? 1,
      lastPage: meta['last_page'] as int? ?? 1,
      total: meta['total'] as int? ?? data.length,
    );
  }

  ModulDetailModel _parseDetail(String body) {
    final json = jsonDecode(body) as Map<String, dynamic>;
    final data = json['data'] as Map<String, dynamic>;
    return ModulDetailModel.fromJson(data);
  }
}
