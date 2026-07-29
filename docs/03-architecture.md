# System Architecture

## Target architecture

```text
Flutter Patient/Doctor/Admin
          |
      HTTPS / WSS
          |
 API Gateway / Load Balancer
          |
 Modular Backend Application
  ├─ Identity & RBAC
  ├─ Hospital Master Data
  ├─ Scheduling & Appointment
  ├─ Queue
  ├─ Clinical Record
  ├─ Prescription
  ├─ Billing & Payment
  ├─ Chat & Notification
  ├─ Reporting
  └─ Audit
      |       |       |
 PostgreSQL Redis Object Storage
          |
 Async Worker / Event Outbox
          |
 FCM, Email, Payment, Video
```

Gunakan modular monolith untuk MVP agar transaksi dan delivery sederhana.
Boundary modul tetap eksplisit sehingga modul berukuran besar dapat dipisahkan
menjadi service setelah ada kebutuhan skala yang terukur.

## Backend modules

| Modul | Tanggung jawab |
| --- | --- |
| Identity | User, credential, session, role, permission, MFA |
| Master Data | Hospital, department, doctor profile, patient profile |
| Scheduling | Schedule template, leave, slot generation, slot hold |
| Appointment | Booking, reschedule, cancel, check-in |
| Queue | Queue ticket dan state machine operasional |
| Clinical | Encounter, diagnosis, vital, medical record revision |
| Prescription | Prescription dan medicine instruction |
| Billing | Invoice, payment, webhook, refund, reconciliation |
| Communication | Conversation, message, notification, preference |
| Reporting | KPI aggregate dan export job |
| Audit | Immutable security dan business event |

## Request flow

1. Gateway menambahkan/menjaga `X-Request-Id` dan rate limit.
2. Backend memvalidasi JWT, hospital scope, permission, dan request schema.
3. Application service menjalankan business rule dan transaction.
4. Repository menulis database bersama outbox event dalam transaction sama.
5. Worker memproses outbox untuk FCM, email, WebSocket, storage, atau payment.
6. Response memakai envelope dan error format standar.

## Realtime

- Queue dan chat menggunakan WebSocket/SSE channel terautentikasi.
- Event minimal memiliki `event_id`, `type`, `aggregate_id`, `version`,
  `occurred_at`, dan `data`.
- Client menyimpan versi terakhir; gap memicu refresh REST.
- Reconnect memakai exponential backoff dengan jitter.

## Data consistency

- PostgreSQL adalah source of truth.
- Row lock/advisory lock untuk finalisasi slot dan antrean.
- Unique constraint mencegah double booking.
- Idempotency record menyimpan key, actor, route, request hash, dan response.
- Transactional outbox mencegah database commit tanpa event.
- Redis hanya cache/lock sementara; kehilangan Redis tidak boleh merusak data.

## Environments

| Environment | Data | Tujuan |
| --- | --- | --- |
| Local | Synthetic | Development |
| Dev | Synthetic | Shared integration |
| Staging | De-identified/synthetic | UAT, performance, security |
| Production | Real | Layanan rumah sakit |

Secret tidak boleh disimpan di repository. Setiap environment memiliki database,
bucket, Firebase project, signing key, dan payment credential terpisah.

## Suggested backend structure

```text
src/
  modules/
    identity/
    hospitals/
    doctors/
    patients/
    scheduling/
    appointments/
    queues/
    clinical/
    prescriptions/
    billing/
    communication/
    reporting/
    audit/
  shared/
    auth/ database/ errors/ events/ observability/ validation/
migrations/
tests/
  unit/ integration/ contract/ e2e/
openapi/
```

Stack backend dapat menggunakan NestJS, Spring Boot, .NET, Go, atau FastAPI
selama mengikuti OpenAPI, state machine, transaction, permission, dan audit rule
yang sama.
