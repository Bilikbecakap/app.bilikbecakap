import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/terjemahan_model.dart';

class PenerjemahService {
  static const _endpoint = 'https://bilikbecakap.com/api/v1/penerjemah';

  static bool butuhMethod(String direction) =>
      direction == 'belitung_to_indonesia' ||
      direction == 'indonesia_to_belitung';

  Future<TerjemahanModel> terjemahkan({
    required String text,
    required String direction,
    String method = 'hybrid',
  }) async {
    final body = <String, String>{
      'text': text,
      'direction': direction,
      if (butuhMethod(direction)) 'method': method,
    };

    final response = await http
        .post(
          Uri.parse(_endpoint),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      return TerjemahanModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    throw Exception('Gagal menerjemahkan (${response.statusCode})');
  }
}
