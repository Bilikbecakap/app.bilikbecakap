import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class PdfViewerPage extends StatefulWidget {
  const PdfViewerPage({
    super.key,
    required this.pdfUrl,
    required this.judul,
  });

  final String pdfUrl;
  final String judul;

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  String? _localPath;
  bool _isLoading = true;
  bool _fromCache = false;
  String? _errorMsg;
  int _currentPage = 0;
  int _totalPages = 0;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  String get _cacheFileName =>
      Uri.parse(widget.pdfUrl).pathSegments.last;

  Future<void> _loadPdf() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$_cacheFileName');

      // Gunakan cache jika file sudah ada
      if (await file.exists()) {
        if (!mounted) return;
        setState(() {
          _localPath = file.path;
          _fromCache = true;
          _isLoading = false;
        });
        return;
      }

      // Belum ada cache — download dan simpan permanen
      final response = await http
          .get(Uri.parse(widget.pdfUrl))
          .timeout(const Duration(seconds: 30));
      if (response.statusCode != 200) {
        throw Exception('Gagal mengunduh PDF (${response.statusCode})');
      }
      await file.writeAsBytes(response.bodyBytes);
      if (!mounted) return;
      setState(() {
        _localPath = file.path;
        _fromCache = false;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMsg = 'PDF tidak tersedia.\nBuka modul ini saat online untuk menyimpan PDF secara lokal.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.navy),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.judul,
              style: AppTextStyles.subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (_fromCache)
              Text(
                'Tersimpan lokal',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        centerTitle: false,
      ),
      body: _isLoading
          ? _buildLoading()
          : _errorMsg != null
              ? _buildError()
              : _buildPdfView(),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          const SizedBox(height: 16),
          Text(
            'Memuat PDF...',
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 48,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMsg!,
              style: AppTextStyles.body.copyWith(
                color: AppColors.navy,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                setState(() { _isLoading = true; _errorMsg = null; });
                _loadPdf();
              },
              child: Text(
                'Coba Lagi',
                style: AppTextStyles.body.copyWith(color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPdfView() {
    return Stack(
      children: [
        PDFView(
          filePath: _localPath!,
          enableSwipe: true,
          swipeHorizontal: false,
          autoSpacing: true,
          pageFling: true,
          pageSnap: true,
          defaultPage: _currentPage,
          fitPolicy: FitPolicy.BOTH,
          onPageChanged: (page, total) {
            setState(() {
              _currentPage = page ?? 0;
              _totalPages = total ?? 0;
            });
          },
        ),
        if (_totalPages > 0)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.navy.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Halaman ${_currentPage + 1} dari $_totalPages',
                  style: AppTextStyles.caption.copyWith(color: AppColors.white),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
