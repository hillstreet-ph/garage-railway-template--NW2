# Garage, S3-compatible object storage (https://garagehq.deuxfleurs.fr)
# Official image, pinned by version and digest.
FROM dxflrs/garage:v2.5.0@sha256:677e5b758e4425a325b811c425c026bf35a4bf42f7ddbaa773de3f4fd779a5a5

COPY garage.toml /etc/garage.toml

# 3900 = S3 API, 3901 = RPC (internal), 3903 = admin API and /health
EXPOSE 3900 3903

# --single-node creates the cluster layout on first boot.
# --default-bucket creates GARAGE_DEFAULT_ACCESS_KEY / GARAGE_DEFAULT_SECRET_KEY
# and GARAGE_DEFAULT_BUCKET if they don't exist yet (idempotent on restart).
CMD ["/garage", "server", "--single-node", "--default-bucket"]
