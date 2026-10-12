# Демо-база «Авиаперевозки» в Docker — для курса по SQL

Готовый образ PostgreSQL 17 с уже загруженной учебной базой
«Авиаперевозки» от Postgres Pro. Ничего не нужно скачивать и
импортировать вручную — база ставится одной командой.

## Запуск — одна команда

```
docker run -d --name sql-course -p 5432:5432 ramdosx/aviation-demo:3m
```

Нужен установленный Docker Desktop: https://www.docker.com/products/docker-desktop/

Первый запуск скачивает образ (~0,8 ГБ), дальше база стартует за секунды.

## Подключение

| Параметр | Значение |
|---|---|
| Host | `localhost` |
| Port | `5432` |
| Database | `demo` |
| User | `postgres` |
| Password | `demo` |

Строка подключения: `postgresql://postgres:demo@localhost:5432/demo`

Проверка, что всё работает:

```sql
SELECT bookings.version();
SELECT * FROM airports LIMIT 10;
```

Удобная программа для запросов — DBeaver Community: https://dbeaver.io/download/

## Управление контейнером

- Остановить: `docker stop sql-course`
- Запустить снова: `docker start sql-course`
- Удалить: `docker rm -f sql-course`
- Порт 5432 занят? Запустите с другим портом: `docker run -d --name sql-course -p 5433:5432 ramdosx/aviation-demo:3m` и подключайтесь к 5433.

## Варианты базы (теги)

| Тег | Данных | Размер образа |
|---|---|---|
| `3m` / `latest` | 3 месяца | ~0,8 ГБ |
| `6m` | 6 месяцев | ~1,5 ГБ |
| `1y` | 1 год | ~3 ГБ |
| `2y` | 2 года | ~5 ГБ |

Для курса достаточно `3m`. Образы мультиархитектурные (Intel/AMD и Apple Silicon).

## Лицензия и источник

Данные: демонстрационная база «Авиаперевозки» © Postgres Professional,
https://postgrespro.ru/education/demodb, лицензия MIT (см. `NOTICE.md`).
Скрипты сборки: MIT (см. `LICENSE`).
Образ сделан для бесплатного обучающего курса по SQL.
