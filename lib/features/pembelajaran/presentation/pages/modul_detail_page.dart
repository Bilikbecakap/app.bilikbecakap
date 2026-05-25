import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/bilik_button.dart';

class ModulDetailPage extends StatelessWidget {
  const ModulDetailPage({super.key, required this.modul});

  final Map<String, dynamic> modul;

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHero(),
            const SizedBox(height: 24),
            _buildDeskripsi(),
            const SizedBox(height: 24),
            _buildMateriList(),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: BilikButton.primary(
                label: 'Mulai Kuis',
                onPressed: () => context.push(
                  '/kuis',
                  extra: modul['id'] as String,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            modul['ikon'] as IconData? ?? Icons.school,
            color: AppColors.white,
            size: 36,
          ),
          const SizedBox(height: 12),
          Text(
            modul['judul'] as String? ?? '',
            style: AppTextStyles.subtitle.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              modul['kesulitan'] as String? ?? '',
              style: AppTextStyles.caption.copyWith(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeskripsi() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tentang Modul',
          style: AppTextStyles.body.copyWith(
            color: AppColors.navy,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(modul['deskripsi'] as String? ?? '', style: AppTextStyles.body),
      ],
    );
  }

  Widget _buildMateriList() {
    const materi = [
      'Pengenalan kosa kata dasar',
      'Cara pengucapan yang benar',
      'Penggunaan dalam kalimat',
      'Latihan dan evaluasi',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Materi yang Dipelajari',
          style: AppTextStyles.body.copyWith(
            color: AppColors.navy,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...materi.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: AppColors.primary, size: 18),
                const SizedBox(width: 10),
                Text(item, style: AppTextStyles.body),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
