class ModulDetailModel {
  final int id;
  final String slug;
  final String title;
  final String deskripsi;
  final String content;
  final String? pdfUrl;
  final String? videoEmbedId;
  final String? thumbnailUrl;
  final String kategoriNama;
  final int viewCount;
  final int readingTime;
  final String tanggalPublish;

  const ModulDetailModel({
    required this.id,
    required this.slug,
    required this.title,
    required this.deskripsi,
    required this.content,
    this.pdfUrl,
    this.videoEmbedId,
    this.thumbnailUrl,
    required this.kategoriNama,
    required this.viewCount,
    required this.readingTime,
    required this.tanggalPublish,
  });

  factory ModulDetailModel.fromJson(Map<String, dynamic> json) {
    return ModulDetailModel(
      id: json['id'] as int,
      slug: json['slug'] as String,
      title: json['title'] as String,
      deskripsi: json['deskripsi'] as String? ?? '',
      content: json['content'] as String? ?? '',
      pdfUrl: json['pdf_url'] as String?,
      videoEmbedId: json['video_embed_id'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      kategoriNama:
          (json['kategori'] as Map<String, dynamic>?)?['nama'] as String? ?? '',
      viewCount: json['view_count'] as int? ?? 0,
      readingTime: json['reading_time'] as int? ?? 0,
      tanggalPublish: json['tanggal_publish'] as String? ?? '',
    );
  }
}
