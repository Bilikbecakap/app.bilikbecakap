import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class DetailKataPage extends StatelessWidget {
  const DetailKataPage({super.key, required this.kata});

  final Map<String, String> kata;

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
        title: Text('Detail Kata', style: AppTextStyles.subtitle),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildKataHeader(),
            const SizedBox(height: 24),
            _buildSection('Definisi', kata['arti'] ?? ''),
            const SizedBox(height: 20),
            _buildSection('Contoh Kalimat', kata['contoh'] ?? ''),
            const SizedBox(height: 24),
            _buildAudioButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildKataHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          kata['kata'] ?? '',
          style: AppTextStyles.title.copyWith(fontSize: 32),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            kata['kategori'] ?? '',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String judul, String isi) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          judul,
          style: AppTextStyles.body.copyWith(
            color: AppColors.navy,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.borderColor.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(isi, style: AppTextStyles.body),
        ),
      ],
    );
  }

  Widget _buildAudioButton() {
    return Row(
      children: [
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.volume_up_outlined, color: AppColors.primary),
          label: Text(
            'Dengarkan Pelafalan',
            style: AppTextStyles.body.copyWith(color: AppColors.primary),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.primary),
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
        ),
      ],
    );
  }
}
