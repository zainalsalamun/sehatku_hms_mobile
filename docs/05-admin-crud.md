# Admin Dashboard CRUD

## Roles

- `super_admin`: konfigurasi lintas hospital dan role assignment.
- `hospital_admin`: master data dan operasi satu hospital.
- `receptionist`: patient, appointment, check-in, dan queue.
- `doctor`: schedule sendiri dan clinical workflow.
- `cashier`: invoice, payment verification, dan refund sesuai approval.
- `auditor`: read-only report dan audit log.
- `patient`: resource milik sendiri.

Backend wajib memeriksa permission; menyembunyikan tombol di dashboard bukan
mekanisme keamanan.

## CRUD matrix

| Resource | List/View | Create | Update | Delete/Deactivate | Catatan |
| --- | --- | --- | --- | --- | --- |
| Hospital | Super admin | Super admin | Super admin | Deactivate | Tidak hard-delete |
| Department | Admin | Admin | Admin | Deactivate | Tolak bila masih direferensikan |
| Doctor | Admin/receptionist | Admin | Admin/doctor terbatas | Deactivate | License unik |
| Doctor schedule | Admin/doctor | Admin/doctor | Admin/doctor | Cancel | Cek konflik appointment |
| Patient | Scoped staff/self | Receptionist/self | Scoped staff/self | Deactivate | Merge perlu approval |
| Appointment | Scoped actor | Patient/staff | Patient/staff | Cancel | State machine |
| Queue | Scoped staff/doctor | System/check-in | Staff/doctor | Void | Semua action audited |
| Encounter | Relationship | Doctor | Doctor sebelum signed | Tidak | Signed append-only |
| Prescription | Relationship | Doctor | Doctor sebelum issued | Void | Reason wajib |
| Invoice | Cashier/admin/self read | System/cashier | Cashier | Void | Total server-side |
| Payment | Cashier/admin/self read | Provider/cashier | Webhook/system | Refund | Tidak dihapus |
| User/role | Admin | Admin | Admin | Revoke/deactivate | MFA privileged |
| Audit log | Auditor/admin | System | Tidak | Tidak | Immutable |

## Dashboard screens

### Doctors

- Table: name, license, department, schedule today, status, rating.
- Filter: query, department, status, available date.
- Actions: add, view, edit, activate/deactivate, manage schedule.
- Form validation: license unique, department active, user email unique.

### Patients

- Table: MRN, name, birth date, contact, insurance, last visit, status.
- Actions: register, view, edit demographic, manage insurance, deactivate.
- Sensitive action: merge duplicate patient dan export memerlukan permission
  khusus serta second confirmation.

### Appointments

- Calendar dan table view dengan doctor/patient/status/date filters.
- Actions: create, reschedule, cancel, check-in, assign queue.
- Conflict response harus menampilkan slot alternatif dari backend.

### Queue

- Realtime board per department/doctor.
- Actions: call, recall, start, complete, skip, restore.
- Optimistic update membawa `version`; `409` memicu refresh.

### Billing

- Invoice list, payment status, reconciliation, refund request.
- Refund di atas threshold membutuhkan maker-checker approval.
- Dashboard tidak pernah mengubah status menjadi paid tanpa verified provider
  event atau authorized manual settlement.

### User dan role

- Invite user, assign scoped role, revoke session, reset MFA.
- Role assignment privileged menghasilkan security notification dan audit log.

## List contract

Setiap table menggunakan server-side pagination:

```text
GET /v1/admin/doctors?page[number]=1&page[size]=20
  &filter[status]=active&filter[department_id]=...
  &sort=-created_at&search=maya
```

Response mengembalikan `data`, `meta.page`, dan `links`. Sort/filter hanya boleh
menggunakan allowlist untuk mencegah query yang tidak terkontrol.

## Mutation UX

1. Form menampilkan validasi client untuk respons cepat.
2. Backend tetap menjadi validator final.
3. Create membutuhkan `Idempotency-Key`.
4. Update membawa `If-Match`/`version` untuk optimistic concurrency.
5. Delete adalah deactivate/cancel/void sesuai resource.
6. Success menampilkan request/reference ID.
7. Conflict menampilkan alasan dan tombol refresh.

## Audit event minimum

`actor_id`, `actor_role`, `hospital_id`, `action`, `resource_type`,
`resource_id`, `purpose`, sanitized change set, `request_id`, timestamp, IP,
dan device/user agent. Password, token, full payment credential, serta isi pesan
medis tidak masuk audit diff.
