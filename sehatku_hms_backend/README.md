# ⚙️ SehatKu HMS Backend REST API

Backend service untuk **SehatKu Hospital Management System**, dibangun menggunakan **NestJS**, **Prisma ORM**, **PostgreSQL 16**, dan **Redis 7**.

---

## 🛠️ Tech Stack & Modul Backend

- **Framework**: [NestJS 10](https://nestjs.com/) (TypeScript)
- **Database & ORM**: PostgreSQL 16 + [Prisma ORM 5](https://www.prisma.io/)
- **Cache & Queue**: Redis 7
- **Authentication**: Passport.js + JWT (JSON Web Token) + Bcrypt
- **API Documentation**: Swagger OpenAPI 3.1 & Postman Collection
- **Validation**: `class-validator` & `class-transformer`

---

## 📂 Struktur Modul Backend (`src/modules/`)

```text
src/
├── app.module.ts              # Root Module
├── main.ts                    # Entry Point & Swagger Bootstrap
├── prisma/                    # Prisma Service & Seeder
│   ├── prisma.service.ts
│   └── seed.ts                # Database Seeder dengan Akun & Data Klinis
└── modules/
    ├── auth/                  # Login, Register, Profile, JWT Strategy & Guards
    ├── doctors/               # CRUD Dokter Spesialis, SIP, Departemen & Status
    ├── patients/              # Direktori Rekam Medis Pasien, NIK, BPJS
    ├── appointments/          # Pendaftaran Janji Temu, Antrean Poli, Check-in & Selesai
    ├── medical-records/       # EMR SOAP, ICD-10 Diagnosis Search, Formularium Obat
    ├── pharmacy/              # Antrean Resep Masuk, Dispensing Tracker, Stok Obat
    ├── billing/               # Kasir POS, Agregasi Biaya, Pelunasan & Data Kwitansi PDF
    └── audit/                 # Immutable Audit Trail & Log Keamanan Sistem
```

---

## 🚀 Panduan Setup & Menjalankan Backend

### 1. Prasyarat
- Node.js >= 18
- Docker & Docker Compose (untuk PostgreSQL & Redis)

### 2. Jalankan Database Container
Di root workspace:
```bash
docker compose up -d
```

### 3. Instalasi Dependensi & Environment
```bash
cd sehatku_hms_backend
cp .env.example .env
npm install
```

Pastikan variabel `DATABASE_URL` di `.env` sesuai:
```env
DATABASE_URL="postgresql://sehatku_admin:sehatku_secure_2026@localhost:5432/sehatku_hms_db?schema=public"
JWT_SECRET="sehatku_hms_jwt_secret_production_key_2026"
PORT=3000
```

### 4. Sinkronisasi Skema Database & Seeding Data
```bash
# Generate Prisma client
npx prisma generate

# Terapkan schema ke PostgreSQL
npx prisma db push

# Isi data awal (Dokter, Pasien, Obat, Departemen, Akun Demo)
npm run prisma:seed
```

### 5. Jalankan Server Development
```bash
npm run start:dev
```

Server akan aktif pada:
- **Base API URL**: `http://localhost:3000/api/v1`
- **Swagger Interactive Documentation**: `http://localhost:3000/api/docs`

---

## 📑 Daftar Endpoint REST API Utama

| Modul | Method | Endpoint | Deskripsi |
| :--- | :--- | :--- | :--- |
| **Auth** | `POST` | `/auth/login` | Login user & return JWT token + profil role |
| **Auth** | `POST` | `/auth/register` | Pendaftaran akun baru |
| **Doctors** | `GET` | `/doctors` | Daftar dokter spesialis & filter departemen |
| **Doctors** | `POST` | `/doctors` | Tambah dokter baru (Admin) |
| **Doctors** | `PUT` | `/doctors/:id` | Update data dokter |
| **Doctors** | `PATCH` | `/doctors/:id/toggle-active` | Aktif / Nonaktifkan dokter |
| **Patients** | `GET` | `/patients` | Direktori pasien (search NIK, MRN, Nama) |
| **Patients** | `POST` | `/patients` | Registrasi pasien baru |
| **Appointments** | `GET` | `/appointments` | Daftar antrean & histori reservasi pasien |
| **Appointments** | `POST` | `/appointments` | Buat janji temu baru |
| **Appointments** | `PATCH` | `/appointments/:id/check-in` | Check-in kedatangan pasien di RS |
| **Appointments** | `PATCH` | `/appointments/:id/complete` | Menandai konsultasi selesai |
| **Appointments** | `PATCH` | `/appointments/:id/cancel` | Batalkan janji temu dengan alasan |
| **Medical Records**| `GET` | `/medical-records` | Riwayat rekam medis SOAP |
| **Medical Records**| `POST` | `/medical-records` | Simpan konsultasi SOAP & E-Prescription |
| **Medical Records**| `GET` | `/medical-records/icd10` | Katalog pencarian kode diagnosa ICD-10 |
| **Medical Records**| `GET` | `/medical-records/formulary` | Katalog obat formularium RS |
| **Pharmacy** | `GET` | `/pharmacy/prescriptions` | Antrean resep obat farmasi |
| **Pharmacy** | `PATCH` | `/pharmacy/prescriptions/:id/status` | Update dispensing resep & auto potong stok |
| **Pharmacy** | `GET` | `/pharmacy/inventory` | Daftar inventori & stok obat |
| **Pharmacy** | `PATCH` | `/pharmacy/inventory/:id/stock` | Restock obat farmasi |
| **Billing** | `GET` | `/billing/invoices` | Daftar invoice & status pelunasan |
| **Billing** | `GET` | `/billing/invoices/:id/receipt-data` | Data kwitansi resmi siap cetak PDF |
| **Billing** | `PATCH` | `/billing/invoices/:id/pay` | Pelunasan tagihan kasir POS multi-metode |
| **Audit Logs** | `GET` | `/audit-logs` | Riwayat audit trail mutasi data |

---

## 🧪 Testing & Postman

Gunakan Postman Collection di [`sehatku_hms_postman_collection.json`](file:///Users/macbookpro/development/sehatku_hms/sehatku_hms_backend/sehatku_hms_postman_collection.json) untuk menguji seluruh endpoint.
