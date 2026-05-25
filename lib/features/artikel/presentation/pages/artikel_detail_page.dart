import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/artikel_detail_model.dart';
import '../../data/services/artikel_detail_service.dart';

class ArtikelDetailPage extends StatefulWidget {
  const ArtikelDetailPage({
    super.key,
    required this.slug,
    required this.judul,
  });

  final String slug;
  final String judul;

  @override
  State<ArtikelDetailPage> createState() => _ArtikelDetailPageState();
}

class _ArtikelDetailPageState extends State<ArtikelDetailPage> {
  final _service = ArtikelDetailService();
  late Future<ArtikelDetailModel> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.getDetail(widget.slug);
  }

  String _formatTanggal(String iso) {
    try {
      final dt = DateTime.parse(iso);
      const bulan = [
        '',
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember',
      ];
      return '${dt.day} ${bulan[dt.month]} ${dt.year}';
    } catch (_) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 1,
        title: Text(
          widget.judul,
          style: AppTextStyles.body.copyWith(
            color: AppColors.navy,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: AppColors.navy,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<ArtikelDetailModel>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoading();
          }
          if (snapshot.hasError) {
            return _buildError();
          }
          return _buildContent(snapshot.data!);
        },
      ),
    );
  }

  Widget _buildContent(ArtikelDetailModel artikel) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (artikel.gambarThumbnail != null &&
              artikel.gambarThumbnail!.isNotEmpty)
            _buildHeroImage(artikel.gambarThumbnail!),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              artikel.judul,
              style: AppTextStyles.subtitle.copyWith(
                color: AppColors.navy,
                height: 1.4,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 12,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 5),
                Text(
                  _formatTanggal(artikel.tanggalPublish),
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.borderColor, height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: HtmlWidget(
              artikel.kontenId,
              baseUrl: Uri.parse('https://bilikbecakap.com'),
              textStyle: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Color(0xFF374151),
                height: 1.75,
              ),
              customStylesBuilder: (element) {
                switch (element.localName) {
                  case 'h1':
                    return {
                      'color': '#002B44',
                      'font-size': '20px',
                      'font-weight': '700',
                      'font-family': 'Poppins',
                    };
                  case 'h2':
                    return {
                      'color': '#002B44',
                      'font-size': '17px',
                      'font-weight': '600',
                      'font-family': 'Poppins',
                    };
                  case 'h3':
                    return {
                      'color': '#002B44',
                      'font-size': '15px',
                      'font-weight': '600',
                      'font-family': 'Poppins',
                    };
                  case 'strong':
                    return {'color': '#002B44', 'font-weight': '600'};
                  case 'a':
                    return {'color': '#54B0AF', 'text-decoration': 'none'};
                  case 'blockquote':
                    return {
                      'color': '#6B7280',
                      'font-style': 'italic',
                      'border-left': '3px solid #54B0AF',
                      'padding-left': '12px',
                    };
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeroImage(String url) {
    return Image.network(
      url,
      width: double.infinity,
      height: 220,
      fit: BoxFit.cover,
      loadingBuilder: (_, child, progress) => progress == null
          ? child
          : Container(
              width: double.infinity,
              height: 220,
              color: AppColors.borderColor,
            ),
      errorBuilder: (_, __, ___) => Container(
        width: double.infinity,
        height: 140,
        color: AppColors.primary.withValues(alpha: 0.08),
        child: const Center(
          child: Icon(
            Icons.image_outlined,
            size: 48,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: double.infinity, height: 220, color: AppColors.borderColor),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(double.infinity, 22),
                const SizedBox(height: 8),
                _shimmerBox(240, 22),
                const SizedBox(height: 12),
                _shimmerBox(100, 14),
                const SizedBox(height: 24),
                ...List.generate(
                  7,
                  (i) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _shimmerBox(
                      i % 3 == 2 ? 200 : double.infinity,
                      14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmerBox(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.borderColor,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 52,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ada koneksi internet',
              style: AppTextStyles.subtitle.copyWith(color: AppColors.navy),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'Periksa koneksi dan coba lagi.',
              style: AppTextStyles.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => setState(
                () => _future = _service.getDetail(widget.slug),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: const StadiumBorder(),
              ),
              child: Text('Coba Lagi', style: AppTextStyles.button),
            ),
          ],
        ),
      ),
    );
  }
}
