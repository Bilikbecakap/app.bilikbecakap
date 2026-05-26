# CLAUDE.md — BilikBecakap Mobile App

> **BilikBecakap** adalah Platform Pelestarian Budaya dan Bahasa Melayu Belitung.
> Aplikasi mobile **Android** berbasis Flutter.
> Target pengguna: **anak sekolah (SD–SMA)**.

---

## 1. Status Fase Saat Ini

### Selesai (UI + API)
| Fitur | Status | Catatan |
|---|---|---|
| Splash Screen | ✅ Selesai | Animasi fade + scale, logo |
| Home | ✅ Selesai | Header, hero banner, feature grid, berita section |
| Berita/Artikel | ✅ API Connected | Fetch + Hive cache, detail dengan HTML renderer |
| Penerjemah | ✅ API Connected | 3 bahasa (Belitung/Indonesia/English), offline handling |
| Kamus | ⚠️ UI belum sepenuhnya Selesai, menyesuaikan kondisi setelah pengembangan | Data masih statis |
| Pembelajaran | ⚠️ UI belum sepenuhnya Selesai, menyesuaikan kondisi setelah pengembangan | Data masih statis, belum ada video/PDF |
| Kuis | ⚠️ UI belum sepenuhnya Selesai, menyesuaikan kondisi setelah pengembangan | 5 soal statis, scoring sudah jalan |

### Fase Berikutnya: Integrasi API Pembelajaran
- Fetch daftar modul dari API
- Tampilkan video YouTube per modul
- Buka PDF modul (dari URL API)
- Opsional: koneksi kuis ke modul tertentu

---

## 2. Tech Stack

```yaml
dependencies:
  flutter:
    sdk: flutter
  go_router: ^14.0.0
  google_fonts: ^6.0.0
  http: ^1.2.0
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  flutter_widget_from_html_core: ^0.15.2
```

### Package yang akan ditambah di fase Pembelajaran
| Kebutuhan | Package |
|---|---|
| Video YouTube | `youtube_player_flutter` |
| PDF viewer | `flutter_pdfview` atau `pdfx` |
| Simpan file download | `path_provider` |
| Cache file PDF | `flutter_cache_manager` |

---

## 3. Struktur Folder Aktual

```
lib/
├── main.dart
├── app.dart                              # Root widget, GoRouter, ThemeData
│
├── core/theme/
│   ├── app_colors.dart                   # Semua warna brand
│   └── app_text_styles.dart             # Semua typography style
│
├── shared/widgets/
│   ├── bilik_button.dart                 # BilikButton.primary / .secondary
│   ├── bilik_card.dart                   # BilikCard dengan border + shadow
│   └── empty_state_widget.dart
│
└── features/
    ├── splash/presentation/pages/
    │   └── splash_page.dart
    │
    ├── home/
    │   ├── data/
    │   │   ├── models/artikel_model.dart
    │   │   └── services/artikel_service.dart    # Fetch + Hive cache
    │   └── presentation/
    │       ├── pages/home_page.dart
    │       └── widgets/berita_section.dart      # FutureBuilder + API
    │
    ├── kamus/presentation/pages/
    │   ├── kamus_page.dart               # Data statis, belum API
    │   └── detail_kata_page.dart
    │
    ├── penerjemah/
    │   ├── data/
    │   │   ├── models/terjemahan_model.dart
    │   │   └── services/penerjemah_service.dart # POST ke API
    │   └── presentation/pages/penerjemah_page.dart
    │
    ├── pembelajaran/presentation/pages/
    │   ├── pembelajaran_page.dart        # List modul, masih statis
    │   └── modul_detail_page.dart        # Detail modul, masih statis
    │
    ├── kuis/presentation/pages/
    │   └── kuis_page.dart               # 5 soal statis, StatefulWidget
    │
    └── artikel/
        ├── data/
        │   ├── models/artikel_detail_model.dart
        │   ├── models/artikel_detail_model.g.dart  # Hive adapter (generated)
        │   └── services/artikel_detail_service.dart
        └── presentation/pages/
            ├── artikel_detail_page.dart   # HTML renderer
            └── artikel_webview_page.dart
```

---

## 4. API

**Base URL:** `https://bilikbecakap.com/api/v1`

| Endpoint | Method | Digunakan di |
|---|---|---|
| `/artikel` | GET | `ArtikelService` |
| `/artikel/:slug` | GET | `ArtikelDetailService` |
| `/penerjemah` | POST | `PenerjemahService` |
| `/modul` | GET | Belum diimplementasi |
| `/modul/:id` | GET | Belum diimplementasi |

### Pola Service yang Dipakai (Cache-First)
```dart
// Selalu coba network dulu, fallback ke Hive kalau gagal
try {
  final response = await http.get(uri).timeout(Duration(seconds: 10));
  if (response.statusCode == 200) {
    await box.put(key, responseBody); // simpan ke cache
    return parse(responseBody);
  }
} catch (_) {
  final cached = box.get(key);
  if (cached != null) return parse(cached);
  rethrow;
}
```

---

## 5. Navigasi & Routing

```dart
// app.dart — GoRouter
initialLocation: '/splash'

// Shell route (ada bottom nav)
/               → HomePage
/kamus          → KamusPage
/penerjemah     → PenerjemahPage
/pembelajaran   → PembelajaranPage
/kuis           → KuisPage

// Detail route (tanpa bottom nav)
/kamus/detail/:id          → DetailKataPage       (extra: Map<String, String>)
/pembelajaran/modul/:id    → ModulDetailPage      (extra: Map<String, dynamic>)
/artikel/:slug             → ArtikelDetailPage    (extra: String judul)

// Rencana route untuk fase Pembelajaran
/pembelajaran/video/:id    → VideoPlayerPage      (akan dibuat)
/pembelajaran/pdf/:id      → PdfViewerPage        (akan dibuat)
```

---

## 6. Visual Identity & Design System

### Brand Colors

```dart
class AppColors {
  static const Color primary       = Color(0xFF54B0AF); // Teal utama
  static const Color primaryDark   = Color(0xFF459A99); // Teal pressed
  static const Color navy          = Color(0xFF002B44); // Heading gelap
  static const Color gold          = Color(0xFFFCB415); // Aksen emas (tombol swap, badge)
  static const Color white         = Color(0xFFFFFFFF);
  static const Color background    = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color borderColor   = Color(0xFFE5E7EB);
  static const Color error         = Color(0xFFEF4444);
  static const Color success       = Color(0xFF22C55E);
}
```

### Typography
- **Font:** Poppins via `google_fonts` (400, 500, 600, 700)
- Class: `AppTextStyles` → `.title`, `.subtitle`, `.body`, `.caption`, `.button`

### Design Tokens

| Token | Nilai |
|---|---|
| Border radius card | `12px` |
| Border radius button/badge | `999px` (pill) |
| Card padding | `16px` |
| Section spacing | `24px` |
| Bottom nav — 5 tab | fixed, selectedItemColor: teal |

### Komponen Standar

| Komponen | Spesifikasi |
|---|---|
| `BilikButton.primary()` | Background teal, teks putih, pill |
| `BilikButton.secondary()` | Background putih, border + teks navy, pill |
| `BilikCard()` | White bg, border `#E5E7EB`, radius 12px, shadow subtle |

---

## 7. Coding Conventions

- **Bahasa kode:** Dart
- **Bahasa komentar:** Bahasa Indonesia
- **Penamaan:** file → `snake_case`, class → `PascalCase`, variabel → `camelCase`
- Gunakan `const` constructor sebisa mungkin
- Satu file maksimal **300 baris** — pecah jika lebih
- ❌ Jangan hardcode warna/ukuran font langsung di widget — pakai `AppColors` dan `AppTextStyles`
- `setState` hanya untuk interaksi UI lokal (kuis, form input)
- `FutureBuilder` untuk async data di halaman yang belum pakai BLoC
- Pola service: selalu cache-first (network → simpan Hive → fallback Hive)

---

## 8. Cara Kerja dengan AI (Claude)

- Sebutkan **screen atau fitur mana** yang sedang dikerjakan di awal prompt
- Jika ada konflik antara instruksi prompt dan `CLAUDE.md` → **CLAUDE.md yang menang**
- Untuk fitur baru yang butuh API → ikuti pola `ArtikelService` (cache-first, Hive)
- Fase berikutnya: integrasi API Pembelajaran (modul, video YT, PDF)
- Fase setelah itu: BLoC/Cubit, lalu database lokal penuh
