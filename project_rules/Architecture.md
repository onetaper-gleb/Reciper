# Reciper MVP — техническая структура

## 1. Библиотеки

### 1.1 Flutter: runtime dependencies

#### Базовый слой приложения
- `dio` — основной HTTP-клиент для запросов к backend. 
- `flutter_bloc` — основной state management для экранов и репозиториев; пакет прямо позиционируется как набор Flutter-виджетов для реализации BLoC-паттерна. 
- `equatable` — для корректного сравнения `Event` / `State` / моделей без ручного переопределения `==`. 

#### Локальное хранение
- `drift`
- `sqlite3_flutter_libs`
- `path_provider`

**Выбор локальной БД:** беру **Drift + SQLite**. Drift описывается как reactive persistence library for relational data в Dart/Flutter и построен поверх SQLite; для Reciper это хорошо подходит, потому что у нас много связанных сущностей: профиль, планы, дни, блюда, рецепты, ингредиенты, продукты холодильника, история сканов, список покупок, записи веса. Это архитектурная рекомендация, сделанная на основе свойств библиотеки. Для хранения фото и кешей файлов используем файловую систему приложения через `path_provider`, а метаданные путей — в Drift. 

#### Кодогенерация моделей
- `freezed_annotation`
- `json_annotation`

#### Flutter dev_dependencies для кодогенерации
- `build_runner`
- `freezed`
- `json_serializable`

`freezed` и `json_serializable` хорошо сочетаются друг с другом; `freezed` сам рекомендует ставить вместе с ним `json_annotation` и `json_serializable`, а Flutter docs отдельно рекомендуют `json_serializable` для генерации JSON-кода. Для проекта с большим количеством DTO и immutable-моделей это правильный стек. 

#### Голосовой режим и hands-free
- `speech_to_text` — для голосовых команд.
- `flutter_tts` — для озвучивания шагов рецепта.
- `flutter_foreground_task` — для foreground service в cooking mode.
- `flutter_local_notifications` — для локальных уведомлений, таймеров и действий из уведомления.

Важно: `speech_to_text` лишь “exposes device specific speech to text recognition capability”, то есть офлайн-работа голосовых команд зависит от конкретной ОС и установленных языковых пакетов. Поэтому модуль распознавания речи лучше сразу оборачивать в собственный `SpeechService`, чтобы при необходимости заменить реализацию без переписывания UI. TTS и сам режим foreground service для cooking mode подходят хорошо: `flutter_tts` дает локальное озвучивание, а `flutter_foreground_task` поддерживает foreground service и двустороннюю связь между сервисом и UI. Для уведомлений используем именно локальные уведомления, а не push; пакет `flutter_local_notifications` поддерживает notification actions. 

#### Камера и фото
- `camera` — для своего экрана камеры внутри приложения.
- `image_picker` — для загрузки фото из галереи и резервного сценария “сделать фото быстро”.
- `permission_handler` — камера, микрофон, уведомления.
- `path_provider` — пути для локального хранения фото холодильника.

`camera` подходит для кастомного UX сканера, а `image_picker` — для галереи и быстрого fallback-сценария; современные методы `image_picker` работают с `XFile`. Фото храним локально в директории приложения, найденной через `path_provider`. 

#### Служебные и UI
- `connectivity_plus` — отслеживание сети и переключение UI в offline-state.
- `intl` — даты, форматирование, локализация.
- `chat_bubbles` — **опционально**, только если экран генерации плана действительно останется чатоподобным.
- `flutter_native_splash`
- `flutter_launcher_icons`

Так как в твоем `main()` используется `FlutterNativeSplash.preserve()` / `remove()`, `flutter_native_splash` нужно держать в обычных dependencies, а не только в dev_dependencies. `flutter_launcher_icons` — наоборот, чисто tooling, его лучше держать в dev_dependencies. `connectivity_plus` дает API и стрим для отслеживания доступных типов соединения. 

### 1.2 Flutter: что считаем локально, без backend
В MVP **на клиенте**, без запроса на сервер, делаем:
- расчет BMR / дневной калорийности / КБЖУ;
- сбор списка покупок из уже сохраненного локально плана;
- хранение истории планов, истории сканов, холодильника, веса, настроек;
- таймеры готовки;
- TTS озвучивание шагов;
- локальные уведомления;
- offline reading уже сохраненных данных.

На backend отправляем только то, что действительно требует AI: генерация плана, замена блюда, AI-рецепты, распознавание содержимого холодильника по фото. Это архитектурное решение для MVP.

### 1.3 Отдельная важная оговорка по Gemini
Ты упоминал `Gemini 3.1 flash-lite`, но в актуальной официальной документации Google сейчас фигурирует модель `gemini-2.5-flash-lite`, а в разделе deprecations отдельно перечисляются жизненные циклы моделей и замены. Поэтому **модель нельзя хардкодить в коде** — выносим ее в backend config как `GEMINI_MODEL`. 

---

## 2. Структура Flutter проекта

```text
lib/
├── main.dart
│
├── app/
│   ├── app.dart
│   ├── dependencies.dart
│   ├── dependencies_scope.dart
│   └── routes.dart
│
├── core/
│   ├── constants/
│   │   ├── app_constants.dart
│   │   ├── storage_keys.dart
│   │   └── db_constants.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── app_colors.dart
│   │   └── app_text_styles.dart
│   ├── navigation/
│   │   └── app_route_names.dart
│   ├── errors/
│   │   ├── app_exception.dart
│   │   └── error_mapper.dart
│   └── utils/
│       ├── nutrition_calculator.dart
│       ├── validators.dart
│       ├── date_formatter.dart
│       └── extensions/
│           ├── context_ext.dart
│           └── date_ext.dart
│
├── data/
│   ├── local/
│   │   ├── db/
│   │   │   ├── app_database.dart
│   │   │   ├── converters/
│   │   │   │   ├── date_time_converter.dart
│   │   │   │   ├── meal_type_converter.dart
│   │   │   │   └── goal_converter.dart
│   │   │   ├── tables/
│   │   │   │   ├── profile_table.dart
│   │   │   │   ├── preferences_table.dart
│   │   │   │   ├── meal_plans_table.dart
│   │   │   │   ├── day_plans_table.dart
│   │   │   │   ├── meals_table.dart
│   │   │   │   ├── recipes_table.dart
│   │   │   │   ├── ingredients_table.dart
│   │   │   │   ├── shopping_items_table.dart
│   │   │   │   ├── fridge_products_table.dart
│   │   │   │   ├── fridge_scans_table.dart
│   │   │   │   ├── weight_entries_table.dart
│   │   │   │   └── settings_table.dart
│   │   │   └── daos/
│   │   │       ├── profile_dao.dart
│   │   │       ├── meal_plan_dao.dart
│   │   │       ├── recipe_dao.dart
│   │   │       ├── fridge_dao.dart
│   │   │       ├── shopping_list_dao.dart
│   │   │       ├── progress_dao.dart
│   │   │       └── settings_dao.dart
│   │   ├── file_storage/
│   │   │   ├── image_storage_service.dart
│   │   │   └── image_storage_paths.dart
│   │   └── source/
│   │       ├── profile_local_source.dart
│   │       ├── meal_plan_local_source.dart
│   │       ├── recipe_local_source.dart
│   │       ├── fridge_local_source.dart
│   │       ├── shopping_list_local_source.dart
│   │       ├── progress_local_source.dart
│   │       └── settings_local_source.dart
│   │
│   ├── remote/
│   │   ├── dto/
│   │   │   ├── common/
│   │   │   │   ├── nutrition_dto.dart
│   │   │   │   └── ingredient_dto.dart
│   │   │   ├── meal_plan/
│   │   │   │   ├── generate_meal_plan_request_dto.dart
│   │   │   │   ├── generate_meal_plan_response_dto.dart
│   │   │   │   └── replace_meal_request_dto.dart
│   │   │   ├── fridge/
│   │   │   │   ├── fridge_scan_response_dto.dart
│   │   │   │   └── recognized_product_dto.dart
│   │   │   └── recipe/
│   │   │       ├── recipe_suggestion_request_dto.dart
│   │   │       ├── recipe_suggestion_response_dto.dart
│   │   │       └── generated_recipe_dto.dart
│   │   ├── mappers/
│   │   │   ├── meal_plan_mapper.dart
│   │   │   ├── recipe_mapper.dart
│   │   │   ├── fridge_mapper.dart
│   │   │   └── shopping_list_mapper.dart
│   │   ├── source/
│   │   │   ├── meal_plan_remote_source.dart
│   │   │   ├── recipe_remote_source.dart
│   │   │   └── fridge_remote_source.dart
│   │   └── api/
│   │       ├── reciper_api.dart
│   │       ├── api_endpoints.dart
│   │       └── api_parser.dart
│   │
│   └── repository/
│       ├── profile_repository.dart
│       ├── meal_plan_repository.dart
│       ├── recipe_repository.dart
│       ├── fridge_repository.dart
│       ├── shopping_list_repository.dart
│       ├── progress_repository.dart
│       └── settings_repository.dart
│
├── domain/
│   ├── bloc/
│   │   ├── onboarding/
│   │   ├── profile/
│   │   ├── meal_plan/
│   │   ├── recipe/
│   │   ├── fridge/
│   │   ├── shopping_list/
│   │   ├── progress/
│   │   ├── cooking_mode/
│   │   └── plan_generation/
│   │
│   └── models/
│       ├── profile.dart
│       ├── user_preferences.dart
│       ├── nutrition.dart
│       ├── meal_plan.dart
│       ├── day_plan.dart
│       ├── meal.dart
│       ├── recipe.dart
│       ├── ingredient.dart
│       ├── shopping_item.dart
│       ├── fridge_product.dart
│       ├── fridge_scan.dart
│       ├── weight_entry.dart
│       ├── cooking_step.dart
│       └── enums/
│           ├── goal.dart
│           ├── gender.dart
│           ├── meal_type.dart
│           ├── activity_level.dart
│           ├── budget_level.dart
│           └── diet_type.dart
│
├── services/
│   ├── speech_service.dart
│   ├── tts_service.dart
│   ├── cooking_foreground_service.dart
│   ├── local_notification_service.dart
│   └── connectivity_service.dart
│
├── module/
│   ├── onboarding/
│   │   ├── onboarding_screen.dart
│   │   ├── onboarding_controller.dart
│   │   └── widgets/
│   ├── home/
│   │   ├── home_screen.dart
│   │   ├── home_controller.dart
│   │   └── widgets/
│   ├── recipe_detail/
│   │   ├── recipe_detail_screen.dart
│   │   ├── recipe_detail_controller.dart
│   │   └── widgets/
│   ├── profile/
│   │   ├── profile_screen.dart
│   │   ├── profile_controller.dart
│   │   └── widgets/
│   ├── fridge_scanner/
│   │   ├── fridge_scanner_screen.dart
│   │   ├── fridge_scanner_controller.dart
│   │   └── widgets/
│   ├── plan_generation/
│   │   ├── plan_generation_screen.dart
│   │   ├── plan_generation_controller.dart
│   │   └── widgets/
│   ├── cooking_mode/
│   │   ├── cooking_mode_screen.dart
│   │   ├── cooking_mode_controller.dart
│   │   └── widgets/
│   ├── shopping_list/
│   │   ├── shopping_list_screen.dart
│   │   ├── shopping_list_controller.dart
│   │   └── widgets/
│   └── recipes_catalog/
│       ├── recipes_catalog_screen.dart
│       ├── recipes_catalog_controller.dart
│       └── widgets/
│
└── widgets/
    ├── app_loader.dart
    ├── app_error_view.dart
    ├── app_bottom_nav_bar.dart
    └── app_empty_state.dart
```

### Примечания по Flutter-структуре
1. `main.dart` только:
   - инициализирует Flutter binding;
   - поднимает локальную БД;
   - создает `Dio`;
   - создает immutable repositories;
   - собирает их в `Dependencies`;
   - прокидывает через `DependenciesScope`;
   - поднимает корневые BLoC.

2. `Navigator` используем стандартный:
   - `routes.dart`
   - `app_route_names.dart`
   - `onGenerateRoute`

1. Репозитории интерфейсами не перегружаем. Если реализация реально одна и нет ожидаемой альтернативы — оставляем конкретный класс.

---

## 3. Библиотеки backend

### 3.1 Основные
- `fastapi` — основной web framework; в docs есть поддержка `UploadFile`, `File`, `Form`, `BackgroundTasks`, `CORSMiddleware`, а также официальный паттерн разбиения большого приложения через `APIRouter`. 
- `uvicorn[standard]` — ASGI web server для запуска FastAPI. 
- `pydantic` — валидация входных/выходных схем и нормализация данных. 
- `pydantic-settings` — конфиг приложения через environment variables и `.env`. 
- `httpx` — async HTTP client; для FastAPI-стека это уместно, потому что HTTPX отдельно поддерживает async client и прямо рекомендует его для async web frameworks. 
- `google-genai` — официальный Google Gen AI Python SDK для работы с Gemini через сервер. 
- `python-multipart` — нужен для `multipart/form-data`, то есть для загрузки фото холодильника вместе с текстовыми полями. 

### 3.2 Dev / quality
- `pytest` — тесты backend. 
- `ruff` — линтер/formatter. 

### 3.3 Что **не** нужно в MVP backend
Так как по твоему решению **все пользовательские данные хранятся локально на устройстве**, в MVP backend можно делать **stateless**:
- без PostgreSQL;
- без SQLAlchemy;
- без Alembic;
- без Redis;
- без Celery.

То есть сервер в MVP — это AI-orchestrator: принял контекст, сходил в Gemini, нормализовал ответ, вернул DTO.

---

## 4. Структура backend

FastAPI сам рекомендует для “bigger applications” разносить приложение по нескольким файлам и роутерам через `APIRouter`, поэтому ниже структура под это. 

```text
backend/
├── app/
│   ├── main.py
│   │
│   ├── api/
│   │   ├── router.py
│   │   └── v1/
│   │       ├── router.py
│   │       └── endpoints/
│   │           ├── health.py
│   │           ├── meal_plans.py
│   │           ├── recipes.py
│   │           └── fridge.py
│   │
│   ├── core/
│   │   ├── config.py
│   │   ├── exceptions.py
│   │   ├── logging.py
│   │   └── constants.py
│   │
│   ├── schemas/
│   │   ├── common.py
│   │   ├── meal_plan.py
│   │   ├── recipe.py
│   │   ├── fridge.py
│   │   └── health.py
│   │
│   ├── services/
│   │   ├── meal_plan_service.py
│   │   ├── recipe_service.py
│   │   ├── fridge_scan_service.py
│   │   └── ai/
│   │       ├── gemini_client.py
│   │       ├── prompt_builder.py
│   │       ├── prompt_loader.py
│   │       ├── response_parser.py
│   │       └── safety_rules.py
│   │
│   ├── prompts/
│   │   ├── meal_plan/
│   │   │   ├── system.txt
│   │   │   ├── generate.txt
│   │   │   └── replace_meal.txt
│   │   ├── recipes/
│   │   │   ├── suggest.txt
│   │   │   └── generate.txt
│   │   └── fridge/
│   │       └── scan.txt
│   │
│   └── utils/
│       ├── nutrition.py
│       ├── json_utils.py
│       └── image_utils.py
│
├── tests/
│   ├── api/
│   │   ├── test_health.py
│   │   ├── test_meal_plans.py
│   │   ├── test_recipes.py
│   │   └── test_fridge.py
│   └── services/
│       ├── test_meal_plan_service.py
│       ├── test_recipe_service.py
│       └── test_fridge_scan_service.py
│
├── Dockerfile
├── docker-compose.yml
├── pyproject.toml
├── .env.example
├── .dockerignore
└── README.md
```

### Примечания по backend-структуре
1. `app/main.py` — только сборка приложения, middleware, CORS, include_router.
2. В `schemas/` лежат только Pydantic-схемы.
3. В `services/` — бизнес-логика.
4. В `services/ai/` — все, что связано именно с Gemini:
   - создание клиента,
   - загрузка prompt templates,
   - сборка prompt,
   - парсинг и нормализация ответа.
5. `prompts/` храним отдельно от кода — так будет проще менять поведение AI без риска сломать Python-логику.
6. Так как backend stateless, клиент **всегда** передает полный контекст запроса:
   - профиль,
   - цель,
   - ограничения,
   - продукты,
   - текущий план / блюдо / день,
   - пожелания пользователя.

---

## 5. Эндпоинты

## 5.1 Обязательные для MVP

### `GET /api/v1/health`
Проверка, что backend жив.

**Response**
```json
{
  "status": "ok"
}
```

---

### `POST /api/v1/meal-plans/generate`
Генерация нового персонального плана питания.

**Request body**
```json
{
  "profile": {
    "gender": "male",
    "age": 25,
    "height_cm": 178,
    "weight_kg": 82,
    "target_weight_kg": 75,
    "goal": "weight_loss",
    "activity_level": "moderate"
  },
  "preferences": {
    "diet_type": "regular",
    "allergies": ["lactose_free"],
    "disliked_products": ["broccoli"],
    "favorite_products": ["chicken", "rice"],
    "max_cooking_time_min": 30,
    "budget_level": "medium"
  },
  "plan_options": {
    "days": 7,
    "meals_per_day": 5,
    "cook_when": "evening",
    "use_fridge_products": true
  },
  "fridge_products": [
    { "name": "chicken breast", "amount": 500, "unit": "g" },
    { "name": "rice", "amount": 300, "unit": "g" }
  ],
  "additional_notes": "По вторникам ем вне дома"
}
```

**Response**
```json
{
  "plan": {
    "start_date": "2026-04-06",
    "end_date": "2026-04-12",
    "days": []
  },
  "weekly_summary": {
    "avg_calories": 2150,
    "avg_protein_g": 150,
    "avg_fat_g": 70,
    "avg_carbs_g": 240
  }
}
```

---

### `POST /api/v1/meal-plans/replace-meal`
Замена одного блюда в уже существующем локальном плане.

**Request body**
```json
{
  "meal_type": "breakfast",
  "current_recipe": {
    "name": "Овсянка с бананом и мёдом",
    "calories": 380
  },
  "reason": "too_long_to_cook",
  "additional_info": "Не хочу овсянку",
  "day_context": {
    "remaining_calories": 1770,
    "remaining_protein_g": 138,
    "remaining_fat_g": 62,
    "remaining_carbs_g": 175
  },
  "preferences": {
    "disliked_products": ["oatmeal"],
    "max_cooking_time_min": 15
  },
  "fridge_products": [
    { "name": "eggs", "amount": 4, "unit": "pcs" },
    { "name": "bread", "amount": 1, "unit": "pack" }
  ]
}
```

**Response**
```json
{
  "recipe": {
    "name": "Омлет с тостами",
    "cooking_time_min": 10,
    "nutrition": {
      "calories": 360,
      "protein_g": 20,
      "fat_g": 18,
      "carbs_g": 28
    }
  }
}
```

---

### `POST /api/v1/recipes/suggest`
Подбор рецептов по фильтрам и/или продуктам из холодильника.

**Request body**
```json
{
  "query": "быстрый ужин",
  "filters": {
    "max_cooking_time_min": 20,
    "goal": "weight_loss",
    "diet_type": "regular"
  },
  "fridge_products": [
    { "name": "chicken breast" },
    { "name": "tomato" },
    { "name": "cucumber" }
  ]
}
```

**Response**
```json
{
  "recipes": [
    {
      "name": "Курица с салатом",
      "calories": 420,
      "cooking_time_min": 18
    }
  ]
}
```

---

### `POST /api/v1/recipes/generate`
Генерация одного полного рецепта по свободному описанию или ограничениям.

**Request body**
```json
{
  "prompt": "Сделай белковый завтрак без лактозы до 15 минут",
  "preferences": {
    "diet_type": "lactose_free"
  },
  "nutrition_target": {
    "calories": 400,
    "protein_g": 30
  }
}
```

**Response**
```json
{
  "recipe": {
    "name": "..."
  }
}
```

---

### `POST /api/v1/fridge/scan`
Распознавание продуктов по фото холодильника.

Для этого endpoint удобно использовать `multipart/form-data`: FastAPI поддерживает `UploadFile`, `File` и `Form`, в том числе одновременно в одном запросе. 

**Request**
- `image` — файл фото
- `existing_products_json` — опционально, JSON-строка со списком уже распознанных продуктов
- `scan_mode` — `replace` | `append`

**Response**
```json
{
  "recognized_products": [
    {
      "name": "Куриная грудка",
      "amount": 500,
      "unit": "g",
      "confidence": 0.92
    },
    {
      "name": "Молоко",
      "amount": 1,
      "unit": "l",
      "confidence": 0.87
    }
  ]
}
```

---

## 5.2 Что **не** выносим в backend в MVP

### Список покупок
**Отдельный endpoint не нужен.**

Список покупок в MVP лучше собирать **локально** из:
- текущего локального плана,
- ингредиентов рецептов,
- продуктов в холодильнике,
- флага “уже куплено / уже есть”.

Это позволит:
- смотреть список офлайн,
- не зависеть от backend,
- не гонять лишние запросы.

Если потом понадобится **оценка стоимости**, тогда можно будет добавить:

### `POST /api/v1/shopping-lists/estimate-cost` *(опционально позже)*

---

## 5.3 Итог по backend-роли в MVP
Backend в MVP отвечает только за:
- AI генерацию плана;
- AI замену блюда;
- AI генерацию / подбор рецептов;
- AI распознавание холодильника по фото.

Все остальное — храним и обслуживаем локально на устройстве.
