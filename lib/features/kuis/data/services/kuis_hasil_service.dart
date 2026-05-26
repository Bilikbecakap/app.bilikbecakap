import 'dart:convert';
import 'package:hive/hive.dart';
import 'kuis_service.dart';

class KuisHasilService {
  static const pendingBoxName = 'kuisPendingBox';

  static Future<void> simpanPending({
    required String slug,
    required String kuisTitle,
    required int attemptId,
    required List<Map<String, int>> answers,
  }) async {
    final box = Hive.box<String>(pendingBoxName);
    final key = 'pending_${DateTime.now().millisecondsSinceEpoch}';
    await box.put(
      key,
      jsonEncode({
        'slug': slug,
        'kuis_title': kuisTitle,
        'attempt_id': attemptId,
        'answers': answers,
      }),
    );
  }

  static bool hasPending() =>
      Hive.box<String>(pendingBoxName).isNotEmpty;

  static Future<void> syncPending(KuisService service) async {
    final box = Hive.box<String>(pendingBoxName);
    for (final key in box.keys.toList()) {
      final raw = box.get(key as String);
      if (raw == null) continue;
      try {
        final data = jsonDecode(raw) as Map<String, dynamic>;
        final answers = (data['answers'] as List<dynamic>)
            .map((e) => {
                  'question_id': e['question_id'] as int,
                  'option_id': e['option_id'] as int,
                })
            .toList();
        await service.submitKuis(
          data['slug'] as String,
          attemptId: data['attempt_id'] as int,
          answers: answers,
        );
        await box.delete(key);
      } catch (_) {
        // Coba lagi di buka berikutnya
      }
    }
  }
}
