class KuisReviewOptionModel {
  final int id;
  final String optionText;
  final bool isCorrect;

  const KuisReviewOptionModel({
    required this.id,
    required this.optionText,
    required this.isCorrect,
  });

  factory KuisReviewOptionModel.fromJson(Map<String, dynamic> json) {
    return KuisReviewOptionModel(
      id: json['id'] as int,
      optionText: json['option_text'] as String,
      isCorrect: json['is_correct'] as bool? ?? false,
    );
  }
}

class KuisReviewSoalModel {
  final int questionId;
  final String question;
  final List<KuisReviewOptionModel> options;
  final int? selectedOptionId;
  final bool isCorrect;

  const KuisReviewSoalModel({
    required this.questionId,
    required this.question,
    required this.options,
    this.selectedOptionId,
    required this.isCorrect,
  });

  factory KuisReviewSoalModel.fromJson(Map<String, dynamic> json) {
    return KuisReviewSoalModel(
      questionId: json['question_id'] as int,
      question: json['question'] as String,
      options: (json['options'] as List<dynamic>)
          .map((e) => KuisReviewOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      selectedOptionId: json['selected_option_id'] as int?,
      isCorrect: json['is_correct'] as bool? ?? false,
    );
  }
}

class KuisHasilResponse {
  final int attemptId;
  final double score;
  final int correctAnswers;
  final int totalQuestions;
  final List<KuisReviewSoalModel> review;

  const KuisHasilResponse({
    required this.attemptId,
    required this.score,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.review,
  });

  factory KuisHasilResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return KuisHasilResponse(
      attemptId: data['attempt_id'] as int,
      score: (data['score'] as num).toDouble(),
      correctAnswers: data['correct_answers'] as int,
      totalQuestions: data['total_questions'] as int,
      review: (data['review'] as List<dynamic>)
          .map((e) => KuisReviewSoalModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
