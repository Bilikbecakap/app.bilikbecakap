import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/services/profil_service.dart';
import '../../../../shared/widgets/bilik_button.dart';

class ProfilSetupPage extends StatefulWidget {
  const ProfilSetupPage({super.key});

  @override
  State<ProfilSetupPage> createState() => _ProfilSetupPageState();
}

class _ProfilSetupPageState extends State<ProfilSetupPage> {
  final _namaController = TextEditingController();
  final _kontakController = TextEditingController();
  String? _peranDipilih;
  bool _loading = false;

  static const _peranList = [
    {'label': 'Siswa', 'icon': Icons.school_outlined},
    {'label': 'Guru', 'icon': Icons.person_outline},
    {'label': 'Budayawan', 'icon': Icons.auto_stories_outlined},
    {'label': 'Lainnya', 'icon': Icons.more_horiz},
  ];

  @override
  void dispose() {
    _namaController.dispose();
    _kontakController.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    final nama = _namaController.text.trim();
    if (nama.isEmpty || _peranDipilih == null) return;

    setState(() => _loading = true);
    await ProfilService.simpan(
      nama: nama,
      peran: _peranDipilih!,
      kontak: _kontakController.text.trim(),
    );
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/logo-bilikbecakap.png',
                  height: 56,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 32),
              Text('Halo! Kenalan dulu, yuk 👋', style: AppTextStyles.title),
              const SizedBox(height: 6),
              Text(
                'Data ini akan digunakan untuk pengalaman belajarmu.',
                style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 28),
              Text('Nama lengkap', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600, color: AppColors.navy)),
              const SizedBox(height: 6),
              TextField(
                controller: _namaController,
                textCapitalization: TextCapitalization.words,
                decoration: _inputDecoration('Masukkan nama kamu'),
              ),
              const SizedBox(height: 20),
              Text('Kamu adalah?', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600, color: AppColors.navy)),
              const SizedBox(height: 10),
              _buildPelanSelector(),
              const SizedBox(height: 20),
              Text(
                'Nomor HP (opsional)',
                style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600, color: AppColors.navy),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _kontakController,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: _inputDecoration('Contoh: 081234567890'),
              ),
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                child: BilikButton.primary(
                  label: _loading ? 'Menyimpan...' : 'Mulai Belajar',
                  onPressed: (_namaController.text.trim().isNotEmpty && _peranDipilih != null && !_loading)
                      ? _simpan
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPelanSelector() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.8,
      children: _peranList.map((item) {
        final label = item['label'] as String;
        final icon = item['icon'] as IconData;
        final dipilih = _peranDipilih == label;
        return GestureDetector(
          onTap: () => setState(() => _peranDipilih = label),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: dipilih ? AppColors.primary.withValues(alpha: 0.1) : AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: dipilih ? AppColors.primary : AppColors.borderColor,
                width: dipilih ? 2 : 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: dipilih ? AppColors.primary : AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: AppTextStyles.body.copyWith(
                    color: dipilih ? AppColors.navy : AppColors.textSecondary,
                    fontWeight: dipilih ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondary.withValues(alpha: 0.6)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    );
  }
}
