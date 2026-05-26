import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/bilik_card.dart';
import '../../data/models/artikel_model.dart';
import '../../data/services/artikel_service.dart';

class BeritaSection extends StatefulWidget {
  const BeritaSection({super.key});

  @override
  State<BeritaSection> createState() => _BeritaSectionState();
}

class _BeritaSectionState extends State<BeritaSection> {
  late Future<List<ArtikelModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = ArtikelService().fetchTerbaru();
  }

  String _formatTanggal(String iso) {
    try {
      final dt = DateTime.parse(iso);
      const bulan = [
        '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
        'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
      ];
      return '${dt.day} ${bulan[dt.month]} ${dt.year}';
    } catch (_) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Berita dan Artikel', style: AppTextStyles.subtitle),
          const SizedBox(height: 12),
          FutureBuilder<List<ArtikelModel>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const _LoadingPlaceholder();
              }
              if (snapshot.hasError) {
                return _ErrorView(
                  onRetry: () => setState(() {
                    _future = ArtikelService().fetchTerbaru();
                  }),
                );
              }
              final artikels = snapshot.data ?? [];
              return Column(
                children: artikels
                    .map((a) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _ArtikelCard(
                            artikel: a,
                            tanggal: _formatTanggal(a.tanggalPublish),
                          ),
                        ))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ArtikelCard extends StatelessWidget {
  const _ArtikelCard({required this.artikel, required this.tanggal});

  final ArtikelModel artikel;
  final String tanggal;

  @override
  Widget build(BuildContext context) {
    return BilikCard(
      padding: EdgeInsets.zero,
      onTap: () => context.push(
        '/artikel/${artikel.slug}',
        extra: artikel.judul,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Thumbnail(url: artikel.gambarThumbnail),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  artikel.judul,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(tanggal, style: AppTextStyles.caption),
                const SizedBox(height: 6),
                Text(
                  artikel.excerpt,
                  style: AppTextStyles.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return _placeholder();
    }
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: Image.network(
        url!,
        width: double.infinity,
        height: 160,
        fit: BoxFit.cover,
        loadingBuilder: (_, child, progress) =>
            progress == null ? child : _shimmer(),
        errorBuilder: (_, __, ___) => _placeholder(),
      ),
    );
  }

  Widget _shimmer() {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        color: AppColors.borderColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: const Center(
        child: Icon(Icons.image_outlined, size: 44, color: AppColors.primary),
      ),
    );
  }
}

class _LoadingPlaceholder extends StatelessWidget {
  const _LoadingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        3,
        (_) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            height: 220,
            decoration: BoxDecoration(
              color: AppColors.borderColor,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.borderColor.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off_rounded, size: 36, color: AppColors.textSecondary),
          const SizedBox(height: 10),
          Text(
            'Tidak ada koneksi internet',
            style: AppTextStyles.body.copyWith(color: AppColors.navy, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Periksa koneksi dan coba lagi.',
            style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          TextButton(
            onPressed: onRetry,
            child: Text('Coba Lagi', style: AppTextStyles.body.copyWith(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
