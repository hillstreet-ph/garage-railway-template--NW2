[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/garage?utm_medium=integration&utm_source=button&utm_campaign=garage)

# Garage on Railway

A Railway template for [Garage](https://garagehq.deuxfleurs.fr), the lightweight, open-source (AGPL-3.0) S3-compatible object store from Deuxfleurs. It adds S3 storage to a project you already run on Railway, reachable over the private network.

**Version:** Garage v2.5.0, built from the official image `dxflrs/garage:v2.5.0@sha256:677e5b758e4425a325b811c425c026bf35a4bf42f7ddbaa773de3f4fd779a5a5` (see `Dockerfile`).

## What it deploys

One service, `Garage`, built from this repo:

- Garage in single-node mode (`replication_factor = 1`), SQLite metadata, config in `garage.toml`.
- A volume at `/var/lib/garage` (metadata, data blocks and metadata snapshots every 6 hours).
- S3 API on port `3900`: private at `http://garage.railway.internal:3900`, public through the Railway domain (HTTPS).
- Admin API on port `3903` (private only). Railway's health check calls `/health` on it.
- On first boot Garage creates an access key (with permission to create buckets) and one bucket, from the variables below. Later boots reuse them.

## Variables

| Variable | Default | Purpose |
|---|---|---|
| `GARAGE_DEFAULT_ACCESS_KEY` | `GK` + 24 random hex chars | Access key ID created on first boot |
| `GARAGE_DEFAULT_SECRET_KEY` | 64 random hex chars | Its secret key |
| `GARAGE_DEFAULT_BUCKET` | `default` | Bucket created on first boot, owned by that key |
| `GARAGE_RPC_SECRET` | 64 random hex chars | Garage's internal RPC secret |
| `GARAGE_ADMIN_TOKEN` | random | Bearer token for the admin API |
| `GARAGE_METRICS_TOKEN` | random | Bearer token for `/metrics` |
| `PORT` | `3903` | Port of the health check (admin API) |
| `S3_REGION`, `S3_ENDPOINT_PRIVATE`, `S3_ENDPOINT_PUBLIC` | derived | Read-only helpers for other services to reference |

Don't change `GARAGE_DEFAULT_SECRET_KEY` after the first boot: Garage refuses to start when the stored key has a different secret. To rotate keys, create a new key through the admin API.

## Connect your other services

In the service that needs storage, add:

```env
S3_ENDPOINT=${{Garage.S3_ENDPOINT_PRIVATE}}
S3_REGION=${{Garage.S3_REGION}}
S3_BUCKET=${{Garage.GARAGE_DEFAULT_BUCKET}}
AWS_ACCESS_KEY_ID=${{Garage.GARAGE_DEFAULT_ACCESS_KEY}}
AWS_SECRET_ACCESS_KEY=${{Garage.GARAGE_DEFAULT_SECRET_KEY}}
```

Use path-style addressing (`forcePathStyle: true` in the AWS SDK for JavaScript, `addressing_style = path` in boto3). The region is `garage`.

## Updates

This template builds from this repo. When the pinned Garage version changes here, Railway shows an "update available" notice in projects deployed from the template, and you choose when to apply it. Read `CHANGELOG.md` first: Garage major versions can need a manual migration step.

## Links

- Garage docs: https://garagehq.deuxfleurs.fr/documentation/quick-start/
- Releases: https://git.deuxfleurs.fr/Deuxfleurs/garage/releases
- Source (upstream): https://git.deuxfleurs.fr/Deuxfleurs/garage
