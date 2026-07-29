# Security and Healthcare Data Baseline

Dokumen ini adalah baseline engineering, bukan pengganti asesmen legal dan
compliance yang berlaku pada organisasi serta lokasi operasional rumah sakit.

## Access control

- Deny by default dan least privilege.
- Permission diverifikasi di backend pada resource dan hospital scope.
- Clinical access membutuhkan treatment relationship atau consent yang valid.
- MFA untuk admin, dokter, cashier, dan support privileged.
- Support impersonation dilarang atau harus memakai break-glass yang time-bound,
  reason-required, notified, dan audited.

## Data protection

- TLS untuk transit; managed encryption/KMS untuk database, storage, dan backup.
- Password memakai Argon2id/bcrypt dengan parameter terukur.
- Refresh token disimpan sebagai hash dan dirotasi.
- Mobile token disimpan pada secure storage.
- Offline clinical cache diminimalkan, terenkripsi, dan dapat remote revoke.
- Secret dikelola secret manager, bukan `.env` yang di-commit.

## Logging dan audit

- Structured log menggunakan request ID, bukan nama/email/patient record.
- Log redaction untuk token, cookie, authorization, password, message, diagnosis.
- Security/clinical audit append-only dan memiliki retention policy.
- Alert untuk failed login spike, role change, bulk export, break-glass,
  webhook signature failure, dan unusual record access.

## API dan file

- Input schema strict, body size limit, MIME allowlist, malware scan.
- Object storage private; upload/download memakai signed URL singkat.
- PDF dibuat dari template yang mencegah injection.
- Webhook signature, timestamp tolerance, replay protection, idempotency.
- CORS production memakai origin allowlist.

## Privacy

- Tujuan penggunaan data harus eksplisit.
- Consent, withdrawal, correction, export, dan retention workflow didokumentasi.
- Analytics menggunakan aggregate/de-identified data bila memungkinkan.
- Production data tidak disalin ke development.
- Notification lock screen tidak memuat diagnosis, obat, atau hasil pemeriksaan.

## Release gates

- Threat model dan data flow review.
- Dependency/SAST/secret/container scan.
- Authorization integration tests untuk negative cases.
- Backup restore drill dan incident runbook.
- Penetration test sebelum general availability.
- Data protection/privacy assessment dan sign-off organisasi.
