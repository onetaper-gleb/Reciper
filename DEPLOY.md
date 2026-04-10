# DEPLOY.md

Этот файл содержит воспроизводимые команды запуска и проверки проекта в чистом окружении.

## Предусловия

- Docker установлен и запущен
- Docker Compose доступен как `docker compose`

## Подготовка окружения

Выполнять из корня репозитория:

```bash
cp src/backend/.env.example src/backend/.env
```

Если `cp` недоступна (Windows), используйте:

```powershell
Copy-Item src/backend/.env.example src/backend/.env
```

## Сборка и запуск

```bash
docker compose up -d --build
```

## Проверка, что сервис работает

1) Проверить, что контейнер поднят:

```bash
docker compose ps
```

2) Проверить health endpoint:

```bash
curl http://localhost:8000/api/v1/health
```

Ожидаемый ответ:

```json
{"status":"ok"}
```

3) Проверить доступность Swagger:

- URL: `http://localhost:8000/docs`
- Страница должна открываться без ошибок.

## Тесты и проверки через docker compose

```bash
docker compose exec backend pytest -q
```

Дополнительно (линт):

```bash
docker compose exec backend ruff check app tests
```

## Критерий "все работает"

- контейнер `backend` в статусе `Up`;
- `GET /api/v1/health` возвращает `{"status":"ok"}`;
- Swagger (`/docs`) открывается;
- `pytest` завершается без ошибок.

## Остановка и очистка

```bash
docker compose down -v
```
# DEPLOY.md

Этот файл содержит воспроизводимые команды запуска и проверки проекта в чистом окружении.

## Предусловия

- Docker установлен и запущен
- Docker Compose доступен как `docker compose`

## Подготовка окружения

Выполнять из корня репозитория:

```bash
cp backend/.env.example backend/.env
```

Если `cp` недоступна (Windows), используйте:

```powershell
Copy-Item backend/.env.example backend/.env
```

## Сборка и запуск

```bash
docker compose up -d --build
```

## Проверка, что сервис работает

1) Проверить, что контейнер поднят:

```bash
docker compose ps
```

2) Проверить health endpoint:

```bash
curl http://localhost:8000/api/v1/health
```

Ожидаемый ответ:

```json
{"status":"ok"}
```

3) Проверить доступность Swagger:

- URL: `http://localhost:8000/docs`
- Страница должна открываться без ошибок.

## Тесты и проверки через docker compose

```bash
docker compose exec backend pytest -q
```

Дополнительно (линт):

```bash
docker compose exec backend ruff check app tests
```

## Критерий "все работает"

- контейнер `backend` в статусе `Up`;
- `GET /api/v1/health` возвращает `{"status":"ok"}`;
- Swagger (`/docs`) открывается;
- `pytest` завершается без ошибок.

## Остановка и очистка

```bash
docker compose down -v
```
# Deploy.md

Этот файл содержит воспроизводимые команды запуска и проверки проекта в чистом окружении.

## Предусловия

- Docker установлен и запущен
- Docker Compose доступен как `docker compose`

## Подготовка окружения

Выполнять из корня репозитория:

```bash
cp backend/.env.example backend/.env
```

Если `cp` недоступна (Windows), просто скопируйте файл `backend/.env.example` в `backend/.env`.

## Сборка и запуск

```bash
docker compose -f backend/docker-compose.yml up -d --build
```

## Проверка, что сервис работает

1) Проверить, что контейнер поднят:

```bash
docker compose -f backend/docker-compose.yml ps
```

2) Проверить health endpoint:

```bash
curl http://localhost:8000/api/v1/health
```

Ожидаемый ответ:

```json
{"status":"ok"}
```

3) Проверить доступность Swagger:

- URL: `http://localhost:8000/docs`
- Страница должна открываться без ошибок.

## Тесты и проверки через docker compose

```bash
docker compose -f backend/docker-compose.yml exec backend pytest -q
```

Дополнительно (линт):

```bash
docker compose -f backend/docker-compose.yml exec backend ruff check app tests
```

## Критерий "все работает"

- контейнер `backend` в статусе `Up`;
- `GET /api/v1/health` возвращает `{"status":"ok"}`;
- Swagger (`/docs`) открывается;
- `pytest` завершается без ошибок.

## Остановка и очистка

```bash
docker compose -f backend/docker-compose.yml down -v
```
