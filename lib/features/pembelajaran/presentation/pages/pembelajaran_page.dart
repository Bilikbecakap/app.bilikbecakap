import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/bilik_card.dart';
import '../../data/models/modul_model.dart';
import '../../data/services/pembelajaran_service.dart';

class PembelajaranPage extends StatefulWidget {
  const PembelajaranPage({super.key});

  @override
  State<PembelajaranPage> createState() => _PembelajaranPageState();
}

class _PembelajaranPageState extends State<PembelajaranPage> {
  final List<ModulModel> _modulList = [];
  int _currentPage = 1;
  int _lastPage = 1;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _errorMsg;

  bool get _hasMore => _currentPage < _lastPage;

  @override
  void initState() {
    super.initState();
    _loadPage(1);
  }

  Future<void> _loadPage(int page) async {
    try {
      final result = await PembelajaranService().fetchDaftarModul(page: page);
      if (!mounted) return;
      setState(() {
        if (page == 1) {
          _modulList
            ..clear()
            ..addAll(result.data);
        } else {
          _modulList.addAll(result.data);
        }
        _currentPage = result.currentPage;
        _lastPage = result.lastPage;
        _isLoading = false;
        _isLoadingMore = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMsg = e.toString();
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Pembelajaran', style: AppTextStyles.subtitle),
        centerTitle: false,
      ),
      body: _isLoading
          ? _buildLoadingSkeleton()
          : _errorMsg != null
              ? _buildError()
              : _buildList(),
    );
  }

  Widget _buildLoadingSkeleton() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => Container(
        height: 260,
        decoration: BoxDecoration(
          color: AppColors.borderColor,
          borderRadius: BorderRadius.circular(12),
        ),
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
              onPressed: () {
                setState(() { _isLoading = true; _errorMsg = null; });
                _loadPage(1);
              },
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

  Widget _buildList() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      itemCount: _modulList.length + (_hasMore ? 1 : 0),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index == _modulList.length) return _buildMuatLebih();
        final modul = _modulList[index];
        return _ModulCard(
          modul: modul,
          onTap: () => context.push(
            '/pembelajaran/modul/${modul.slug}',
            extra: modul,
          ),
        );
      },
    );
  }

  Widget _buildMuatLebih() {
    if (_isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2.5,
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: OutlinedButton(
        onPressed: () {
          setState(() => _isLoadingMore = true);
          _loadPage(_currentPage + 1);
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          shape: const StadiumBorder(),
          minimumSize: const Size(double.infinity, 46),
        ),
        child: Text(
          'Muat Lebih Banyak',
          style: AppTextStyles.body.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _ModulCard extends StatelessWidget {
  const _ModulCard({required this.modul, required this.onTap});

  final ModulModel modul;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BilikCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ModulThumbnail(url: modul.thumbnailUrl),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  modul.title,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  modul.excerpt,
                  style: AppTextStyles.caption,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (modul.readingTime > 0) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.timer_outlined,
                        size: 13,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${modul.readingTime} mnt baca',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onTap,
                    icon: const Icon(Icons.menu_book_rounded, size: 16),
                    label: const Text('Pelajari Modul'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      textStyle: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
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
}

class _ModulThumbnail extends StatelessWidget {
  const _ModulThumbnail({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) return _placeholder();
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

  Widget _shimmer() => Container(
        width: double.infinity,
        height: 160,
        color: AppColors.borderColor,
      );

  Widget _placeholder() => Container(
        width: double.infinity,
        height: 160,
        decoration: const BoxDecoration(
          color: Color(0xFFEAF6F6),
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: const Center(
          child: Icon(Icons.school_outlined, size: 44, color: AppColors.primary),
        ),
      );
}
