import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/services/profil_service.dart';
import '../../data/models/kuis_model.dart';
import '../../data/services/kuis_service.dart';
import '../../data/services/kuis_hasil_service.dart';

class KuisPage extends StatefulWidget {
  const KuisPage({super.key});

  @override
  State<KuisPage> createState() => _KuisPageState();
}

class _KuisPageState extends State<KuisPage> {
  final _service = KuisService();
  late Future<List<KuisModel>> _futureKuis;

  @override
  void initState() {
    super.initState();
    _futureKuis = _service.fetchDaftarKuis();
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncPending());
  }

  Future<void> _syncPending() async {
    if (KuisHasilService.hasPending()) {
      await KuisHasilService.syncPending(_service);
    }
  }

  @override
  Widget build(BuildContext context) {
    final nama = ProfilService.getNama();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kuis', style: AppTextStyles.subtitle),
            if (nama != null)
              Text(
                'Halo, $nama!',
                style: AppTextStyles.caption.copyWith(color: AppColors.primary),
              ),
          ],
        ),
      ),
      body: FutureBuilder<List<KuisModel>>(
        future: _futureKuis,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wifi_off, size: 48, color: AppColors.textSecondary),
                  const SizedBox(height: 12),
                  Text('Gagal memuat kuis', style: AppTextStyles.body),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => setState(() {
                      _futureKuis = _service.fetchDaftarKuis();
                    }),
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            );
          }
          final list = snapshot.data ?? [];
          if (list.isEmpty) {
            return Center(
              child: Text('Belum ada kuis tersedia', style: AppTextStyles.body),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (context, i) => _buildKuisCard(list[i]),
          );
        },
      ),
    );
  }

  Widget _buildKuisCard(KuisModel kuis) {
    return GestureDetector(
      onTap: () => context.push('/kuis/main', extra: kuis),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: kuis.thumbnailUrl != null
                  ? Image.network(
                      kuis.thumbnailUrl!,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder(),
                    )
                  : _placeholder(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kuis.title,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.navy,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _badgeInfo(Icons.quiz_outlined, '${kuis.totalQuestions} soal'),
                        const SizedBox(width: 8),
                        _badgeInfo(Icons.timer_outlined, '${kuis.duration} mnt'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 90,
      height: 90,
      color: AppColors.primary.withValues(alpha: 0.1),
      child: const Icon(Icons.quiz, color: AppColors.primary, size: 32),
    );
  }

  Widget _badgeInfo(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColors.textSecondary),
        const SizedBox(width: 3),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}
