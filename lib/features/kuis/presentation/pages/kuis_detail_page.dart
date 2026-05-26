import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/bilik_button.dart';
import '../../data/models/kuis_model.dart';
import '../../data/models/kuis_soal_model.dart';
import '../../../../core/services/profil_service.dart';
import '../../data/services/kuis_service.dart';
import '../../data/services/kuis_hasil_service.dart';

class KuisDetailPage extends StatefulWidget {
  const KuisDetailPage({super.key, required this.kuis});
  final KuisModel kuis;

  @override
  State<KuisDetailPage> createState() => _KuisDetailPageState();
}

class _KuisDetailPageState extends State<KuisDetailPage> {
  final _service = KuisService();

  KuisMulaiResponse? _sesi;
  bool _loading = true;
  int _soalIndex = 0;
  int? _pilihanId;
  final Map<int, int> _jawaban = {};
  Timer? _timer;
  int _sisaDetik = 0;

  @override
  void initState() {
    super.initState();
    _mulaiKuis();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _mulaiKuis() async {
    final nama = ProfilService.getNama() ?? 'Anonim';
    try {
      final sesi = await _service.mulaiKuis(widget.kuis.slug, nama);
      _sisaDetik = sesi.duration * 60;
      _mulaiTimer();
      if (mounted) setState(() { _sesi = sesi; _loading = false; });
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perlu koneksi internet untuk memulai kuis')),
        );
        context.pop();
      }
    }
  }

  void _mulaiTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_sisaDetik <= 0) {
        _timer?.cancel();
        _submitKuis(timerHabis: true);
      } else {
        if (mounted) setState(() => _sisaDetik--);
      }
    });
  }

  void _pilih(int optionId) {
    setState(() => _pilihanId = optionId);
  }

  void _selanjutnya() {
    if (_pilihanId == null) return;
    final soal = _sesi!.soal;
    _jawaban[soal[_soalIndex].id] = _pilihanId!;

    if (_soalIndex < soal.length - 1) {
      setState(() {
        _soalIndex++;
        _pilihanId = _jawaban[soal[_soalIndex].id];
      });
    } else {
      _submitKuis();
    }
  }

  void _kembali() {
    if (_soalIndex == 0) return;
    final soal = _sesi!.soal;
    setState(() {
      _soalIndex--;
      _pilihanId = _jawaban[soal[_soalIndex].id];
    });
  }

  Future<void> _submitKuis({bool timerHabis = false}) async {
    _timer?.cancel();

    final nama = ProfilService.getNama() ?? 'Anonim';
    final answers = _jawaban.entries
        .map((e) => {'question_id': e.key, 'option_id': e.value})
        .toList();

    try {
      final hasil = await _service.submitKuis(
        widget.kuis.slug,
        attemptId: _sesi!.attemptId,
        answers: answers,
      );
      if (mounted) {
        context.pushReplacement('/kuis/hasil', extra: {
          'hasil': hasil,
          'kuis': widget.kuis,
          'nama': nama,
          'isPending': false,
        });
      }
    } catch (_) {
      await KuisHasilService.simpanPending(
        slug: widget.kuis.slug,
        kuisTitle: widget.kuis.title,
        attemptId: _sesi!.attemptId,
        answers: answers,
      );
      if (mounted) {
        context.pushReplacement('/kuis/hasil', extra: {
          'hasil': null,
          'kuis': widget.kuis,
          'nama': nama,
          'isPending': true,
        });
      }
    }
  }

  String get _timerTeks {
    final m = _sisaDetik ~/ 60;
    final s = _sisaDetik % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  Color get _timerColor =>
      _sisaDetik < 60 ? AppColors.error : AppColors.navy;

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: AppColors.primary),
              const SizedBox(height: 16),
              Text('Memuat soal...', style: AppTextStyles.body),
            ],
          ),
        ),
      );
    }

    final soal = _sesi!.soal[_soalIndex];
    final total = _sesi!.soal.length;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _showDialogKeluar();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _showDialogKeluar,
          ),
          title: Text(
            widget.kuis.title,
            style: AppTextStyles.caption.copyWith(color: AppColors.navy),
            overflow: TextOverflow.ellipsis,
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            _buildHeader(total),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HtmlWidget(soal.question),
                    const SizedBox(height: 20),
                    ...soal.options.map((opt) => _buildPilihanTile(opt)),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            _buildFooter(total),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(int total) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Soal ${_soalIndex + 1} / $total', style: AppTextStyles.caption),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _timerColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: _timerColor.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.timer_outlined, size: 14, color: _timerColor),
                    const SizedBox(width: 4),
                    Text(
                      _timerTeks,
                      style: AppTextStyles.caption.copyWith(
                        color: _timerColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: (_soalIndex + 1) / total,
              backgroundColor: AppColors.borderColor,
              color: AppColors.primary,
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPilihanTile(KuisOptionModel opt) {
    final dipilih = _pilihanId == opt.id;
    return GestureDetector(
      onTap: () => _pilih(opt.id),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: dipilih
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: dipilih ? AppColors.primary : AppColors.borderColor,
            width: dipilih ? 2 : 1,
          ),
        ),
        child: Text(
          opt.optionText,
          style: AppTextStyles.body.copyWith(
            color: dipilih ? AppColors.navy : AppColors.textSecondary,
            fontWeight: dipilih ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(int total) {
    final isFirst = _soalIndex == 0;
    final isLast = _soalIndex == total - 1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Row(
        children: [
          if (!isFirst) ...[
            Expanded(
              child: BilikButton.secondary(
                label: 'Kembali',
                onPressed: _kembali,
              ),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: BilikButton.primary(
              label: isLast ? 'Selesai' : 'Selanjutnya',
              onPressed: _pilihanId != null ? _selanjutnya : null,
            ),
          ),
        ],
      ),
    );
  }

  void _showDialogKeluar() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Keluar Kuis?', style: AppTextStyles.subtitle),
        content: Text('Progres kuis ini akan hilang.', style: AppTextStyles.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              _timer?.cancel();
              if (ctx.mounted) Navigator.pop(ctx);
              if (mounted) context.pop();
            },
            child: const Text('Keluar', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
