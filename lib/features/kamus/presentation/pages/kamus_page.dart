import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/bilik_card.dart';

class KamusPage extends StatelessWidget {
  const KamusPage({super.key});

  static const List<Map<String, String>> _kataList = [
    {
      'id': '1',
      'kata': 'Bedegap',
      'kategori': 'Kata Sifat',
      'arti': 'Keras atau kasar dalam berbicara',
      'contoh': 'Jangan bedegap kalau ngomong sama orang tua!',
    },
    {
      'id': '2',
      'kata': 'Betiong',
      'kategori': 'Kata Benda',
      'arti': 'Pohon bambu besar',
      'contoh': 'Di belakang rumah banyak betiong tumbuh subur.',
    },
    {
      'id': '3',
      'kata': 'Gelak',
      'kategori': 'Kata Kerja',
      'arti': 'Tertawa dengan gembira',
      'contoh': 'Anak-anak gelak melihat pertunjukan wayang itu.',
    },
    {
      'id': '4',
      'kata': 'Kepok',
      'kategori': 'Kata Benda',
      'arti': 'Tempat penyimpanan padi tradisional',
      'contoh': 'Kepok nenek masih terisi penuh setelah musim panen.',
    },
    {
      'id': '5',
      'kata': 'Lenggang',
      'kategori': 'Kata Sifat',
      'arti': 'Bergerak dengan lemah lembut dan anggun',
      'contoh': 'Putri berjalan lenggang di hadapan para tamu.',
    },
    {
      'id': '6',
      'kata': 'Serunai',
      'kategori': 'Kata Benda',
      'arti': 'Alat musik tiup tradisional Belitung',
      'contoh': 'Bunyi serunai terdengar merdu di malam kenduri.',
    },
    {
      'id': '7',
      'kata': 'Ngengkang',
      'kategori': 'Kata Kerja',
      'arti': 'Berdiri atau duduk dengan kaki terbuka lebar',
      'contoh': 'Jangan ngengkang di depan orang yang lebih tua.',
    },
  ];

  static const List<String> _huruf = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
    'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T',
    'U', 'V', 'W', 'X', 'Y', 'Z',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Kamus', style: AppTextStyles.subtitle),
        centerTitle: false,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterChips(),
          Expanded(child: _buildKataList(context)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: TextField(
        readOnly: true,
        decoration: InputDecoration(
          hintText: 'Cari kata...',
          hintStyle: AppTextStyles.body,
          prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
          filled: true,
          fillColor: AppColors.background,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: const BorderSide(color: AppColors.borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: const BorderSide(color: AppColors.borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _huruf.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return FilterChip(
            label: Text(_huruf[index], style: AppTextStyles.caption),
            onSelected: (_) {},
            backgroundColor: AppColors.background,
            side: const BorderSide(color: AppColors.borderColor),
            shape: const StadiumBorder(),
            showCheckmark: false,
          );
        },
      ),
    );
  }

  Widget _buildKataList(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _kataList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final kata = _kataList[index];
        return BilikCard(
          onTap: () => context.push('/kamus/detail/${kata['id']}', extra: kata),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    kata['kata']![0],
                    style: AppTextStyles.subtitle.copyWith(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kata['kata']!,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.navy,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(kata['arti']!, style: AppTextStyles.caption),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  kata['kategori']!,
                  style: AppTextStyles.caption.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
