import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/modul_model.dart';
import '../../data/models/modul_detail_model.dart';
import '../../data/services/pembelajaran_service.dart';

class ModulDetailPage extends StatefulWidget {
  const ModulDetailPage({super.key, required this.modul});

  final ModulModel modul;

  @override
  State<ModulDetailPage> createState() => _ModulDetailPageState();
}

class _ModulDetailPageState extends State<ModulDetailPage> {
  ModulDetailModel? _detail;
  YoutubePlayerController? _videoController;
  bool _isLoading = true;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<bool> _checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> _fetchDetail() async {
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });
    try {
      final detail =
          await PembelajaranService().fetchDetailModul(widget.modul.slug);

      YoutubePlayerController? newController;
      if (detail.videoEmbedId != null && detail.videoEmbedId!.isNotEmpty) {
        final isOnline = await _checkInternet();
        if (isOnline) {
          newController = YoutubePlayerController(
            initialVideoId: detail.videoEmbedId!,
            flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
          );
        }
      }

      if (!mounted) return;
      _videoController?.dispose();
      setState(() {
        _detail = detail;
        _videoController = newController;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMsg = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Scaffold _buildScaffold({Widget? player}) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.navy),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Detail Modul', style: AppTextStyles.subtitle),
        centerTitle: false,
      ),
      body: _isLoading
          ? _buildLoading()
          : _errorMsg != null
              ? _buildError()
              : _buildContent(player),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_videoController != null) {
      return YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _videoController!,
          showVideoProgressIndicator: true,
          progressIndicatorColor: AppColors.primary,
          progressColors: const ProgressBarColors(
            playedColor: AppColors.primary,
            handleColor: AppColors.primaryDark,
          ),
        ),
        builder: (context, player) => _buildScaffold(player: player),
      );
    }
    return _buildScaffold();
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          const SizedBox(height: 16),
          Text(
            widget.modul.title,
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
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
            const Icon(Icons.wifi_off_rounded, size: 48, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(
              'Tidak ada koneksi internet',
              style: AppTextStyles.body.copyWith(
                color: AppColors.navy,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text('Periksa koneksi dan coba lagi.', style: AppTextStyles.caption),
            const SizedBox(height: 20),
            TextButton(
              onPressed: _fetchDetail,
              child: Text(
                'Coba Lagi',
                style: AppTextStyles.body.copyWith(color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnailWidget(String? url) {
    if (url == null || url.isEmpty) {
      return Container(
        width: double.infinity,
        height: 220,
        color: const Color(0xFFEAF6F6),
        child: const Center(
          child: Icon(Icons.school_outlined, size: 56, color: AppColors.primary),
        ),
      );
    }
    return Image.network(
      url,
      width: double.infinity,
      height: 220,
      fit: BoxFit.cover,
      loadingBuilder: (_, child, progress) => progress == null
          ? child
          : Container(width: double.infinity, height: 220, color: AppColors.borderColor),
      errorBuilder: (_, __, ___) => Container(
        width: double.infinity,
        height: 220,
        color: const Color(0xFFEAF6F6),
        child: const Center(
          child: Icon(Icons.school_outlined, size: 56, color: AppColors.primary),
        ),
      ),
    );
  }

  Widget _buildContent(Widget? player) {
    final detail = _detail!;
    final hasVideo = detail.videoEmbedId != null && detail.videoEmbedId!.isNotEmpty;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildThumbnailWidget(detail.thumbnailUrl),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(detail.title, style: AppTextStyles.subtitle),
                if (detail.content.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _buildSectionHeader('Tentang Modul'),
                  HtmlWidget(
                    detail.content,
                    textStyle: AppTextStyles.body,
                  ),
                ],
                if (hasVideo) ...[
                  const SizedBox(height: 24),
                  _buildSectionHeader('Video Pembelajaran'),
                  if (player != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: player,
                    )
                  else
                    _buildVideoOffline(),
                ],
                if (detail.pdfUrl != null && detail.pdfUrl!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _buildInfoBox(),
                  const SizedBox(height: 12),
                  _buildSectionHeader('Modul PDF'),
                  _buildPdfCard(detail),
                ],
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoOffline() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.borderColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.wifi_off_rounded,
            size: 40,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 12),
          Text(
            'Video tidak tersedia',
            style: AppTextStyles.body.copyWith(
              color: AppColors.navy,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Koneksi internet diperlukan untuk memutar video.',
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: AppTextStyles.body.copyWith(
          color: AppColors.navy,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: AppColors.gold, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Untuk pemahaman yang lebih mendalam, pelajari modul ini secara lengkap. '
              'Modul berisi materi, contoh, dan panduan yang disusun khusus untuk '
              'membantu kamu menguasai topik ini dengan lebih baik.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.navy,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPdfCard(ModulDetailModel detail) {
    return GestureDetector(
      onTap: () => context.push(
        '/pembelajaran/pdf',
        extra: {'url': detail.pdfUrl!, 'judul': detail.title},
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.picture_as_pdf_rounded,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    detail.title,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.navy,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Buka modul PDF',
                    style: AppTextStyles.caption.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
