# Product Requirements

## Persona dan tujuan

### Pasien

Mendaftar, mencari dokter, melihat slot, membuat janji temu, check-in, memantau
antrean, membayar, berkonsultasi, menerima resep, dan mengakses rekam medis
miliknya.

### Dokter

Melihat jadwal dan antrean, membuka ringkasan pasien yang berhak diakses,
mencatat encounter, diagnosis, resep, dokumen, dan berkomunikasi dengan pasien.

### Admin dan staf

Mengelola master data serta operasi harian sesuai permission tanpa mendapatkan
akses klinis lebih luas dari yang dibutuhkan.

## Functional requirements

### Identity

- Email/password dan Google sign-in; MFA wajib untuk privileged role.
- Access token pendek, refresh token rotation, revoke per device.
- Account lockout bertahap, device/session list, password reset sekali pakai.
- User dapat memiliki satu atau lebih role dengan scope rumah sakit.

### Doctor discovery dan schedule

- Search nama/spesialis/departemen, filter rumah sakit, rating, dan availability.
- Slot diturunkan dari schedule, leave, appointment, dan capacity.
- Slot hold memiliki TTL agar dua pasien tidak dapat memesan slot yang sama.

### Appointment

- Status: `pending_payment`, `confirmed`, `checked_in`, `in_queue`,
  `in_consultation`, `completed`, `cancelled`, `no_show`.
- Reschedule dan cancel mengikuti policy serta menyimpan reason.
- Semua create/payment callback menggunakan idempotency key.

### Queue

- Nomor antrean unik per layanan, dokter, dan tanggal.
- Operator dapat call, recall, skip, restore, dan complete.
- Perubahan dikirim real-time dan memiliki monotonic version.

### Clinical

- Encounter dibuat ketika konsultasi dimulai.
- Diagnosis dapat berupa primary/secondary dan optional ICD code.
- Prescription memiliki medicine item, dose, frequency, route, duration, note.
- Medical record tidak di-hard-delete; koreksi membuat revision dan reason.
- Attachment disimpan private melalui signed URL berumur pendek.

### Payment

- Invoice dihitung server-side; client tidak menentukan total akhir.
- Webhook diverifikasi signature dan idempotent.
- Status: `pending`, `paid`, `failed`, `expired`, `refunded`,
  `partially_refunded`.

### Notification dan chat

- Notification preference per channel dan event.
- Chat hanya dapat dibuat berdasarkan appointment/doctor-patient relationship.
- Message memiliki sent/delivered/read state dan attachment scan.

### Admin dashboard

- CRUD mengikuti matriks pada `05-admin-crud.md`.
- Bulk import harus memiliki dry-run, row error report, dan approval.
- Export data sensitif memerlukan permission terpisah dan audit event.
- Dashboard metrics mengambil data agregat, bukan menghitung di client.

## Non-functional requirements

- API versioned di `/v1`; backward compatibility minimal satu versi aktif.
- Semua timestamp UTC ISO-8601; timezone presentasi berada di client.
- PostgreSQL sebagai source of truth, Redis untuk cache/lock/queue.
- Object storage private untuk dokumen.
- Soft delete untuk master/identity; append/revision untuk clinical record.
- RPO ≤ 15 menit dan RTO ≤ 4 jam pada MVP.
- Data tenant/hospital harus terisolasi di setiap query.

## Acceptance criteria MVP

1. Pasien hanya melihat data dirinya dan dependents yang telah diberikan akses.
2. Dokter hanya melihat pasien dengan relationship/appointment yang valid.
3. Admin dapat CRUD dokter, pasien, departemen, jadwal, appointment, dan payment
   sesuai role; seluruh perubahan tercatat.
4. Dua request bersamaan tidak dapat menghasilkan dua booking untuk slot sama.
5. Webhook pembayaran duplikat tidak menggandakan transaksi.
6. Rekam medis yang telah ditandatangani tidak dapat ditimpa atau dihapus.
7. List API memiliki pagination, filter, sort allowlist, dan tenant scope.
8. Error API konsisten serta tidak membocorkan stack trace atau PII.
