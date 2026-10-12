# Образ PostgreSQL 17 с уже загруженной демо-базой «Авиаперевозки» (Postgres Pro).
# Данные кладём не в /var/lib/postgresql/data (там VOLUME базового образа),
# а в отдельную папку — тогда они попадают внутрь образа.
FROM postgres:17

ARG DEMO_FILE=demo-20250901-2y.sql.gz
ARG DEMO_URL=https://edu.postgrespro.ru/${DEMO_FILE}

ENV PGDATA=/var/lib/postgresql/demo-data \
    POSTGRES_PASSWORD=demo

LABEL org.opencontainers.image.title="aviation-demo" \
      org.opencontainers.image.description="PostgreSQL 17 + демо-база «Авиаперевозки» (Postgres Pro), готова к работе" \
      org.opencontainers.image.licenses="MIT"

USER root
RUN apt-get update \
 && apt-get install -y --no-install-recommends curl ca-certificates \
 && rm -rf /var/lib/apt/lists/*
COPY NOTICE.md /NOTICE.md

USER postgres
# Дамп начинается с DROP DATABASE demo (без IF EXISTS), поэтому базу demo создаём заранее.
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN set -eux; \
    mkdir -p "$PGDATA"; \
    initdb -D "$PGDATA" -U postgres --encoding=UTF8 --locale=en_US.UTF-8 \
           --auth-local=trust --auth-host=scram-sha-256; \
    echo "host all all all scram-sha-256" >> "$PGDATA/pg_hba.conf"; \
    echo "listen_addresses = '*'" >> "$PGDATA/postgresql.conf"; \
    pg_ctl -D "$PGDATA" -w -t 600 \
      -o "-c listen_addresses='' -c fsync=off -c full_page_writes=off -c synchronous_commit=off -c maintenance_work_mem=1GB -c max_wal_size=8GB" \
      start; \
    psql -v ON_ERROR_STOP=1 -U postgres -d postgres \
      -c "ALTER USER postgres PASSWORD 'demo';" \
      -c "CREATE DATABASE demo;"; \
    curl -fsSL --retry 5 "$DEMO_URL" | gunzip -c | psql -v ON_ERROR_STOP=1 -q -U postgres -d postgres; \
    psql -v ON_ERROR_STOP=1 -U postgres -d postgres -c "ALTER DATABASE demo SET bookings.lang = 'ru';"; \
    psql -v ON_ERROR_STOP=1 -U postgres -d demo -c "VACUUM ANALYZE;"; \
    psql -U postgres -d demo -c "SELECT bookings.version();"; \
    pg_ctl -D "$PGDATA" -m fast -w stop

EXPOSE 5432
