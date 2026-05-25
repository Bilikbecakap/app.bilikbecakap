class TerjemahanModel {
  final String translation;
  final String? confidence;
  final List<String>? matchedTerms;
  final List<String>? untranslatedWords;

  const TerjemahanModel({
    required this.translation,
    this.confidence,
    this.matchedTerms,
    this.untranslatedWords,
  });

  factory TerjemahanModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return TerjemahanModel(
      translation: data['translation'] as String,
      confidence: data['confidence'] as String?,
      matchedTerms: (data['matched_terms'] as List<dynamic>?)
          ?.whereType<String>()
          .toList(),
      untranslatedWords: (data['untranslated_words'] as List<dynamic>?)
          ?.whereType<String>()
          .toList(),
    );
  }
}
