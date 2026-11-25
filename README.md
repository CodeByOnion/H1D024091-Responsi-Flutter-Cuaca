# AWANARA

Aplikasi cuaca Flutter dengan desain **glassmorphism hijau & putih** yang **adaptif mengikuti kondisi cuaca** dari Open-Meteo API, dibangun menggunakan arsitektur **MVVM** dan state management **Provider**.

## Fitur

- Menampilkan cuaca terkini (suhu, kondisi, suhu terasa, kelembapan, kecepatan angin, peluang hujan, dan curah hujan).
- Prakiraan cuaca 7 hari ke depan (suhu maksimum/minimum, ikon kondisi, dan peluang hujan).
- Pencarian kota secara real-time ke **Open-Meteo Geocoding API** dengan debounce 500 ms.
- Penyimpanan lokal (**SharedPreferences**) untuk lokasi favorit, riwayat pencarian (maksimal 10 item), dan lokasi terakhir yang dibuka.
- Tema adaptif cuaca (**WeatherMood**): latar gradien, kartu kaca, dan warna teks berubah otomatis dan halus sesuai `weather_code` (cerah, cerah berawan, mendung, hujan, badai, malam).
- Penanganan state **loading**, **empty**, dan **error** (termasuk timeout dan offline) serta pull-to-refresh.

## Tech Stack

- **Flutter & Dart** (Material 3)
- **http** (`^1.6.0`) — HTTP GET ke Open-Meteo
- **provider** (`^6.1.2`) — State management MVVM (`ChangeNotifier`)
- **shared_preferences** (`^2.5.4`) — Penyimpanan lokal
- **google_fonts** (`^8.1.0`) — Tipografi Poppins & Inter
- **intl** (`^0.20.2`) — Pemformatan tanggal

## Arsitektur (MVVM)

```text
View (views/) ──(aksi user)──▶ ViewModel (viewmodels/) ──▶ Repository (data/repositories/) ──▶ ApiService / StorageService
  ▲                                      │
  └────────── notifyListeners() ─────────┘  (watch / select)
```

- **Model (`lib/data/models/`)**: Class data murni + `fromJson` / `toJson`, tanpa import Flutter UI.
- **Service & Repository (`lib/data/services/`, `lib/data/repositories/`)**: Akses HTTP ke Open-Meteo dan `SharedPreferences`.
- **ViewModel (`lib/viewmodels/`)**: `WeatherViewModel` & `LocationViewModel` mengelola state (`ViewState`), memanggil repository, dan menghitung `WeatherMood` / `WeatherPalette`.
- **View (`lib/views/`)**: Widget UI yang hanya membaca state dari ViewModel dan memanggil method ViewModel (tidak memanggil `http` atau `SharedPreferences` secara langsung).

## Implementasi API

- **Geocoding API**:
  `GET https://geocoding-api.open-meteo.com/v1/search?name={query}&count=10&language=id&format=json`
- **Weather Forecast API**:
  `GET https://api.open-meteo.com/v1/forecast?latitude={lat}&longitude={lon}&current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m,is_day&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max&timezone=auto&forecast_days=7`

## Tema Adaptif Cuaca

| Mood | `weather_code` | Tampilan |
|---|---|---|
| `clear` | 0, 1 | Gradien hijau cerah, teks hijau tua (`#0B3D2E`) |
| `partlyCloudy` | 2 | Hijau cerah agak redup, teks hijau tua |
| `cloudy` | 3, 45, 48, 71–77, 85, 86 | Hijau keabu-abuan agak gelap, teks putih |
| `rain` | 51–67, 80–82 | Hijau tua gelap, teks putih |
| `storm` | 95, 96, 99 | Paling gelap, aksen kilat samar, teks putih |
| `night` | 0, 1, 2 saat `is_day == 0` | Gelap tenang, teks putih |

## Struktur Folder

```text
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/api_constants.dart
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   ├── app_theme.dart
│   │   ├── weather_mood.dart
│   │   └── weather_palette.dart
│   └── utils/
│       ├── date_formatter.dart
│       └── weather_code_mapper.dart
├── data/
│   ├── models/
│   ├── repositories/
│   └── services/
├── viewmodels/
└── views/
    ├── home/
    ├── search/
    └── shared/
```

## Cara Menjalankan

```bash
flutter pub get
flutter run
```

## Screenshot

| Home | Search |
|---|---|
| *(Tambahkan screenshot di `screenshots/home.png`)* | *(Tambahkan screenshot di `screenshots/search.png`)* |

## Asumsi

- Saat pertama kali dibuka dan belum ada lokasi tersimpan di perangkat, aplikasi memuat cuaca koordinat default **Purwokerto** dari Open-Meteo API agar pengguna langsung melihat data cuaca aktif (tetap bisa mencari dan mengganti kota kapan saja).
