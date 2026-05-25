import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/bilik_card.dart';
import '../widgets/berita_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const _fitur = [
    {
      'label': 'Kamus',
      'deskripsi': 'Cari kata Melayu Belitung',
      'icon': Icons.menu_book,
      'route': '/kamus',
    },
    {
      'label': 'Penerjemah',
      'deskripsi': 'Terjemahkan bahasa Melayu',
      'icon': Icons.swap_horiz,
      'route': '/penerjemah',
    },
    {
      'label': 'Pembelajaran',
      'deskripsi': 'Belajar lewat modul',
      'icon': Icons.school,
      'route': '/pembelajaran',
    },
    {
      'label': 'Kuis',
      'deskripsi': 'Uji kemampuanmu',
      'icon': Icons.quiz,
      'route': '/kuis',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildHeroBanner(),
              const SizedBox(height: 24),
              _buildFeatureGrid(context),
              const SizedBox(height: 24),
              const BeritaSection(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          Image.asset(
            'assets/images/logo-bilikbecakap.png',
            height: 32,
            fit: BoxFit.contain,
          ),
          const Spacer(),
          Icon(Icons.notifications_outlined, color: AppColors.textSecondary, size: 24),
        ],
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFB8E4E3), Color(0xFFD8F2F1), Color(0xFFF0FAFA)],
            stops: [0.0, 0.5, 1.0],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            // Lingkaran dekoratif
            Positioned(
              right: -16,
              top: -20,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
            Positioned(
              right: 30,
              bottom: -30,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
            ),
            // Konten
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lestarikan Bahasa\nMelayu Belitung!',
                    style: AppTextStyles.title.copyWith(color: AppColors.navy),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pelajari kosa kata dan kuasai\nbudaya Belitung Timur.',
                    style: AppTextStyles.body.copyWith(color: AppColors.navy),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Fitur Utama', style: AppTextStyles.subtitle),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.25,
            children: _fitur.map((item) {
              return BilikCard(
                onTap: () => context.go(item['route'] as String),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        item['icon'] as IconData,
                        size: 24,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['label'] as String,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.navy,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item['deskripsi'] as String,
                      style: AppTextStyles.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

}
