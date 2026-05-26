import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/bilik_button.dart';
import '../../data/models/kuis_model.dart';
import '../../data/models/kuis_hasil_model.dart';

class KuisHasilPage extends StatelessWidget {
  const KuisHasilPage({
    super.key,
    required this.hasil,
    required this.kuis,
    required this.nama,
    required this.isPending,
  });

  final KuisHasilResponse? hasil;
  final KuisModel kuis;
  final String nama;
  final bool isPending;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Hasil Kuis', style: AppTextStyles.subtitle),
        centerTitle: true,
      ),
      body: isPending ? _buildPending(context) : _buildHasil(context),
    );
  }

  Widget _buildPending(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_upload_outlined, size: 72, color: AppColors.primary),
            const SizedBox(height: 16),
            Text('Jawaban Tersimpan!', style: AppTextStyles.title),
            const SizedBox(height: 8),
            Text(
              'Skor kamu akan tampil setelah jawaban berhasil dikirim ke server saat kamu online kembali.',
              style: AppTextStyles.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: BilikButton.primary(
                label: 'Kembali ke Daftar Kuis',
                onPressed: () => context.go('/kuis'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHasil(BuildContext context) {
    final h = hasil!;
    final lulus = h.score >= 70;
    final persentase = h.score.round();

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSkorHeader(h, lulus, persentase, nama),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                Text(
                  'Review Jawaban',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${h.correctAnswers}/${h.totalQuestions} benar',
                    style: AppTextStyles.caption.copyWith(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ...h.review.asMap().entries.map(
            (e) => Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: _buildReviewItem(e.key, e.value),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: BilikButton.primary(
                    label: 'Ulangi Kuis',
                    onPressed: () => context.pushReplacement('/kuis/main', extra: kuis),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: BilikButton.secondary(
                    label: 'Kembali ke Daftar Kuis',
                    onPressed: () => context.go('/kuis'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkorHeader(
    KuisHasilResponse h,
    bool lulus,
    int persentase,
    String nama,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: lulus
              ? [AppColors.primary.withValues(alpha: 0.1), AppColors.background]
              : [AppColors.error.withValues(alpha: 0.06), AppColors.background],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          Icon(
            lulus ? Icons.emoji_events : Icons.refresh,
            size: 72,
            color: lulus ? AppColors.gold : AppColors.textSecondary,
          ),
          const SizedBox(height: 12),
          Text(
            lulus ? 'Selamat, $nama!' : 'Coba Lagi, $nama!',
            style: AppTextStyles.title,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            '$persentase%',
            style: AppTextStyles.title.copyWith(
              fontSize: 48,
              color: lulus ? AppColors.primary : AppColors.error,
            ),
          ),
          Text(
            '${h.correctAnswers} dari ${h.totalQuestions} soal benar',
            style: AppTextStyles.body,
          ),
          const SizedBox(height: 8),
          Text(
            lulus
                ? 'Kamu berhasil melewati kuis ini dengan baik!'
                : 'Pelajari lagi materi dan coba kembali.',
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(int index, KuisReviewSoalModel soal) {
    final selected = _findOption(soal.options, soal.selectedOptionId);
    final correct = _findCorrectOption(soal.options);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: soal.isCorrect
            ? AppColors.success.withValues(alpha: 0.08)
            : AppColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: soal.isCorrect
              ? AppColors.success.withValues(alpha: 0.4)
              : AppColors.error.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 22,
                height: 22,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  color: soal.isCorrect ? AppColors.success : AppColors.error,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  soal.isCorrect ? Icons.check : Icons.close,
                  color: Colors.white,
                  size: 13,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DefaultTextStyle(
                  style: AppTextStyles.caption.copyWith(color: AppColors.navy),
                  child: HtmlWidget(soal.question),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _reviewPilihan(
            label: 'Jawaban kamu',
            teks: selected?.optionText ?? 'Tidak dijawab',
            color: soal.isCorrect ? AppColors.success : AppColors.error,
          ),
          if (!soal.isCorrect && correct != null)
            _reviewPilihan(
              label: 'Jawaban benar',
              teks: correct.optionText,
              color: AppColors.success,
            ),
        ],
      ),
    );
  }

  Widget _reviewPilihan({
    required String label,
    required String teks,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: RichText(
        text: TextSpan(
          style: AppTextStyles.caption,
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            TextSpan(
              text: teks,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  KuisReviewOptionModel? _findOption(
    List<KuisReviewOptionModel> options,
    int? id,
  ) {
    if (id == null) return null;
    try {
      return options.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  KuisReviewOptionModel? _findCorrectOption(
    List<KuisReviewOptionModel> options,
  ) {
    try {
      return options.firstWhere((o) => o.isCorrect);
    } catch (_) {
      return null;
    }
  }
}
