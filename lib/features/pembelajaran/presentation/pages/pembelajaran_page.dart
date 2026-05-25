import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/bilik_card.dart';

class PembelajaranPage extends StatelessWidget {
  const PembelajaranPage({super.key});

  static const List<Map<String, dynamic>> _modulList = [
    {
      'id': '1',
      'judul': 'Pengenalan Bahasa Melayu Belitung',
      'deskripsi': 'Pelajari dasar-dasar kosa kata bahasa Melayu khas Belitung Timur.',
      'kesulitan': 'Dasar',
      'progress': 0.0,
      'ikon': Icons.abc,
    },
    {
      'id': '2',
      'judul': 'Ungkapan Sehari-hari',
      'deskripsi': 'Frasa dan ungkapan yang sering digunakan dalam percakapan.',
      'kesulitan': 'Menengah',
      'progress': 0.0,
      'ikon': Icons.chat_bubble_outline,
    },
    {
      'id': '3',
      'judul': 'Peribahasa Belitung',
      'deskripsi': 'Memahami peribahasa dan maknanya dalam budaya Belitung.',
      'kesulitan': 'Lanjut',
      'progress': 0.0,
      'ikon': Icons.auto_stories,
    },
    {
      'id': '4',
      'judul': 'Adat dan Tradisi',
      'deskripsi': 'Mengenal adat istiadat dan tradisi masyarakat Belitung Timur.',
      'kesulitan': 'Dasar',
      'progress': 0.0,
      'ikon': Icons.holiday_village,
    },
    {
      'id': '5',
      'judul': 'Lagu dan Sastra',
      'deskripsi': 'Eksplorasi lagu tradisional dan sastra lisan Belitung.',
      'kesulitan': 'Menengah',
      'progress': 0.0,
      'ikon': Icons.music_note,
    },
  ];

  Color _badgeColor(String kesulitan) {
    switch (kesulitan) {
      case 'Dasar':
        return AppColors.success;
      case 'Menengah':
        return AppColors.gold;
      case 'Lanjut':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
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
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _modulList.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final modul = _modulList[index];
          return BilikCard(
            onTap: () => context.push(
              '/pembelajaran/modul/${modul['id']}',
              extra: modul,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        modul['ikon'] as IconData,
                        color: AppColors.primary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            modul['judul'] as String,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.navy,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _badgeColor(modul['kesulitan'] as String)
                                  .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              modul['kesulitan'] as String,
                              style: AppTextStyles.caption.copyWith(
                                color: _badgeColor(modul['kesulitan'] as String),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(modul['deskripsi'] as String, style: AppTextStyles.caption),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: modul['progress'] as double,
                    backgroundColor: AppColors.borderColor,
                    color: AppColors.primary,
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 4),
                Text('Belum dimulai', style: AppTextStyles.caption),
              ],
            ),
          );
        },
      ),
    );
  }
}
