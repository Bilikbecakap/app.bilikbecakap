import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../models/kuis_model.dart';
import '../models/kuis_soal_model.dart';
import '../models/kuis_hasil_model.dart';

class KuisService {
  static const _baseUrl = 'https://bilikbecakap.com/api/v1';
  static const listBoxName = 'kuisListBox';

  Future<List<KuisModel>> fetchDaftarKuis() async {
    final box = Hive.box<String>(listBoxName);
    const cacheKey = 'daftar_umum';
    final uri = Uri.parse('$_baseUrl/kuis').replace(
      queryParameters: {'type': 'umum', 'per_page': '20'},
    );

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        await box.put(cacheKey, response.body);
        return _parseList(response.body);
      }
    } catch (_) {
      final cached = box.get(cacheKey);
      if (cached != null) return _parseList(cached);
      rethrow;
    }

    final cached = box.get(cacheKey);
    if (cached != null) return _parseList(cached);
    throw Exception('Gagal memuat daftar kuis');
  }

  Future<KuisMulaiResponse> mulaiKuis(
    String slug,
    String participantName,
  ) async {
    final uri = Uri.parse('$_baseUrl/kuis/$slug/mulai');
    final response = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'participant_name': participantName}),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 201) {
      return KuisMulaiResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    throw Exception('Gagal memulai kuis');
  }

  Future<KuisHasilResponse> submitKuis(
    String slug, {
    int? attemptId,
    String? participantName,
    String? startedAt,
    String? completedAt,
    required List<Map<String, int>> answers,
  }) async {
    final uri = Uri.parse('$_baseUrl/kuis/$slug/submit');
    final body = <String, dynamic>{'answers': answers};

    if (attemptId != null) {
      body['attempt_id'] = attemptId;
    } else {
      body['participant_name'] = participantName;
      body['started_at'] = startedAt;
      body['completed_at'] = completedAt;
    }

    final response = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      return KuisHasilResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    throw Exception('Gagal menyimpan jawaban');
  }

  List<KuisModel> _parseList(String body) {
    final json = jsonDecode(body) as Map<String, dynamic>;
    return (json['data'] as List<dynamic>)
        .map((e) => KuisModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
