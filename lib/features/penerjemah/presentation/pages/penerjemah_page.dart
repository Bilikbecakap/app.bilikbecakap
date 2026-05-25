import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/terjemahan_model.dart';
import '../../data/services/penerjemah_service.dart';

class PenerjemahPage extends StatefulWidget {
  const PenerjemahPage({super.key});

  @override
  State<PenerjemahPage> createState() => _PenerjemahPageState();
}

class _PenerjemahPageState extends State<PenerjemahPage> {
  final _inputController = TextEditingController();
  final _service = PenerjemahService();

  String _sourceLang = 'Indonesia';
  String _targetLang = 'Belitung';
  bool _isLoading = false;
  TerjemahanModel? _hasil;
  String? _errorMsg;

  static const _langs = ['Belitung', 'Indonesia', 'English'];
  static const _directionMap = {
    'Belitung|Indonesia': 'belitung_to_indonesia',
    'Indonesia|Belitung': 'indonesia_to_belitung',
    'Indonesia|English': 'indonesia_to_english',
    'English|Indonesia': 'english_to_indonesia',
    'Belitung|English': 'belitung_to_english',
    'English|Belitung': 'english_to_belitung',
  };

  String get _direction => _directionMap['$_sourceLang|$_targetLang']!;

  bool get _isNetworkError =>
      _errorMsg != null &&
      (_errorMsg!.contains('SocketException') ||
          _errorMsg!.contains('Failed host lookup') ||
          _errorMsg!.contains('TimeoutException') ||
          _errorMsg!.contains('Connection refused') ||
          _errorMsg!.contains('No address'));

  void _swap() {
    final hasilTeks = _hasil?.translation ?? '';
    setState(() {
      final tmp = _sourceLang;
      _sourceLang = _targetLang;
      _targetLang = tmp;
      if (hasilTeks.isNotEmpty) _inputController.text = hasilTeks;
      _hasil = null;
      _errorMsg = null;
    });
  }

  void _setSource(String lang) {
    if (lang == _targetLang) {
      setState(() {
        final tmp = _sourceLang; _sourceLang = lang; _targetLang = tmp;
        _hasil = null; _errorMsg = null;
      });
    } else {
      setState(() { _sourceLang = lang; _hasil = null; _errorMsg = null; });
    }
  }

  void _setTarget(String lang) {
    if (lang == _sourceLang) {
      setState(() {
        final tmp = _targetLang; _targetLang = lang; _sourceLang = tmp;
        _hasil = null; _errorMsg = null;
      });
    } else {
      setState(() { _targetLang = lang; _hasil = null; _errorMsg = null; });
    }
  }

  Future<void> _terjemahkan() async {
    final teks = _inputController.text.trim();
    if (teks.isEmpty) return;
    FocusScope.of(context).unfocus();
    setState(() { _isLoading = true; _hasil = null; _errorMsg = null; });
    try {
      final hasil = await _service.terjemahkan(text: teks, direction: _direction);
      if (mounted) setState(() { _hasil = hasil; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _errorMsg = e.toString(); _isLoading = false; });
    }
  }

  void _copyToClipboard() {
    if (_hasil == null) return;
    Clipboard.setData(ClipboardData(text: _hasil!.translation));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Teks disalin', style: AppTextStyles.caption.copyWith(color: AppColors.white)),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.navy,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Penerjemah', style: AppTextStyles.subtitle),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildLangRow(),
              const SizedBox(height: 16),
              _buildInputCard(),
              const SizedBox(height: 10),
              _buildOutputCard(),
              const SizedBox(height: 20),
              _buildButton(),
            ],
          ),
      ),
    );
  }

  // ── Baris pemilih bahasa + tombol swap ────────────────────────────────────

  Widget _buildLangRow() {
    return Row(
      children: [
        Expanded(child: _LangDropdown(lang: _sourceLang, options: _langs.where((l) => l != _targetLang).toList(), onSelected: _setSource)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GestureDetector(
            onTap: _swap,
            child: Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                color: AppColors.gold,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: AppColors.gold.withValues(alpha: 0.4), blurRadius: 10, offset: const Offset(0, 3))],
              ),
              child: const Icon(Icons.swap_horiz_rounded, color: AppColors.white, size: 22),
            ),
          ),
        ),
        Expanded(child: _LangDropdown(lang: _targetLang, options: _langs.where((l) => l != _sourceLang).toList(), onSelected: _setTarget)),
      ],
    );
  }

  // ── Kartu input ───────────────────────────────────────────────────────────

  Widget _buildInputCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 10, 0),
            child: Row(
              children: [
                _LangBadge(label: _sourceLang, color: AppColors.primary),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textSecondary),
                  onPressed: () => setState(() { _inputController.clear(); _hasil = null; _errorMsg = null; }),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ],
            ),
          ),
          TextField(
            controller: _inputController,
            maxLines: 6,
            minLines: 4,
            style: AppTextStyles.body.copyWith(color: AppColors.navy, fontSize: 16),
            decoration: InputDecoration(
              hintText: 'Ketik teks di sini…',
              hintStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
              contentPadding: const EdgeInsets.fromLTRB(14, 8, 14, 16),
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }

  // ── Kartu output / hasil ──────────────────────────────────────────────────

  Widget _buildOutputCard() {
    final hasResult = _hasil != null;
    return Container(
      decoration: BoxDecoration(
        color: hasResult ? AppColors.primary.withValues(alpha: 0.03) : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: hasResult ? AppColors.primary.withValues(alpha: 0.2) : AppColors.borderColor),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 10, 0),
            child: Row(
              children: [
                _LangBadge(label: _targetLang, color: hasResult ? AppColors.primary : AppColors.textSecondary),
                const Spacer(),
                if (hasResult)
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, size: 18, color: AppColors.textSecondary),
                    onPressed: _copyToClipboard,
                    tooltip: 'Salin teks',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 90),
              child: _buildOutputContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutputContent() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 28),
        child: Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2.5))),
      );
    }
    if (_errorMsg != null) {
      if (_isNetworkError) {
        return _buildNoInternetView();
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 15),
          const SizedBox(width: 6),
          Expanded(child: Text(_errorMsg!, style: AppTextStyles.caption.copyWith(color: AppColors.error))),
        ],
      );
    }
    if (_hasil != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_hasil!.translation, style: AppTextStyles.body.copyWith(color: AppColors.navy, fontSize: 16)),
          if (_hasil!.confidence == 'low') ...[
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline_rounded, size: 12, color: AppColors.textSecondary),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    'Terjemahan mungkin tidak 100% akurat. Gunakan sebagai referensi.',
                    style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ],
        ],
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 28),
      child: Text(
        'Hasil terjemahan akan muncul di sini',
        style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
      ),
    );
  }

  Widget _buildNoInternetView() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 28, color: AppColors.textSecondary),
            const SizedBox(height: 8),
            Text(
              'Tidak ada koneksi internet',
              style: AppTextStyles.body.copyWith(color: AppColors.navy, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 3),
            Text(
              'Periksa koneksi dan coba lagi.',
              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _terjemahkan,
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              ),
              child: Text(
                'Coba Lagi',
                style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Tombol terjemahkan ────────────────────────────────────────────────────

  Widget _buildButton() {
    return FilledButton(
      onPressed: _isLoading ? null : _terjemahkan,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
        shape: const StadiumBorder(),
        minimumSize: const Size.fromHeight(52),
      ),
      child: _isLoading
          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2))
          : Text('Terjemahkan', style: AppTextStyles.button),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _LangDropdown extends StatelessWidget {
  const _LangDropdown({required this.lang, required this.options, required this.onSelected});

  final String lang;
  final List<String> options;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      initialValue: lang,
      onSelected: onSelected,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      position: PopupMenuPosition.under,
      itemBuilder: (_) => options
          .map((l) => PopupMenuItem(value: l, child: Text(l, style: AppTextStyles.body.copyWith(color: AppColors.navy))))
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(lang, style: AppTextStyles.body.copyWith(color: AppColors.navy, fontWeight: FontWeight.w700)),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppColors.navy.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }
}

class _LangBadge extends StatelessWidget {
  const _LangBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: AppTextStyles.caption.copyWith(color: color, fontWeight: FontWeight.w600)),
    );
  }
}
