import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/services/profil_service.dart';
import '../../../../shared/widgets/bilik_button.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  late final TextEditingController _namaController;
  late final TextEditingController _kontakController;
  late String? _peranDipilih;
  bool _loading = false;

  static const _peranList = [
    {'label': 'Siswa', 'icon': Icons.school_outlined},
    {'label': 'Guru', 'icon': Icons.person_outline},
    {'label': 'Budayawan', 'icon': Icons.auto_stories_outlined},
    {'label': 'Lainnya', 'icon': Icons.more_horiz},
  ];

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: ProfilService.getNama() ?? '');
    _kontakController = TextEditingController(text: ProfilService.getKontak() ?? '');
    _peranDipilih = ProfilService.getPeran();
  }

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
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil disimpan')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Profil Saya', style: AppTextStyles.subtitle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/logo-bilikbecakap.png',
                  height: 48,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 24),
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
            _buildPeranSelector(),
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
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: BilikButton.primary(
                label: _loading ? 'Menyimpan...' : 'Simpan Perubahan',
                onPressed: (_namaController.text.trim().isNotEmpty && _peranDipilih != null && !_loading)
                    ? _simpan
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeranSelector() {
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
