import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme/app_colors.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/kamus/presentation/pages/kamus_page.dart';
import 'features/kamus/presentation/pages/detail_kata_page.dart';
import 'features/penerjemah/presentation/pages/penerjemah_page.dart';
import 'features/pembelajaran/presentation/pages/pembelajaran_page.dart';
import 'features/pembelajaran/presentation/pages/modul_detail_page.dart';
import 'features/pembelajaran/presentation/pages/pdf_viewer_page.dart';
import 'features/pembelajaran/data/models/modul_model.dart';
import 'features/kuis/presentation/pages/kuis_page.dart';
import 'features/kuis/presentation/pages/kuis_detail_page.dart';
import 'features/kuis/presentation/pages/kuis_hasil_page.dart';
import 'features/kuis/data/models/kuis_model.dart';
import 'features/kuis/data/models/kuis_hasil_model.dart';
import 'features/splash/presentation/pages/splash_page.dart';
import 'features/profil/presentation/pages/profil_setup_page.dart';
import 'features/profil/presentation/pages/profil_page.dart';
import 'features/artikel/presentation/pages/artikel_detail_page.dart';

final _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
    GoRoute(path: '/profil/setup', builder: (context, state) => const ProfilSetupPage()),
    GoRoute(path: '/profil', builder: (context, state) => const ProfilPage()),
    ShellRoute(
      builder: (context, state, child) =>
          _MainScaffold(location: state.uri.toString(), child: child),
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomePage()),
        GoRoute(path: '/kamus', builder: (context, state) => const KamusPage()),
        GoRoute(
          path: '/penerjemah',
          builder: (context, state) => const PenerjemahPage(),
        ),
        GoRoute(
          path: '/pembelajaran',
          builder: (context, state) => const PembelajaranPage(),
        ),
        GoRoute(path: '/kuis', builder: (context, state) => const KuisPage()),
      ],
    ),
    // Halaman detail di luar shell (tidak ada bottom nav)
    GoRoute(
      path: '/kamus/detail/:id',
      builder: (context, state) => DetailKataPage(
        kata: state.extra as Map<String, String>,
      ),
    ),
    GoRoute(
      path: '/pembelajaran/modul/:slug',
      builder: (context, state) => ModulDetailPage(
        modul: state.extra as ModulModel,
      ),
    ),
    GoRoute(
      path: '/pembelajaran/pdf',
      builder: (context, state) {
        final data = state.extra as Map<String, String>;
        return PdfViewerPage(pdfUrl: data['url']!, judul: data['judul']!);
      },
    ),
    GoRoute(
      path: '/artikel/:slug',
      builder: (context, state) => ArtikelDetailPage(
        slug: state.pathParameters['slug']!,
        judul: state.extra as String? ?? '',
      ),
    ),
    GoRoute(
      path: '/kuis/main',
      builder: (context, state) => KuisDetailPage(
        kuis: state.extra as KuisModel,
      ),
    ),
    GoRoute(
      path: '/kuis/hasil',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return KuisHasilPage(
          hasil: args['hasil'] as KuisHasilResponse?,
          kuis: args['kuis'] as KuisModel,
          nama: args['nama'] as String,
          isPending: args['isPending'] as bool,
        );
      },
    ),
  ],
);

class BilikBecakapApp extends StatelessWidget {
  const BilikBecakapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BilikBecakap',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: true,
      ),
    );
  }
}

class _MainScaffold extends StatelessWidget {
  const _MainScaffold({required this.location, required this.child});

  final String location;
  final Widget child;

  int get _selectedIndex {
    if (location.startsWith('/kamus')) return 1;
    if (location.startsWith('/penerjemah')) return 2;
    if (location.startsWith('/pembelajaran')) return 3;
    if (location.startsWith('/kuis')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/');
            case 1:
              context.go('/kamus');
            case 2:
              context.go('/penerjemah');
            case 3:
              context.go('/pembelajaran');
            case 4:
              context.go('/kuis');
          }
        },
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: 'Kamus',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            activeIcon: Icon(Icons.swap_horiz),
            label: 'Terjemah',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            activeIcon: Icon(Icons.school),
            label: 'Belajar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz_outlined),
            activeIcon: Icon(Icons.quiz),
            label: 'Kuis',
          ),
        ],
      ),
    );
  }
}
