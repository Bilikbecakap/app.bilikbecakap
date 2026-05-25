class ArtikelModel {
  final String slug;
  final String judul;
  final String excerpt;
  final String? gambarThumbnail;
  final String tanggalPublish;
  final String url;

  const ArtikelModel({
    required this.slug,
    required this.judul,
    required this.excerpt,
    this.gambarThumbnail,
    required this.tanggalPublish,
    required this.url,
  });

  factory ArtikelModel.fromJson(Map<String, dynamic> json) {
    final judul = json['judul'];
    final excerpt = json['excerpt'];
    return ArtikelModel(
      slug: json['slug'] as String,
      judul: judul is Map ? (judul['id'] ?? '') as String : judul as String,
      excerpt:
          excerpt is Map ? (excerpt['id'] ?? '') as String : excerpt as String,
      gambarThumbnail: json['gambar_thumbnail'] as String?,
      tanggalPublish: json['tanggal_publish'] as String,
      url: json['url'] as String,
    );
  }
}
