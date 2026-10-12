# Демо-база «Авиаперевозки» в Docker — для бесплатного курса по SQL

Готовый образ PostgreSQL 17 с уже загруженной учебной базой
«Авиаперевозки» от Postgres Pro. Ничего не нужно скачивать и импортировать вручную.

## Запуск — одна команда
```
docker run -d --name sql-course -p 5432:5432 ramdosx/aviation-demo:2y
```
Нужен установленный Docker Desktop: https://www.docker.com/products/docker-desktop/
Образ большой (база за 2 года), первое скачивание займёт время.

## Подключение
| Параметр | Значение |
|---|---|
| Host | `localhost` |
| Port | `5432` |
| Database | `demo` |
| User | `postgres` |
| Password | `demo` |

Строка подключения: `postgresql://postgres:demo@localhost:5432/demo`
Удобная программа для запросов — DBeaver Community: https://dbeaver.io/download/

Проверка:
```sql
SELECT bookings.version();
SELECT * FROM airports LIMIT 10;
```

## Управление
- Остановить: `docker stop sql-course`
- Запустить снова: `docker start sql-course`
- Удалить: `docker rm -f sql-course`
- Порт 5432 занят? Запускайте с `-p 5433:5432` и подключайтесь к порту 5433.

## Теги
- `2y` / `latest` — база за 2 года (~11 ГБ)
- при необходимости могут появиться `1y`, `6m`, `3m`

## Лицензия и источник
Данные: демонстрационная база «Авиаперевозки» © Postgres Professional,
https://postgrespro.ru/education/demodb, лицензия MIT (см. `NOTICE.md`).
Скрипты сборки: MIT (см. `LICENSE`).
Образ сделан для бесплатного обучающего курса по SQL.
