# Reciper MVP

Команда: **Гарри Поттер и дары вайбкодинга**

## Выбранное задание

Выбрано задание **№2**: `tasks/task-02-yandex-shad.md`  
Кейс: **Reciper — мобильный AI-ассистент питания, рецептов и готовки**.

## Состав команды

- Силова Дарья (`ctrl-vibe-25`) - captain
- Игнатова Алиса (`ctrl-vibe-13`) - member
- Синявский Глеб (`ctrl-vibe-26`) - member

## Что реализуется в проекте

- **Клиент (`src/client/`)**: Flutter-приложение Reciper (онбординг, план питания, рецепты, скан холодильника, профиль, cooking mode).
- **Бэкенд (`src/backend/`)**: FastAPI AI-orchestrator для генерации плана питания, замены блюда, подбора/генерации рецептов и распознавания продуктов на фото.
- **Документация (`docs/`, `project_rules/`)**: продуктовые и архитектурные спецификации.

## Архитектурные решения

- Flutter-клиент с разделением по слоям (app/core/data/domain/module/services/widgets), state management на BLoC.
- Локальное хранение пользовательских данных на устройстве (Drift + SQLite).
- Stateless backend на FastAPI; AI-функции через Gemini.
- Конфигурация backend через переменные окружения (`src/backend/.env`).

Подробнее: `project_rules/Architecture.md`, `project_rules/Screens.md`, `project_rules/Development plan.md`.

## Быстрый запуск backend

```bash
cp src/backend/.env.example src/backend/.env
docker compose up -d --build
```

Проверка:

- `http://localhost:8000/api/v1/health` -> `{"status":"ok"}`
- `http://localhost:8000/docs` -> Swagger UI

Полные воспроизводимые инструкции для оценщика: `DEPLOY.md`.

## Полезные файлы

- Регламент сдачи: `docs/submission-guide.md`
- Описание кейса: `tasks/task-02-yandex-shad.md`
- Данные команды: `team-info.json`