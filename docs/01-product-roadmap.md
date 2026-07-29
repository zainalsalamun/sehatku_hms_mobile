# Product Roadmap

## Sasaran produk

Membangun ekosistem rumah sakit digital yang aman untuk tiga persona utama:
pasien, dokter, dan staf administrasi. Target MVP adalah alur janji temu lengkap
dari pencarian dokter sampai konsultasi selesai, termasuk pembayaran, antrean,
rekam medis, resep, dan audit operasional.

## Prioritas

- **P0 — wajib operasional:** authentication, RBAC, master data, dokter,
  pasien, jadwal, appointment, antrean, rekam medis, resep, dashboard CRUD,
  audit log.
- **P1 — meningkatkan layanan:** payment gateway, notifikasi, PDF report,
  QR check-in, chat, offline read cache.
- **P2 — ekspansi:** telekonsultasi, insurance claim, lab/radiology integration,
  pharmacy inventory, multi-hospital, advanced analytics.

## Delivery plan

### Fase 0 — Foundation (1 minggu)

- Repository strategy, environments dev/staging/prod, CI quality gates.
- Backend skeleton, PostgreSQL migration, Redis, object storage.
- OpenAPI validation dan generated API client.
- Observability, structured logging, correlation ID.

**Exit criteria:** aplikasi dan backend dapat deploy ke staging; migration,
health check, linter, unit test, dan secret management aktif.

### Fase 1 — Identity dan master data (2 minggu)

- Login, refresh/revoke token, forgot/reset password.
- RBAC: patient, doctor, admin, super_admin, receptionist, cashier.
- CRUD departments, doctors, doctor schedules, users.
- Patient registration, identity, insurance, emergency contact.

**Exit criteria:** admin dapat mengelola master data sesuai permission dan semua
mutasi menghasilkan audit log.

### Fase 2 — Appointment dan antrean (2 minggu)

- Doctor availability dan slot locking.
- Create/reschedule/cancel appointment.
- QR check-in, queue assignment, call/skip/recall/complete.
- Realtime queue via WebSocket/SSE dan fallback polling.

**Exit criteria:** tidak ada double booking; concurrent request tervalidasi;
pasien dapat menyelesaikan alur booking sampai dipanggil dokter.

### Fase 3 — Clinical workflow (2 minggu)

- Encounter/consultation, diagnosis, allergy, vital sign.
- Medical record timeline dan document attachment.
- Prescription, medicine item, dosage, instruction, PDF report.
- Doctor access dibatasi oleh relationship dan consent.

**Exit criteria:** rekam medis versioned, tidak dapat hard-delete, setiap read
dan write sensitif dapat diaudit.

### Fase 4 — Payment dan engagement (2 minggu)

- Invoice, payment initiation, webhook, refund.
- FCM/local notification dan preference.
- Chat doctor, attachment, delivery/read status.
- PDF receipt, prescription, dan visit summary.

**Exit criteria:** webhook idempotent; rekonsiliasi pembayaran tersedia;
notifikasi tidak membawa data medis sensitif di lock screen.

### Fase 5 — Reliability dan release (2 minggu)

- Offline cache terenkripsi dan background sync.
- Load, penetration, disaster recovery, dan restore drill.
- Accessibility, golden test, end-to-end test.
- Privacy impact assessment dan production readiness review.

**Exit criteria:** SLO staging tercapai, high severity findings ditutup,
rollback teruji, dan sign-off product/clinical/security tersedia.

## Definition of done tiap fitur

- Acceptance criteria dan edge case disetujui.
- OpenAPI, migration, RBAC, audit event, dan API test tersedia.
- Unit test business rules dan integration test database lulus.
- Flutter memiliki loading/empty/error/offline state.
- Metrics, log redaction, tracing, dan alert relevan tersedia.
- Dokumentasi operasional serta rollback plan diperbarui.

## KPI awal

- Booking success rate ≥ 98%.
- Double-booking rate = 0.
- P95 read API < 500 ms; P95 write API < 800 ms pada beban MVP.
- Queue update delivery < 3 detik.
- Payment reconciliation mismatch < 0,1%.
- Crash-free sessions ≥ 99,5%.
- Availability bulanan ≥ 99,9% setelah general availability.
