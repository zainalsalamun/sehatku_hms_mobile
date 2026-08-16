# 🏥 SehatKu HMS (Hospital Management System)

[![NestJS](https://img.shields.io/badge/Backend-NestJS%2010-E0234E?logo=nestjs&logoColor=white)](https://nestjs.com/)
[![Flutter](https://img.shields.io/badge/Frontend-Flutter%203.x%20(Mobile%20%26%20Web)-02569B?logo=flutter&logoColor=white)](https://flutter.dev/)
[![Prisma](https://img.shields.io/badge/ORM-Prisma%205-2D3748?logo=prisma&logoColor=white)](https://www.prisma.io/)
[![PostgreSQL](https://img.shields.io/badge/Database-PostgreSQL%2016-336791?logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Swagger](https://img.shields.io/badge/API_Docs-Swagger%20OpenAPI%203.1-85EA2D?logo=swagger&logoColor=black)](http://localhost:3000/api/docs)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

**SehatKu HMS** adalah sistem informasi manajemen rumah sakit (*Hospital Management System*) tingkat *enterprise* yang dirancang modern, modular, dan terpadu. Sistem ini menghubungkan seluruh alur operasional medis dan administratif—mulai dari pendaftaran pasien, antrean poli live, rekam medis elektronik (EMR/SOAP), peracikan farmasi, hingga kasir POS dan cetak kwitansi resmi PDF.

---

## 📌 Gambaran Umum Arsitektur

Monorepo ini terdiri atas dua komponen utama yang saling terintegrasi 100% dengan database PostgreSQL:

```text
sehatku_hms/
├── sehatku_hms_backend/      # ⚙️ Backend REST API (NestJS + Prisma + PostgreSQL + Redis)
├── sehatku_hms_mobile/       # 📱💻 Frontend Cross-Platform (Flutter Mobile Android/iOS & Web)
├── docs/                     # 📚 Dokumentasi Arsitektur, PRD, Data Model, OpenAPI & Postman
├── database/                 # 🗄️ SQL Schema DDL & Seed Scripts
└── docker-compose.yml        # 🐳 Container PostgreSQL 16, Redis 7, & pgAdmin 4
```

---

## 🚀 Fitur Utama & Modul Sistem

### 1. 👥 Multi-Role & Dynamic Authentication (RBAC)
- **Role Terdaftar**: *Pasien*, *Dokter Spesialis*, dan *Hospital Admin / Staf Kasir / Apoteker*.
- **Token JWT Interceptor**: Keamanan API berbasis JWT Bearer Token dengan pencatatan audit log otomatis.
- **Dynamic Profiles**: Data spesialisasi dokter, nomor izin praktek (SIP), dan Nomor Rekam Medis (MRN) terikat langsung ke database.

### 2. 👤 Portal Pasien (Mobile & Web App)
- **Booking Janji Temu Interaktif**: Memilih dokter spesialis, jadwal hari/jam, dan input keluhan.
- **Payment Gateway QRIS**: Simulasi pembayaran instan dan penerbitan tiket antrean digital (QR code).
- **Tab Janji Temu (Histori Reservasi)**: Memantau status janji temu (*Aktif*, *Selesai*, *Dibatalkan*), membuka tiket antrean, dan membatalkan reservasi.
- **Rekam Medis Terenkripsi**: Pasien dapat membaca riwayat pemeriksaan klinis, tanda vital, diagnosa ICD-10, dan resep obat.
- **Kwitansi Resmi PDF**: Pasien dapat mengunduh dan mencetak bukti pembayaran resmi ber-kop rumah sakit.

### 3. 👨‍⚕️ Dashboard Dokter & Rekam Medis Elektronik (EMR SOAP)
- **Antrean Poli Hari Ini**: Monitoring antrean pasien live per dokter (*Tiba*, *Dipanggil*, *Diperiksa*).
- **Form Konsultasi SOAP Terstandarisasi**:
  - **S (Subjective)**: Anamnesis dan keluhan utama pasien.
  - **O (Objective)**: Tanda vital (TD, HR, RR, Suhu, SpO2, TB, BB) & kalkulator BMI otomatis.
  - **A (Assessment)**: Pencarian katalog resmi **ICD-10** (Kardiovaskular, Respirasi, Endokrin, Gastro, dll).
  - **P (Plan / E-Prescription)**: Peresepan obat dari formularium rumah sakit dengan dosis, rute, dan durasi hari.
- **Tanda Tangan Elektronik & Auto-Dispatch**: Menandatangani rekam medis secara sah dan meneruskan e-resep langsung ke Farmasi.

### 4. 💊 Modul Farmasi & Dispensing Obat
- **Dashboard Antrean Resep**: Menerima e-resep dokter secara real-time.
- **Dispensing Tracker**: Mengelola status obat (*Menunggu* ➔ *Sedang Diracik* ➔ *Siap di Loket* ➔ *Diserahkan*).
- **Manajemen Stok Otomatis**: Pengurangan stok obat otomatis saat resep diserahkan dan pembaruan batch/kedaluwarsa.

### 5. 🧾 Modul Kasir POS & Cetak Kwitansi Resmi PDF
- **Agregasi Biaya Terpadu**: Menggabungkan jasa konsultasi dokter + obat farmasi + biaya administrasi RS.
- **Kasir POS Multi-Metode**: Pembayaran via *Tunai* (kalkulator kembalian otomatis), *QRIS Dinamis*, *Kartu Debit*, *Transfer Bank*, dan *BPJS Kesehatan*.
- **Official Receipt Generator**: Cetak / Unduh Kwitansi Resmi PDF lengkap dengan kop RS, QR code validasi, rincian biaya, dan stempel lunas.

### 6. 🏢 Dashboard Administrator Rumah Sakit
- **Overview Analytics**: Real-time KPI (Total Pasien, Dokter Aktif, Antrean Hari Ini, Pendapatan Lunas).
- **Manajemen Dokter & Pasien**: CRUD dokter spesialis, jadwal praktek, dan registrasi pasien baru.
- **Audit Trail & Keamanan**: Log pencatatan seluruh aktivitas mutasi data secara *immutable*.

---

## 🛠️ Prasyarat Sistem

- **Node.js**: `>= 18.x`
- **Flutter SDK**: `>= 3.22.x` (Channel Stable)
- **Docker & Docker Compose**: Untuk menjalankan database PostgreSQL & Redis
- **Google Chrome** (untuk menjalankan versi Web) atau **Android Emulator / iOS Simulator**

---

## ⚡ Panduan Menjalankan Sistem (Step-by-Step)

### Langkah 1: Jalankan Database & Redis (Docker)

Di direktori root project:

```bash
docker compose up -d
```

- **PostgreSQL 16**: `localhost:5432` (Database: `sehatku_hms_db`)
- **Redis 7**: `localhost:6379`
- **pgAdmin 4 (Web UI GUI)**: `http://localhost:5050` (Email: `admin@sehatku.id`, Password: `admin_password_2026`)

---

### Langkah 2: Menjalankan Backend REST API

Masuk ke folder backend, instal dependensi, migrasi schema Prisma, dan jalankan server:

```bash
cd sehatku_hms_backend
npm install
npx prisma generate
npx prisma db push
npm run prisma:seed
npm run start:dev
```

- **API Base URL**: `http://localhost:3000/api/v1`
- **Swagger Documentation**: `http://localhost:3000/api/docs`

---

### Langkah 3: Menjalankan Frontend (Mobile & Web)

Masuk ke folder mobile:

```bash
cd sehatku_hms_mobile
flutter pub get
```

#### A. Menjalankan di Browser (Flutter Web - Rekomendasi Admin & Kasir):
```bash
flutter run -d chrome
```

#### B. Menjalankan di Mobile (Android / iOS):
```bash
# Cek device yang tersedia
flutter devices

# Jalankan di emulator / device fisik
flutter run
```

---

## 👥 Akun Uji Coba Default

Gunakan kredensial berikut untuk menguji seluruh alur peran:

| Peran (Role) | Email | Password | Keterangan Profil |
| :--- | :--- | :--- | :--- |
| 🏢 **Hospital Admin** | `admin@sehatku.id` | `password123` | Akses penuh dashboard, kasir POS, farmasi & audit |
| 🩺 **Dokter Kardiologi** | `doctor@sehatku.id` | `password123` | dr. Maya Pratama, Sp.JP (Poli Kardiologi) |
| 🦷 **Dokter Gigi** | `rafi@sehatku.id` | `password123` | drg. Rafi Akbar, Sp.KG (Poli Gigi & Mulut) |
| 👤 **Pasien** | `patient@sehatku.id` | `password123` | Nadia Putri (No. RM: `MRN-2026-001`) |

---

## 📑 Dokumentasi API & Postman

1. **Swagger OpenAPI UI**: Buka `http://localhost:3000/api/docs` saat backend berjalan.
2. **Postman Collection**: File collection siap pakai tersedia di:
   - [`docs/sehatku_hms_postman_collection.json`](file:///Users/macbookpro/development/sehatku_hms/docs/sehatku_hms_postman_collection.json)
   - Import file ini ke Postman untuk menguji seluruh endpoint secara langsung.

---

## 📄 Lisensi

Proyek ini dilisensikan di bawah [MIT License](LICENSE). Dikembangkan untuk solusi rumah sakit modern yang efisien, transparan, dan aman.
