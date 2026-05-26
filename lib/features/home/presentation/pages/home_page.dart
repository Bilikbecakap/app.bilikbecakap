import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/services/profil_service.dart';
import '../../../../shared/widgets/bilik_card.dart';
import '../widgets/berita_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;

  static const _banners = [
    'assets/images/banner-1.png',
    'assets/images/banner-2.png',
    'assets/images/banner-3.png',
  ];

  static const _fitur = [
    {'label': 'Kamus', 'deskripsi': 'Cari kata bahasa Melayu Belitung', 'icon': Icons.menu_book, 'route': '/kamus'},
    {'label': 'Penerjemah', 'deskripsi': 'Terjemahkan ke bahasa Melayu', 'icon': Icons.swap_horiz, 'route': '/penerjemah'},
    {'label': 'Pembelajaran', 'deskripsi': 'Belajar budaya lewat modul', 'icon': Icons.school, 'route': '/pembelajaran'},
    {'label': 'Kuis', 'deskripsi': 'Uji kemampuan bahasa Melayumu', 'icon': Icons.quiz, 'route': '/kuis'},
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      final next = (_currentPage + 1) % _banners.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 16),
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

  Widget _buildHeader(BuildContext context) {
    final nama = ProfilService.getNama() ?? '';
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 14, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, $nama!',
                  style: AppTextStyles.subtitle.copyWith(color: AppColors.navy),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Selamat belajar hari ini',
                  style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: const Icon(Icons.notifications_outlined, color: AppColors.textSecondary, size: 22),
          ),
          const SizedBox(width: 14),
          GestureDetector(
            onTap: () => context.push('/profil'),
            child: const Icon(Icons.account_circle_outlined, color: AppColors.textSecondary, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 2.5,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _banners.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (_, i) => ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(_banners[i], fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _banners.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _currentPage == i ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _currentPage == i ? AppColors.primary : AppColors.borderColor,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
        ],
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
            childAspectRatio: 1.4,
            children: _fitur.map((item) {
              return BilikCard(
                padding: const EdgeInsets.all(12),
                onTap: () => context.go(item['route'] as String),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Icon(item['icon'] as IconData, size: 20, color: AppColors.primary),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item['label'] as String,
                      style: AppTextStyles.body.copyWith(color: AppColors.navy, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item['deskripsi'] as String,
                      style: AppTextStyles.caption,
                      maxLines: 2,
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
