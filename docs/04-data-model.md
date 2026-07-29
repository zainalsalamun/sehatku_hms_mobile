# Data Model

Semua primary key direkomendasikan UUID/UUIDv7. Semua tabel mutable memiliki
`created_at`, `created_by`, `updated_at`, `updated_by`, dan `version`. Entity
tenant-bound wajib memiliki `hospital_id`.

## Core relationships

```text
Hospital ──< Department ──< Doctor
Hospital ──< Patient
Doctor ──< DoctorSchedule
Doctor + Patient ──< Appointment ──0..1 QueueTicket
Appointment ──0..1 Encounter ──< Diagnosis
Encounter ──< Prescription ──< PrescriptionItem
Patient ──< MedicalDocument
Appointment ──0..1 Invoice ──< Payment
User ──< UserRole >── Role ──< RolePermission
User ──< AuditLog
```

## Entity dictionary

### Identity

- `users`: email, phone, password_hash/provider, status, last_login_at.
- `roles`: code, name, hospital_scoped.
- `permissions`: resource dan action (`doctors.read`, `doctors.create`).
- `user_roles`: user, role, hospital, effective_from/to.
- `sessions`: refresh token hash, device, IP metadata, expiry, revoked_at.

### Master data

- `hospitals`: code, name, timezone, address, status.
- `departments`: hospital, code, name, description, status.
- `doctors`: user, hospital, department, license_number, specialist,
  biography, experience_years, rating, status.
- `patients`: user, hospital, medical_record_number, birth_date, gender,
  blood_type, insurance, emergency contact, status.
- `doctor_schedules`: doctor, day/date, start/end, slot_minutes, capacity,
  location, active range.
- `doctor_leaves`: doctor, start/end, reason, approval status.

### Operations

- `slot_holds`: doctor, starts_at, expires_at, patient, idempotency_key.
- `appointments`: doctor, patient, starts_at, ends_at, reason, status,
  source, cancellation reason, version.
- `queue_tickets`: appointment, service_date, prefix, sequence, status,
  called_at, completed_at, version.
- `check_ins`: appointment, method, location, checked_in_at, actor.

### Clinical

- `encounters`: appointment, patient, doctor, started/ended, summary, status,
  signed_at, signed_by, revision.
- `vital_signs`: encounter, type, value, unit, measured_at.
- `diagnoses`: encounter, code, description, type, clinical_status.
- `allergies`: patient, substance, reaction, severity, verified_by.
- `prescriptions`: encounter, patient, doctor, status, issued_at.
- `prescription_items`: medicine, dosage, unit, route, frequency, duration,
  quantity, instruction.
- `medical_documents`: patient, encounter, category, object_key, mime_type,
  checksum, status.

Clinical record yang signed bersifat append-only. Koreksi membuat revision baru
dengan `supersedes_id` dan correction reason.

### Billing

- `invoices`: appointment, patient, subtotal, discount, tax, total, currency,
  status, due_at.
- `invoice_items`: invoice, code, description, quantity, unit_price, amount.
- `payments`: invoice, provider, provider_reference, amount, status, paid_at.
- `payment_events`: payment, external_event_id, payload_hash, received_at.
- `refunds`: payment, amount, reason, provider_reference, status.

### Communication dan governance

- `conversations`: appointment/patient/doctor, status.
- `messages`: conversation, sender, type, body/attachment, sent/delivered/read.
- `notifications`: user, event, title, redacted body, channel, status.
- `notification_preferences`: user, event, channel, enabled.
- `audit_logs`: actor, hospital, action, resource, resource_id, purpose,
  before/after diff yang sudah disanitasi, request_id, IP, timestamp.
- `idempotency_keys`: actor, route, key, request_hash, response, expires_at.
- `outbox_events`: aggregate, type, payload, available_at, processed_at.

## Critical constraints

- Unique: `(hospital_id, medical_record_number)`.
- Unique: `(doctor_id, starts_at)` untuk slot berkapasitas satu, atau capacity
  counter transactional untuk multi-capacity.
- Unique: `(appointment_id)` pada active queue ticket.
- Unique: `(provider, provider_reference)` dan webhook external event ID.
- Check: monetary amount tidak negatif.
- Foreign key klinis menggunakan restrict; tidak cascade delete.
- Soft delete master data menggunakan `deleted_at`; record tetap tidak muncul
  pada list default.

## Status transitions

### Appointment

```text
pending_payment -> confirmed -> checked_in -> in_queue
-> in_consultation -> completed
pending_payment/confirmed -> cancelled
confirmed -> no_show
```

### Queue

```text
waiting -> called -> serving -> completed
waiting/called -> skipped -> waiting
```

Transition lain wajib ditolak dengan `409 INVALID_STATE_TRANSITION`.
