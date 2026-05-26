class KuisModel {
  final int id;
  final String slug;
  final String title;
  final String description;
  final String? thumbnailUrl;
  final String? musicUrl;
  final int duration;
  final String type;
  final int totalQuestions;

  const KuisModel({
    required this.id,
    required this.slug,
    required this.title,
    required this.description,
    this.thumbnailUrl,
    this.musicUrl,
    required this.duration,
    required this.type,
    required this.totalQuestions,
  });

  factory KuisModel.fromJson(Map<String, dynamic> json) {
    return KuisModel(
      id: json['id'] as int,
      slug: json['slug'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      thumbnailUrl: json['thumbnail_url'] as String?,
      musicUrl: json['music_url'] as String?,
      duration: json['duration'] as int? ?? 10,
      type: json['type'] as String? ?? 'umum',
      totalQuestions: json['total_questions'] as int? ?? 0,
    );
  }
}
