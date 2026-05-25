# CLAUDE.md — BilikBecakap Mobile App

> **BilikBecakap** adalah Platform Pelestarian Budaya dan Bahasa Melayu Belitung Timur.
> Aplikasi mobile **Android** berbasis Flutter.
> Target pengguna: **anak sekolah (SD–SMA)**.
> Fase saat ini: **UI-first dengan data statis** — belum ada database, API, atau state management kompleks.

---

## 1. Fokus Fase Ini

- ✅ Bangun **tampilan (UI)** semua screen terlebih dahulu
- ✅ Gunakan **data statis hardcode** langsung di widget/page
- ✅ Target platform: **Android** (iOS dikerjakan di fase berikutnya)
- ❌ Jangan setup database (Drift/SQLite) dulu
- ❌ Jangan integrasi API dulu
- ❌ Jangan buat BLoC/Cubit dulu — cukup `StatelessWidget`

---

## 2. Tech Stack (Fase UI)

| Layer | Teknologi |
|---|---|
| Framework | **Flutter** (Dart) |
| Navigation | **go_router** `^14.x` |
| Font | **google_fonts** `^6.x` (Poppins) |

```yaml
dependencies:
  flutter:
    sdk: flutter
  go_router: ^14.0.0
  google_fonts: ^6.0.0
```

> Package lain (drift, dio, flutter_bloc, dll.) disiapkan nanti saat fasenya tiba.

---

## 3. Struktur Folder

```
lib/
├── main.dart
├── app.dart                        # Root widget, router, theme
│
├── core/
│   └── theme/
│       ├── app_colors.dart         # Semua warna brand
│       └── app_text_styles.dart    # Semua typography style
│
├── features/
│   ├── home/presentation/pages/home_page.dart
│   ├── kamus/presentation/pages/
│   │   ├── kamus_page.dart
│   │   └── detail_kata_page.dart
│   ├── penerjemah/presentation/pages/penerjemah_page.dart   # Placeholder
│   ├── pembelajaran/presentation/pages/
│   │   ├── pembelajaran_page.dart
│   │   └── modul_detail_page.dart
│   └── kuis/presentation/pages/
│       └── kuis_page.dart
│
└── shared/widgets/
    ├── bilik_button.dart
    ├── bilik_card.dart
    └── empty_state_widget.dart
```

---

## 4. Visual Identity & Design System

### Brand Colors

```dart
// lib/core/theme/app_colors.dart
class AppColors {
  static const Color primary       = Color(0xFF54B0AF); // Teal utama
  static const Color primaryDark   = Color(0xFF459A99); // Teal pressed
  static const Color navy          = Color(0xFF002B44); // Heading gelap
  static const Color gold          = Color(0xFFFCB415); // Aksen emas
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

```dart
// lib/core/theme/app_text_styles.dart
class AppTextStyles {
  static TextStyle title    = /* 24px, bold, navy */
  static TextStyle subtitle = /* 18px, semibold, navy */
  static TextStyle body     = /* 14px, regular, gray */
  static TextStyle caption  = /* 12px, regular, gray */
  static TextStyle button   = /* 14px, semibold, white */
}
```

### Design Tokens

| Token | Nilai |
|---|---|
| Border radius card | `12px` |
| Border radius button/badge | `999px` (pill) |
| Card padding | `16px` |
| Section spacing | `24px` |
| Bottom nav height | `60px` |

### Komponen UI Standar

| Komponen | Spesifikasi |
|---|---|
| `BilikButton.primary()` | Background teal, teks putih, pill |
| `BilikButton.secondary()` | Background putih, border + teks navy, pill |
| `BilikCard()` | White bg, border `#E5E7EB`, radius 12px, shadow subtle |

---

## 5. Navigasi & Routing

### Bottom Navigation — 5 Tab

| Tab | Route | Halaman |
|---|---|---|
| Beranda | `/` | HomePage |
| Kamus | `/kamus` | KamusPage |
| Terjemah | `/penerjemah` | PenerjemahPage |
| Belajar | `/pembelajaran` | PembelajaranPage |
| Kuis | `/kuis` | KuisPage |

### Halaman Detail (tanpa bottom nav)

| Route | Halaman |
|---|---|
| `/kamus/detail/:id` | DetailKataPage |
| `/pembelajaran/modul/:id` | ModulDetailPage |

---

## 6. Screen Specifications

### Home Screen
- Header logo + teks sapaan
- Hero banner: gradient teal, tagline bold navy, tombol CTA pill
- Feature grid 2×2: Kamus · Penerjemah · Pembelajaran · Kuis
- Section berita: berita tentang budaya dan bahasa melayu belitung (3 item statis)
- Bottom nav 5 tab (active state teal)

### Kamus Screen
- Search bar rounded (UI saja, belum berfungsi)
- Filter chip A–Z scroll horizontal (UI saja)
- List kata statis (7 contoh kata hardcode)
- FAB teal kanan bawah

### Detail Kata Screen
- Nama kata besar, kategori badge
- Definisi dan contoh kalimat (data statis)
- Tombol putar audio (UI saja, belum berfungsi)
- Tidak ada bottom nav (halaman push)

### Penerjemah Screen
- Tampilkan halaman **placeholder** "Segera Hadir"
- Ikon ilustrasi, pesan informatif, info box emas

### Pembelajaran Screen
- List card modul (5 modul statis)
- Setiap card: ikon, judul, badge kesulitan (Dasar/Menengah/Lanjut), deskripsi, progress bar statis

### Modul Detail Screen
- Hero banner teal (ikon, judul, badge kesulitan)
- Deskripsi modul
- Daftar materi yang dipelajari
- Tidak ada bottom nav (halaman push)

### Kuis Screen
- Progress bar soal di atas
- Tampilan soal pilihan ganda (5 soal statis)
- UI tombol pilihan bergaya card (A/B/C/D)
- Tombol "Selanjutnya" / "Selesai" (navigasi menggunakan setState)
- Halaman hasil skor setelah semua soal dijawab
- Bottom nav tetap tampil (tab aktif: Kuis)

---

## 7. Coding Conventions

- **Bahasa kode:** Dart
- **Bahasa komentar:** Bahasa Indonesia
- **Penamaan:** file → `snake_case`, class → `PascalCase`, variabel → `camelCase`
- Gunakan `const` constructor sebisa mungkin
- Satu file maksimal **300 baris** — pecah jika lebih
- ❌ Jangan hardcode warna/ukuran font langsung di widget — pakai `AppColors` dan `AppTextStyles`
- ❌ Jangan gunakan `setState` kecuali benar-benar perlu untuk interaksi UI lokal sederhana

---

## 8. Cara Kerja dengan AI (Claude)

- Sebutkan **screen mana** yang sedang dikerjakan di awal prompt
- Minta **satu screen per sesi** agar output tetap fokus
- Jika ada konflik antara instruksi prompt dan `CLAUDE.md` → **CLAUDE.md yang menang**
- Setelah semua tampilan selesai, fase berikutnya: setup state management → database → API
