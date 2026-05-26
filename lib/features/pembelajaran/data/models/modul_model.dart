class ModulModel {
  final int id;
  final String slug;
  final String title;
  final String deskripsi;
  final String excerpt;
  final String? thumbnailUrl;
  final String kategoriNama;
  final int viewCount;
  final int readingTime;
  final String tanggalPublish;

  const ModulModel({
    required this.id,
    required this.slug,
    required this.title,
    required this.deskripsi,
    required this.excerpt,
    this.thumbnailUrl,
    required this.kategoriNama,
    required this.viewCount,
    required this.readingTime,
    required this.tanggalPublish,
  });

  factory ModulModel.fromJson(Map<String, dynamic> json) {
    return ModulModel(
      id: json['id'] as int,
      slug: json['slug'] as String,
      title: json['title'] as String,
      deskripsi: json['deskripsi'] as String? ?? '',
      excerpt: json['excerpt'] as String? ?? '',
      thumbnailUrl: json['thumbnail_url'] as String?,
      kategoriNama:
          (json['kategori'] as Map<String, dynamic>?)?['nama'] as String? ?? '',
      viewCount: json['view_count'] as int? ?? 0,
      readingTime: json['reading_time'] as int? ?? 0,
      tanggalPublish: json['tanggal_publish'] as String? ?? '',
    );
  }
}
