import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/bilik_button.dart';

class KuisPage extends StatefulWidget {
  const KuisPage({super.key});

  @override
  State<KuisPage> createState() => _KuisPageState();
}

class _KuisPageState extends State<KuisPage> {
  static const List<Map<String, dynamic>> _soalList = [
    {
      'soal': 'Apa arti kata "Bedegap" dalam Bahasa Melayu Belitung?',
      'pilihan': ['Keras/kasar dalam berbicara', 'Lemah lembut', 'Baik hati', 'Pemalu'],
      'jawaban': 0,
    },
    {
      'soal': 'Alat musik tiup tradisional Belitung disebut?',
      'pilihan': ['Gamelan', 'Serunai', 'Rebana', 'Angklung'],
      'jawaban': 1,
    },
    {
      'soal': 'Kata "Betiong" dalam Bahasa Melayu Belitung berarti?',
      'pilihan': ['Sungai besar', 'Batu karang', 'Pohon bambu besar', 'Ikan laut'],
      'jawaban': 2,
    },
    {
      'soal': '"Kepok" adalah tempat penyimpanan apa dalam tradisi Belitung?',
      'pilihan': ['Ikan', 'Pakaian', 'Air', 'Padi'],
      'jawaban': 3,
    },
    {
      'soal': 'Kata "Gelak" dalam Bahasa Melayu Belitung berarti?',
      'pilihan': ['Menangis', 'Tertawa', 'Berlari', 'Bermain'],
      'jawaban': 1,
    },
  ];

  int _soalIndex = 0;
  int? _pilihanDipilih;
  bool _selesai = false;
  int _skor = 0;

  void _pilih(int index) {
    setState(() => _pilihanDipilih = index);
  }

  void _selanjutnya() {
    if (_pilihanDipilih == null) return;
    final benar = _pilihanDipilih == _soalList[_soalIndex]['jawaban'];
    final skorBaru = _skor + (benar ? 1 : 0);

    if (_soalIndex < _soalList.length - 1) {
      setState(() {
        _skor = skorBaru;
        _soalIndex++;
        _pilihanDipilih = null;
      });
    } else {
      setState(() {
        _skor = skorBaru;
        _selesai = true;
      });
    }
  }

  void _ulang() {
    setState(() {
      _soalIndex = 0;
      _pilihanDipilih = null;
      _selesai = false;
      _skor = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Kuis', style: AppTextStyles.subtitle),
        centerTitle: false,
      ),
      body: _selesai ? _buildHasil() : _buildSoal(),
    );
  }

  Widget _buildSoal() {
    final soal = _soalList[_soalIndex];
    final pilihan = soal['pilihan'] as List<String>;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProgres(),
          const SizedBox(height: 24),
          Text(
            'Soal ${_soalIndex + 1} dari ${_soalList.length}',
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: 8),
          Text(soal['soal'] as String, style: AppTextStyles.subtitle),
          const SizedBox(height: 24),
          ...pilihan.asMap().entries.map(
            (entry) => _buildPilihanTile(entry.key, entry.value),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: BilikButton.primary(
              label: _soalIndex == _soalList.length - 1 ? 'Selesai' : 'Selanjutnya',
              onPressed: _pilihanDipilih != null ? _selanjutnya : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgres() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LinearProgressIndicator(
        value: (_soalIndex + 1) / _soalList.length,
        backgroundColor: AppColors.borderColor,
        color: AppColors.primary,
        minHeight: 8,
      ),
    );
  }

  Widget _buildPilihanTile(int index, String teks) {
    final dipilih = _pilihanDipilih == index;
    return GestureDetector(
      onTap: () => _pilih(index),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: dipilih ? AppColors.primary.withValues(alpha: 0.1) : AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: dipilih ? AppColors.primary : AppColors.borderColor,
            width: dipilih ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dipilih ? AppColors.primary : AppColors.background,
                border: Border.all(
                  color: dipilih ? AppColors.primary : AppColors.borderColor,
                ),
              ),
              child: dipilih
                  ? const Icon(Icons.check, color: AppColors.white, size: 16)
                  : Center(
                      child: Text(
                        String.fromCharCode(65 + index),
                        style: AppTextStyles.caption,
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                teks,
                style: AppTextStyles.body.copyWith(
                  color: dipilih ? AppColors.navy : AppColors.textSecondary,
                  fontWeight: dipilih ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHasil() {
    final persentase = (_skor / _soalList.length * 100).round();
    final lulus = persentase >= 60;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              lulus ? Icons.emoji_events : Icons.refresh,
              size: 80,
              color: lulus ? AppColors.gold : AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              lulus ? 'Selamat!' : 'Coba Lagi',
              style: AppTextStyles.title,
            ),
            const SizedBox(height: 8),
            Text(
              'Skor kamu: $_skor / ${_soalList.length} ($persentase%)',
              style: AppTextStyles.subtitle.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            Text(
              lulus
                  ? 'Kamu berhasil menyelesaikan kuis ini dengan baik!'
                  : 'Pelajari lagi materi dan coba kembali.',
              style: AppTextStyles.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: BilikButton.primary(
                label: 'Ulangi Kuis',
                onPressed: _ulang,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
