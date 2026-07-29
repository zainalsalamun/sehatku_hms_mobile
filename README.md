# SehatKu HMS

Flutter Hospital Management System multi-role untuk pasien, dokter, dan admin.
Project ini adalah fondasi MVP yang dapat dijalankan tanpa kredensial backend,
dengan data demo yang terisolasi di repository sehingga mudah diganti REST API
atau Firebase.

## Yang sudah tersedia

- Login demo dan role-based navigation: Patient, Doctor, Admin
- Patient dashboard, pencarian/detail dokter, booking slot, QR check-in,
  antrean, chat preview, layanan, rekam medis, resep, dan profil
- Doctor dashboard, jadwal, antrean real-time simulation, diagnosis dan resep
- Admin dashboard responsif, KPI, analytics, dan appointment overview
- Material 3, adaptive layouts, Riverpod, GoRouter, feature-first structure
- Widget tests untuk splash, login, dan patient dashboard

## Menjalankan

```bash
flutter pub get
flutter run
```

Pilih role di halaman login. Email dan password sudah diisi untuk mode demo.

Base URL dapat diberikan tanpa mengubah source:

```bash
flutter run --dart-define=API_BASE_URL=https://api.your-hospital.id/v1
```

## Struktur

```text
lib/
  core/
    constants/ data/ network/ providers/ theme/
  features/
    admin/ appointment/ authentication/ doctor/
    medical_record/ patient/ profile/ splash/
  shared/
    models/ widgets/
```

## Integrasi production

1. Implementasikan `HmsApiContract` menggunakan Dio dan endpoint yang tersedia.
2. Simpan access/refresh token di `flutter_secure_storage`; jangan simpan token
   atau PII di log.
3. Tambahkan project Firebase per environment melalui FlutterFire CLI. File
   `firebase_options.dart`, `google-services.json`, dan `GoogleService-Info.plist`
   harus berasal dari project Firebase milik rumah sakit.
4. Gunakan Firestore untuk chat/queue, Cloud Storage untuk dokumen, dan FCM
   untuk appointment/queue/prescription notifications.
5. Enkripsi cache offline, terapkan RBAC di server, audit log immutable,
   automatic session timeout, certificate pinning, dan consent-based access.
6. Tambahkan unit/integration/golden tests serta security and compliance review
   sebelum menyimpan data pasien sungguhan.

## Endpoint contract

Dokumentasi pengembangan lengkap tersedia di [`docs/README.md`](docs/README.md).
Kontrak backend machine-readable berada di
[`docs/openapi.yaml`](docs/openapi.yaml), mencakup:

- authentication dan scoped RBAC;
- doctor/patient/department/schedule CRUD;
- appointment, check-in, dan queue state machine;
- encounter, medical record, diagnosis, dan prescription;
- invoice, payment webhook, refund, dan reconciliation;
- admin dashboard, pagination/filter/sort, concurrency, dan audit log.

Backend dan Flutter sebaiknya menghasilkan atau memvalidasi API client dari
OpenAPI tersebut agar perubahan contract terdeteksi di CI.

> Project ini memakai data fiktif. Jangan gunakan untuk keputusan klinis atau
> data pasien nyata sebelum backend, keamanan, dan compliance diimplementasikan.
