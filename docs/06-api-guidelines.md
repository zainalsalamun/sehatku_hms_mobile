# API Guidelines

## Base

- Base path: `/v1`
- Media type: `application/json`
- Timestamp: UTC RFC 3339, contoh `2026-07-28T08:30:00Z`
- ID: opaque UUID string; client tidak menebak struktur ID.
- Authentication: `Authorization: Bearer <access_token>`
- Correlation: client boleh mengirim `X-Request-Id`; server selalu mengembalikan.

## Success response

Single resource:

```json
{
  "data": {
    "id": "018f...",
    "type": "appointment",
    "status": "confirmed"
  },
  "meta": {
    "request_id": "req_..."
  }
}
```

List:

```json
{
  "data": [],
  "meta": {
    "page": { "number": 1, "size": 20, "total_items": 125, "total_pages": 7 },
    "request_id": "req_..."
  },
  "links": {
    "self": "/v1/admin/doctors?page[number]=1&page[size]=20",
    "next": "/v1/admin/doctors?page[number]=2&page[size]=20"
  }
}
```

## Error response

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Request tidak valid.",
    "details": [
      {
        "field": "starts_at",
        "reason": "Slot sudah tidak tersedia."
      }
    ],
    "request_id": "req_..."
  }
}
```

Kode umum:

- `400 VALIDATION_ERROR`
- `401 AUTHENTICATION_REQUIRED` / `TOKEN_EXPIRED`
- `403 PERMISSION_DENIED`
- `404 RESOURCE_NOT_FOUND`
- `409 RESOURCE_CONFLICT` / `INVALID_STATE_TRANSITION` /
  `VERSION_CONFLICT` / `SLOT_UNAVAILABLE`
- `422 BUSINESS_RULE_VIOLATION`
- `429 RATE_LIMITED`
- `500 INTERNAL_ERROR`
- `503 DEPENDENCY_UNAVAILABLE`

## Pagination, search, filter, sort

- `page[number]` mulai 1.
- `page[size]` default 20, maksimum 100.
- `search` untuk pencarian yang telah dinormalisasi.
- `filter[field]=value`; range memakai `filter[starts_at][gte]`.
- `sort=field,-other_field`; field harus di-allowlist.

## Idempotency

`POST` finansial/booking menerima `Idempotency-Key` UUID. Key terikat pada actor,
route, dan request hash minimal 24 jam. Reuse key dengan payload berbeda
mengembalikan `409 IDEMPOTENCY_KEY_REUSED`.

## Concurrency

Resource mutable memiliki integer `version`. Update menerima `If-Match` atau
field `version`. Stale update mengembalikan `409 VERSION_CONFLICT` dengan latest
version metadata.

## Security

- Rate limit per IP, actor, dan route risk.
- PII/PHI tidak muncul dalam URL, notification preview, log, atau metric label.
- Signed download URL berumur pendek dan tidak dapat di-cache publik.
- Admin export dijalankan sebagai asynchronous job, encrypted, expiring, dan
  audited.
- Swagger production tidak boleh membuka privileged operation tanpa auth.

## Versioning dan deprecation

Breaking change menggunakan versi base path baru. Deprecated field/endpoint
mengirim `Deprecation` dan `Sunset` header serta dicatat dalam changelog.

## Contract testing

- Lint `openapi.yaml` pada CI.
- Backend response diuji terhadap schema.
- Flutter API client dibuat atau divalidasi dari contract.
- Breaking change detector memblokir merge tanpa version bump.
