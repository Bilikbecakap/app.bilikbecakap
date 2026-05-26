class KuisOptionModel {
  final int id;
  final String optionText;

  const KuisOptionModel({required this.id, required this.optionText});

  factory KuisOptionModel.fromJson(Map<String, dynamic> json) {
    return KuisOptionModel(
      id: json['id'] as int,
      optionText: json['option_text'] as String,
    );
  }
}

class KuisSoalModel {
  final int id;
  final String question;
  final int order;
  final List<KuisOptionModel> options;

  const KuisSoalModel({
    required this.id,
    required this.question,
    required this.order,
    required this.options,
  });

  factory KuisSoalModel.fromJson(Map<String, dynamic> json) {
    return KuisSoalModel(
      id: json['id'] as int,
      question: json['question'] as String,
      order: json['order'] as int? ?? 0,
      options: (json['options'] as List<dynamic>)
          .map((e) => KuisOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class KuisMulaiResponse {
  final int attemptId;
  final String quizTitle;
  final String? musicUrl;
  final int duration;
  final List<KuisSoalModel> soal;

  const KuisMulaiResponse({
    required this.attemptId,
    required this.quizTitle,
    this.musicUrl,
    required this.duration,
    required this.soal,
  });

  factory KuisMulaiResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final quiz = data['quiz'] as Map<String, dynamic>;
    return KuisMulaiResponse(
      attemptId: data['attempt_id'] as int,
      quizTitle: quiz['title'] as String,
      musicUrl: quiz['music_url'] as String?,
      duration: quiz['duration'] as int? ?? 10,
      soal: (data['soal'] as List<dynamic>)
          .map((e) => KuisSoalModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
