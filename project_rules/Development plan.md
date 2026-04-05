# Reciper MVP — декомпозиция задач

---

## Задача 1. Инициализация Flutter-проекта и базовая инфраструктура

### Что сделать
- Настроить структуру папок по `docs/architecture_mvp.md` (все папки, пустые файлы-заглушки не нужны — только каркас).
- Настроить `pubspec.yaml` со всеми зависимостями из раздела 1 документа архитектуры.
- Настроить `flutter_native_splash` и `flutter_launcher_icons` (временные placeholder-иконки).
- Создать `core/theme/app_theme.dart`, `app_colors.dart`, `app_text_styles.dart` — базовая тема приложения (цветовая схема, типографика, отступы).
- Создать `core/constants/app_constants.dart`.
- Создать `app/app.dart` с `MyApp` — `MaterialApp` с темой.
- Создать `app/dependencies.dart` — класс `Dependencies` (пока пустой, поля будут добавляться по мере появления репозиториев).
- Создать `app/dependencies_scope.dart` — `InheritedWidget`.
- Создать `main.dart` — инициализация binding, пустой `Dependencies`, запуск `MyApp`.
- Создать `widgets/app_bottom_nav_bar.dart` — нижний таб-бар с четырьмя вкладками (Главная, Сканер, Рецепты, Профиль), навигация через `Navigator`.
- Создать экраны-заглушки для каждой вкладки (`home_screen.dart`, `fridge_scanner_screen.dart`, `recipes_catalog_screen.dart`, `profile_screen.dart`) — просто `Scaffold` с заголовком.
- Настроить навигацию: `app/routes.dart` — переключение между вкладками работает.

### Как тестировать
- `flutter run` — приложение запускается без ошибок.
- Отображается сплеш-экран, затем главный экран с нижним таб-баром.
- Переключение между четырьмя вкладками работает, каждая показывает свой заголовок.
- Тема применяется (цвета, шрифты видны на заглушках).
- `flutter analyze` — ноль ошибок и предупреждений.

---

## Задача 2. Локальная БД (Drift) — схема и инициализация

### Что сделать
- Написать unit-тест: вставить план → день → блюдо → рецепт → ингредиенты, прочитать по FK — связи работают.
- Подключить `drift`, `sqlite3_flutter_libs`, `path_provider`, `drift_dev` (dev).
- Создать `data/local/db/app_database.dart` — класс базы данных.
- Создать таблицы в `data/local/db/tables/`:
  - `profile_table.dart` — имя, пол, возраст, рост, вес, целевой вес, цель, уровень активности.
  - `preferences_table.dart` — аллергии (текст через запятую или JSON), нелюбимые продукты, любимые продукты, макс. время готовки, бюджет, тип диеты.
  - `meal_plans_table.dart` — id, дата начала, дата конца, цель, активен (bool), дата создания.
  - `day_plans_table.dart` — id, FK на meal_plan, дата.
  - `meals_table.dart` — id, FK на day_plan, тип приёма пищи (enum), время, FK на recipe, выполнено (bool).
  - `recipes_table.dart` — id, название, время готовки, сложность, порции, калории, белки, жиры, углеводы, избранное (bool), шаги (JSON-текст).
  - `ingredients_table.dart` — id, FK на recipe, название, количество, единица, категория.
  - `fridge_products_table.dart` — id, название, количество, единица, категория, дата добавления.
  - `fridge_scans_table.dart` — id, путь к фото, дата, количество продуктов.
  - `shopping_items_table.dart` — id, FK на meal_plan, название, количество, единица, категория, куплено (bool), в холодильнике (bool).
  - `weight_entries_table.dart` — id, вес, дата.
- Создать конвертеры в `data/local/db/converters/` для enum-полей.
- Создать DAO в `data/local/db/daos/` — по одному на логическую группу таблиц (profile_dao, meal_plan_dao, recipe_dao, fridge_dao, shopping_list_dao, progress_dao). Каждый DAO — минимальный набор: insert, getAll/getById, update, delete.
- Запустить `build_runner` — убедиться, что `.g.dart` генерируется без ошибок.
- В `main.dart` инициализировать `AppDatabase`, передать в `Dependencies`.

### Как тестировать
- `flutter pub run build_runner build` проходит без ошибок.
- В `main.dart` создаётся экземпляр `AppDatabase` — приложение запускается.
- Написать unit-тест: создать in-memory базу, вставить запись профиля, прочитать — данные совпадают.
- Проверить, что при повторном запуске приложения данные сохраняются (hot restart не стирает БД).

---

## Задача 3. Domain-модели (freezed) и маппинг

### Что сделать
- Написать unit-тесты из "Как тестировать".
- Создать все модели в `domain/models/` с `@freezed`:
  - `profile.dart`, `user_preferences.dart`, `nutrition.dart`, `meal_plan.dart`, `day_plan.dart`, `meal.dart`, `recipe.dart`, `ingredient.dart`, `shopping_item.dart`, `fridge_product.dart`, `fridge_scan.dart`, `weight_entry.dart`, `cooking_step.dart`.
- Создать enums в `domain/models/enums/`: `goal.dart`, `gender.dart`, `meal_type.dart`, `activity_level.dart`, `budget_level.dart`, `diet_type.dart`, `difficulty.dart`, `replace_reason.dart`.
- Для каждой модели — `fromJson` / `toJson` через `json_serializable`.
- Создать `core/utils/nutrition_calculator.dart` — функции расчёта BMR (Mifflin-St Jeor), TDEE, целевых КБЖУ в зависимости от цели. Чистые функции, без зависимостей.
- Запустить `build_runner` — всё генерируется.

### Как тестировать
- `build_runner build` проходит без ошибок.
- Unit-тест: создать `Profile`, сериализовать в JSON, десериализовать обратно — `==` true (equatable через freezed).
- Unit-тест: `NutritionCalculator` — мужчина 25 лет, 178 см, 82 кг, средняя активность, цель похудение → калории в диапазоне 1900–2200 (проверить по формуле вручную).
- Unit-тест: `copyWith` работает на всех моделях.

---

## Задача 4. Репозитории и local sources для профиля и настроек

### Что сделать
- Создать `data/local/source/profile_local_source.dart` — обёртка над `ProfileDao`:
  - `saveProfile(Profile)`
  - `getProfile() → Profile?`
  - `updateProfile(Profile)`
  - `hasProfile() → bool`
- Создать `data/local/source/settings_local_source.dart` — обёртка над `SettingsDao` (или просто SharedPreferences / Drift):
  - Хранение: тема, единицы измерения, флаг «онбординг пройден», настройки уведомлений.
- Создать `data/repository/profile_repository.dart`:
  - `saveProfile`, `getProfile`, `updateProfile`, `hasCompletedOnboarding`.
- Создать `data/repository/settings_repository.dart`.
- Добавить оба репозитория в `Dependencies`, инициализировать в `main.dart`.
- Создать `domain/bloc/profile/` — `ProfileBloc`, `ProfileEvent`, `ProfileState`:
  - Events: `ProfileLoadRequested`, `ProfileUpdated`.
  - States: `ProfileInitial`, `ProfileLoaded(profile)`, `ProfileError`.
- Добавить `ProfileBloc` в корень приложения (над `MyApp` или внутри `DependenciesScope`).

### Как тестировать
- Unit-тест: `ProfileRepository` — сохранить профиль, прочитать — совпадает.
- Unit-тест: `ProfileBloc` — отправить `ProfileLoadRequested` при пустой БД → состояние `ProfileInitial`; сохранить профиль, отправить `ProfileLoadRequested` → `ProfileLoaded`.
- В приложении: при запуске BLoC пытается загрузить профиль, если нет — остаёмся на «пустом» состоянии (пока без UI-реакции).

---

## Задача 5. Экран онбординга

### Что сделать
- Создать `module/onboarding/onboarding_screen.dart` — `PageView` с шагами.
- Создать `module/onboarding/onboarding_controller.dart` — `InheritedWidget`, хранит `PageController`, текущий шаг, собранные данные.
- Создать `domain/bloc/onboarding/` — `OnboardingBloc`:
  - Хранит промежуточные данные всех шагов (имя, пол, возраст, рост, вес, цель, активность, аллергии).
  - Events: `OnboardingStepCompleted(step, data)`, `OnboardingFinished`.
  - При `OnboardingFinished` — считает КБЖУ через `NutritionCalculator`, сохраняет профиль через `ProfileRepository`, ставит флаг «онбординг пройден».
- Создать виджеты в `module/onboarding/widgets/`:
  - `onboarding_progress_bar.dart` — прогресс-бар сверху.
  - `step_welcome.dart` — приветственный экран с кнопкой «Начнём».
  - `step_name.dart` — текстовое поле имени.
  - `step_gender.dart` — два варианта.
  - `step_age.dart` — числовой ввод.
  - `step_body.dart` — рост и вес (два поля, тип double).
  - `step_goal.dart` — карточки с иконками.
  - `step_activity.dart` — варианты выбора.
  - `step_allergies.dart` — мульти-выбор чипсами + поле «другое».
  - `step_result.dart` — финальный экран с рассчитанной нормой и кнопками.
- В `main.dart` / `app.dart` — если `hasCompletedOnboarding == false`, показывать `OnboardingScreen`, иначе — главный экран с таб-баром.
- Анимированные переходы между шагами (slide-in через `PageView`).
- Кнопка «Назад» на каждом шаге (кроме первого).
- Валидация: имя не пустое, возраст 10–120, рост 50–250, вес 20–300.

### Как тестировать
- Первый запуск приложения → отображается онбординг.
- Пройти все шаги последовательно — ввод работает, переходы анимированы, прогресс-бар заполняется.
- Нажать «Назад» на шаге 4 → вернуться на шаг 3, данные сохранены.
- На финальном экране отображается имя пользователя и рассчитанная калорийность.
- Нажать «Составить план» или «Пропустить» → переход на главный экран с таб-баром.
- Перезапуск приложения → онбординг НЕ показывается, сразу главный экран.
- Проверить валидацию: пустое имя → нельзя перейти далее; вес 0 → ошибка.

---

## Задача 6. Backend — каркас FastAPI + Docker

### Что сделать
- Создать папку `backend/` со структурой из раздела 4 документа архитектуры.
- `pyproject.toml` со всеми зависимостями (fastapi, uvicorn, pydantic, pydantic-settings, httpx, google-genai, python-multipart, pytest, ruff).
- `app/core/config.py` — `Settings` через `pydantic-settings`:
  - `GEMINI_API_KEY`
  - `GEMINI_MODEL` (дефолт — актуальная модель, не хардкод)
  - `CORS_ORIGINS`
  - `LOG_LEVEL`
- `app/main.py` — создание FastAPI app, CORS middleware, подключение роутеров.
- `app/api/router.py` — корневой роутер, подключает `v1/router.py`.
- `app/api/v1/router.py` — подключает endpoint-модули.
- `app/api/v1/endpoints/health.py` — `GET /api/v1/health` → `{"status": "ok"}`.
- `Dockerfile` — multi-stage build, python 3.12, установка зависимостей, запуск uvicorn.
- `docker-compose.yml` — один сервис `backend`, проброс порта, передача `.env`.
- `.env.example` — шаблон переменных окружения.
- `app/core/logging.py` — базовая настройка логирования.
- `app/core/exceptions.py` — кастомные exception handlers для FastAPI (AIServiceError, ValidationError).

### Как тестировать
- `docker-compose up --build` — контейнер поднимается без ошибок.
- `curl http://localhost:8000/api/v1/health` → `{"status": "ok"}`.
- `curl http://localhost:8000/docs` → Swagger UI открывается.
- `pytest` — тест на health endpoint проходит.
- Переменные из `.env` подтягиваются в `config.py` (проверить через лог при старте).

---

## Задача 7. Backend — Gemini-клиент и система промптов

### Что сделать
- Создать `app/services/ai/gemini_client.py`:
  - Инициализация клиента `google-genai` с ключом из конфига.
  - Метод `generate_text(prompt: str, system_instruction: str) → str` — отправка текстового запроса.
  - Метод `generate_with_image(prompt: str, image_bytes: bytes, system_instruction: str) → str` — для сканирования холодильника.
  - Обработка ошибок: таймаут, rate limit, невалидный ответ → кастомные исключения.
  - Retry-логика (1–2 повтора при 5xx).
- Создать `app/services/ai/prompt_loader.py`:
  - Загрузка `.txt` шаблонов из папки `prompts/`.
  - Подстановка переменных через `str.format()` или `string.Template`.
- Создать `app/services/ai/prompt_builder.py`:
  - Метод `build_meal_plan_prompt(profile, preferences, plan_options, fridge_products, notes) → (system, user)`.
  - Метод `build_replace_meal_prompt(current_meal, reason, day_context, preferences, fridge) → (system, user)`.
  - Метод `build_fridge_scan_prompt(existing_products) → (system, user)`.
  - Метод `build_recipe_suggest_prompt(query, filters, fridge_products) → (system, user)`.
- Создать `app/services/ai/response_parser.py`:
  - Парсинг текстового ответа Gemini в Pydantic-схемы.
  - AI отвечает в JSON → парсер валидирует через Pydantic.
  - Fallback: если JSON невалидный → retry с уточняющим промптом или ошибка.
- Создать `app/services/ai/safety_rules.py`:
  - Конфигурация safety settings для Gemini (блокировка вредного контента).
- Заполнить начальные промпты в `prompts/`:
  - `meal_plan/system.txt` — системная инструкция (ты нутрициолог, отвечаешь JSON).
  - `meal_plan/generate.txt` — шаблон генерации плана.
  - `meal_plan/replace_meal.txt` — шаблон замены блюда.
  - `fridge/scan.txt` — инструкция для распознавания продуктов.
  - `recipes/suggest.txt` — подбор рецептов.

### Как тестировать
- Unit-тест (мок): `prompt_builder` собирает корректный промпт из входных данных — проверить, что все поля пользователя присутствуют в тексте.
- Unit-тест (мок): `response_parser` — подать валидный JSON → получить Pydantic-объект; подать невалидный → получить ошибку.
- Интеграционный тест (нужен ключ API): `gemini_client.generate_text` с простым промптом → получить непустой ответ.
- Ручной тест: запустить backend, отправить промпт генерации плана через Swagger → получить JSON с планом, проверить структуру.

---

## Задача 8. Backend — эндпоинты генерации плана и замены блюда

### Что сделать
- Создать Pydantic-схемы в `app/schemas/`:
  - `common.py` — `NutritionSchema`, `IngredientSchema`, `CookingStepSchema`.
  - `meal_plan.py` — `GeneratePlanRequest`, `GeneratePlanResponse`, `ReplaceMealRequest`, `ReplaceMealResponse`, `ProfileSchema`, `PreferencesSchema`, `PlanOptionsSchema`, `DayPlanSchema`, `MealSchema`, `RecipeSchema`.
- Создать `app/services/meal_plan_service.py`:
  - `generate_plan(request: GeneratePlanRequest) → GeneratePlanResponse`:
    - Собирает промпт через `prompt_builder`.
    - Вызывает `gemini_client.generate_text`.
    - Парсит ответ через `response_parser`.
    - Валидирует КБЖУ (сумма блюд дня примерно равна целевой калорийности ± 10%).
  - `replace_meal(request: ReplaceMealRequest) → ReplaceMealResponse`:
    - Аналогично: промпт → Gemini → парсинг → валидация.
- Создать `app/api/v1/endpoints/meal_plans.py`:
  - `POST /api/v1/meal-plans/generate` → `meal_plan_service.generate_plan`.
  - `POST /api/v1/meal-plans/replace-meal` → `meal_plan_service.replace_meal`.
  - Error handling: 422 (validation), 502 (AI error), 504 (timeout).

### Как тестировать
- `pytest`: тест с мок-Gemini → проверить, что endpoint возвращает 200 и корректную структуру.
- Swagger UI: отправить полный `GeneratePlanRequest` → получить план на 7 дней с 5 приёмами пищи в каждом.
- Проверить: каждый рецепт содержит название, КБЖУ, ингредиенты, шаги.
- Проверить: `replace-meal` возвращает рецепт, который отличается от текущего и вписывается в оставшиеся КБЖУ дня.
- Проверить error handling: отправить запрос с невалидным телом → 422; отключить API ключ → 502.

---

## Задача 9. Flutter — сетевой слой и remote sources

### Что сделать
- Создать `network/http_client.dart` — фабрика `Dio`:
  - Base URL из конфига (пока захардкодить для dev).
  - Таймауты: connect 10 сек, receive 60 сек (AI может думать долго).
  - `LogInterceptor` для дебага.
  - `ErrorInterceptor` — маппинг `DioException` в `AppException`.
- Создать `core/errors/app_exception.dart`:
  - `NetworkException`, `ServerException(statusCode, message)`, `TimeoutException`, `NoConnectionException`.
- Создать `data/remote/api/api_endpoints.dart` — константы путей.
- Создать `data/remote/api/reciper_api.dart` — класс с методами:
  - `generateMealPlan(GenerateMealPlanRequestDto) → GenerateMealPlanResponseDto`
  - `replaceMeal(ReplaceMealRequestDto) → ReplaceMealResponseDto`
  - `suggestRecipes(RecipeSuggestionRequestDto) → RecipeSuggestionResponseDto`
  - `scanFridge(File image, {String? existingProductsJson}) → FridgeScanResponseDto`
- Создать все DTO в `data/remote/dto/` с `@freezed` и `@JsonSerializable`.
- Создать маппер `data/remote/mappers/meal_plan_mapper.dart` — из DTO в domain-модели и обратно.
- Создать remote sources в `data/remote/source/`:
  - `meal_plan_remote_source.dart` — использует `ReciperApi`, возвращает domain-модели через маппер.
  - `recipe_remote_source.dart`.
  - `fridge_remote_source.dart`.
- Создать `services/connectivity_service.dart` — обёртка над `connectivity_plus`, стрим `bool isOnline`.
- Добавить `Dio` и remote sources в `Dependencies`, инициализировать в `main.dart`.

### Как тестировать
- Unit-тест: DTO сериализация/десериализация — подать JSON из примера эндпоинта → получить корректный DTO.
- Unit-тест: маппер — из DTO в domain-модель и обратно, все поля совпадают.
- Интеграционный тест: запустить backend локально, отправить запрос через `ReciperApi` → получить ответ, смаппить в domain-модель.
- Проверить обработку ошибок: отключить backend → `NoConnectionException`; подать невалидные данные → `ServerException(422)`.

---

## Задача 10. Репозиторий плана питания + BLoC + экран генерации плана

### Что сделать
- Создать `data/repository/meal_plan_repository.dart`:
  - `generatePlan(...)` → remote source → сохранить в Drift → вернуть domain-модель.
  - `getActivePlan()` → из Drift.
  - `getPlanByDate(date)` → из Drift.
  - `replaceMeal(mealId, reason, ...)` → remote source → обновить в Drift.
  - `markMealCompleted(mealId)` → обновить в Drift.
  - `setActivePlan(planId)` → обновить в Drift (снять active с предыдущего).
  - `getPlanHistory()` → из Drift.
- Создать `domain/bloc/plan_generation/`:
  - `PlanGenerationBloc` — управляет шагами визарда генерации.
  - Events: `StepCompleted(step, data)`, `GenerationRequested`, `PlanAccepted`, `PlanRejected`.
  - States: `PlanGenerationStepState(currentStep, collectedData)`, `PlanGenerating`, `PlanGenerated(plan, summary)`, `PlanGenerationError`.
- Создать `domain/bloc/meal_plan/`:
  - `MealPlanBloc` — управляет отображением текущего плана.
  - Events: `MealPlanLoadRequested`, `DaySelected(date)`, `MealReplaceRequested(mealId, reason)`, `MealCompleted(mealId)`.
  - States: `MealPlanInitial`, `MealPlanLoading`, `MealPlanLoaded(plan, selectedDate, dayPlan, nutrition)`, `MealPlanEmpty`, `MealReplacingInProgress(mealId)`.
- Создать экран `module/plan_generation/`:
  - `plan_generation_screen.dart` — пошаговый визард (подтверждение цели → период → время готовки → приёмы пищи → бюджет → продукты → доп. пожелания).
  - Виджеты шагов в `widgets/`.
  - Экран загрузки генерации с анимацией прогресса (skeleton/shimmer).
  - Экран превью плана — карточки дней, сводка КБЖУ, кнопки «Принять» / «Перегенерировать».
- Добавить `MealPlanRepository` в `Dependencies`.
- Из главного экрана (пока пустое состояние) по кнопке «Составить персональный план» → открыть экран генерации.

### Как тестировать
- Unit-тест `MealPlanRepository`: мок remote source возвращает план → репозиторий сохраняет в Drift → `getActivePlan()` возвращает тот же план.
- Unit-тест `PlanGenerationBloc`: пройти все шаги → `GenerationRequested` → состояние `PlanGenerating` → (мок) → `PlanGenerated`.
- UI-тест: открыть экран генерации → пройти шаги → нажать «Составить» → увидеть анимацию загрузки → увидеть превью плана.
- UI-тест: нажать «Принять план» → вернуться на главный экран → план отображается (пока просто факт, что state изменился).
- Проверить edge cases: нет интернета → сообщение об ошибке на экране генерации; backend вернул ошибку → сообщение.

---

## Задача 11. Главный экран — отображение плана питания

### Что сделать
- Реализовать `module/home/home_screen.dart` и `home_controller.dart`.
- Верхняя часть:
  - `widgets/day_selector.dart` — горизонтальный скроллер дней (текущая неделя плана), выделение текущего дня, свайп.
  - `widgets/nutrition_summary.dart` — круговая диаграмма калорий (donut chart через `CustomPainter` или `fl_chart`), три прогресс-бара КБЖУ с цветовой индикацией.
- Состояние «Пустой план»:
  - Текст + кнопка «Составить персональный план» → `Navigator.push` на экран генерации.
- Состояние «План есть»:
  - `widgets/meal_section.dart` — секция приёма пищи (заголовок с эмодзи и временем).
  - `widgets/meal_card.dart` — карточка блюда: название, теги (время, калории), КБЖУ, кнопка ❤️, кнопка 🔄.
  - Вертикальный скролл со всеми секциями дня.
- Действие 🔄 на карточке:
  - `widgets/replace_meal_bottom_sheet.dart` — bottom sheet с причинами замены (чипсы), текстовое поле, кнопка «Заменить» → `MealPlanBloc.add(MealReplaceRequested)` → shimmer-анимация на карточке → обновление.
- Долгое нажатие / свайп на карточке → контекстное меню (добавить в избранное, заменить, удалить, отметить съеденным).
- По нажатию на карточку → `Navigator.push` к экрану рецепта (задача 12).
- Нижняя кнопка: «Список покупок на этот день» → `Navigator.push` к экрану списка покупок (задача 14).
- Pull-to-refresh — перезагрузка текущего плана из Drift.
- Отслеживание `connectivity_service`: если offline, скрыть кнопку 🔄, показать бейдж «Офлайн-режим».

### Как тестировать
- Если нет плана → экран показывает пустое состояние с кнопкой.
- Если есть план → отображаются секции с карточками блюд.
- Переключение дней — данные обновляются, КБЖУ пересчитываются.
- КБЖУ summary: при всех невыполненных блюдах — полная норма; при отметке блюда съеденным — прогресс обновляется.
- Нажать 🔄 → bottom sheet → выбрать причину → «Заменить» → карточка мерцает (shimmer) → появляется новое блюдо.
- Офлайн: выключить интернет → кнопки генерации/замены недоступны, план и данные видны.
- Нажать на карточку → открывается экран рецепта (пока заглушка, если задача 12 ещё не сделана).

---

## Задача 12. Экран подробного рецепта

### Что сделать
- Реализовать `module/recipe_detail/recipe_detail_screen.dart` и `recipe_detail_controller.dart`.
- Шапка: название крупным шрифтом, кнопки «Назад» и ❤️.
- Информационные бейджи: время, калории, порции, сложность.
- Блок КБЖУ: 4 столбца.
- Блок «Ингредиенты»:
  - `widgets/portion_selector.dart` — переключатель порций (1/2/4), при смене пересчёт количеств ингредиентов.
  - Список ингредиентов с чекбоксами.
  - Зелёная / красная метка — сверка с холодильником (из `FridgeLocalSource`).
  - Кнопка «Добавить недостающее в список покупок» → сохранение в Drift.
- Блок «Пошаговое приготовление»:
  - Нумерованные шаги с текстом.
  - Если у шага есть таймер — кнопка ⏱ → создание системного таймера через `flutter_local_notifications`.
- Нижняя фиксированная панель:
  - Кнопка «Начать готовить» → `Navigator.push` к cooking mode (задача 15).
  - Кнопка 🔄 «Заменить блюдо» → тот же bottom sheet, что на главном экране.

### Как тестировать
- Открыть рецепт из главного экрана → все данные отображаются корректно.
- Переключить порции 1 → 2 → количества ингредиентов удваиваются.
- Ингредиент, который есть в холодильнике → зелёная метка; которого нет → красная.
- Нажать «Добавить недостающее» → элементы появляются в списке покупок (проверить в Drift или через экран покупок).
- Нажать ⏱ на шаге → таймер ставится, уведомление приходит по окончании.
- Нажать ❤️ → рецепт помечен как избранное (проверить в Drift).

---

## Задача 13. Экран сканирования холодильника

### Что сделать
- Создать `data/repository/fridge_repository.dart`:
  - `scanImage(File) → List<FridgeProduct>` — отправка на backend, получение распознанных продуктов.
  - `appendScan(File, existingProducts) → List<FridgeProduct>` — досканирование.
  - `getProducts() → List<FridgeProduct>` — из Drift.
  - `saveProducts(List<FridgeProduct>)` → в Drift.
  - `addProduct(FridgeProduct)` / `removeProduct(id)` / `updateProduct(...)` → в Drift.
  - `saveScanRecord(FridgeScan)` → в Drift.
  - `getScanHistory()` → из Drift.
- Создать `data/local/file_storage/image_storage_service.dart`:
  - Сохранение фото холодильника в директорию приложения.
  - Получение пути по id скана.
  - Удаление старых фото (хранить последние 5).
- Создать `domain/bloc/fridge/`:
  - Events: `FridgeLoadRequested`, `FridgeScanStarted(File)`, `FridgeAppendScanStarted(File)`, `FridgeProductConfirmed(id)`, `FridgeProductRemoved(id)`, `FridgeProductAdded(product)`, `FridgeProductsConfirmed(products)`.
  - States: `FridgeInitial`, `FridgeLoaded(products, lastScanDate)`, `FridgeScanning`, `FridgeScanResult(recognizedProducts, imageFile)`, `FridgeError`.
- Реализовать `module/fridge_scanner/`:
  - Начальное состояние: текст + кнопки «Сфотографировать» / «Загрузить фото».
  - `widgets/camera_view.dart` — экран камеры через пакет `camera`.
  - Экран загрузки: анимация сканирования поверх фото.
  - Экран результатов: миниатюра фото, список распознанных продуктов, чекбоксы, редактирование количества, удаление, ручное добавление (поисковое поле).
  - `widgets/scanned_products_list.dart`, `widgets/product_card.dart`.
  - Кнопка «Досканировать» → добавляет фото, дополняет список.
  - Кнопка «Подтвердить список» → сохранение в Drift.
  - Состояние «уже отсканирован»: текущий список с возможностью редактирования, кнопки «Пересканировать» / «Дополнить».
  - Аккордеон «История сканирований» — последние 2–3 скана.
  - Нижняя кнопка «Показать рецепты из моих продуктов» → переход на каталог рецептов с фильтром.
- Запрос разрешений камеры и галереи через `permission_handler`.
- Офлайн: если нет сети, кнопки сканирования неактивны с пояснением; просмотр текущего списка работает.

### Как тестировать
- Нажать «Сфотографировать» → открывается камера → сделать фото → анимация сканирования → список продуктов с confidence.
- Нажать ✕ на продукте → удаляется из списка.
- Отредактировать количество → сохраняется.
- Нажать «Досканировать» → новое фото → список дополняется, старые не затираются.
- Нажать «Подтвердить» → вернуться на экран сканера → показывается текущий список с датой.
- Перезапуск приложения → продукты загружаются из Drift.
- Проверить историю: после 2-х сканов аккордеон показывает оба, с миниатюрами.
- Офлайн: кнопки сканирования серые, текущий список отображается.
- Edge case: фото потолка → backend возвращает пустой список → UI показывает «Не удалось распознать продукты, попробуйте ещё раз».

---

## Задача 14. Экран списка покупок

### Что сделать
- Создать `data/repository/shopping_list_repository.dart`:
  - `generateListFromPlan(planId, {date?})` → локально: собрать ингредиенты из рецептов плана, сгруппировать по категориям, объединить одинаковые (суммировать количества), сверить с холодильником → зачеркнуть имеющееся. Сохранить в Drift.
  - `getList(planId, {date?})` → из Drift.
  - `toggleItemBought(itemId)` → в Drift.
  - `addCustomItem(ShoppingItem)` → в Drift.
  - `removeItem(itemId)` → в Drift.
- Создать `domain/bloc/shopping_list/`:
  - Events: `ShoppingListLoadRequested(planId, date?)`, `ShoppingItemToggled(itemId)`, `ShoppingItemAdded(item)`, `ShoppingItemRemoved(itemId)`.
  - States: `ShoppingListInitial`, `ShoppingListLoaded(items, groupedByCategory, totalEstimatedCost?)`.
- Реализовать `module/shopping_list/`:
  - Заголовок с периодом.
  - Фильтр по дням (все / конкретный день).
  - Список, сгруппированный по категориям (мясо, молочные, овощи, крупы, прочее).
  - Каждый элемент: чекбокс, название, количество; если есть в холодильнике — зачёркнутый.
  - Свайп для удаления.
  - Кнопка «Добавить своё» → модальное окно с полем ввода.
  - Кнопка «Поделиться списком» → share intent (текстовый формат).
- Полностью офлайн — данные из Drift, никаких запросов к backend.

### Как тестировать
- Перейти из главного экрана → список покупок формируется из блюд текущего дня.
- Переключить фильтр «Все дни» → список расширяется ингредиентами всего плана.
- Одинаковые ингредиенты из разных рецептов объединены (например, 2 рецепта с молоком → одна строка с суммой).
- Ингредиент, который есть в холодильнике → зачёркнут.
- Отметить чекбокс → элемент помечен как купленный; перезапуск приложения → отметка сохранена.
- Свайп → удаление; добавить вручную → появляется в списке.
- «Поделиться» → открывается system share sheet с текстом списка.
- Офлайн: всё работает.

---

## Задача 15. Backend — эндпоинты рецептов и сканирования холодильника

### Что сделать
- Создать Pydantic-схемы:
  - `fridge.py` — `FridgeScanResponse`, `RecognizedProductSchema`.
  - `recipe.py` — `RecipeSuggestionRequest`, `RecipeSuggestionResponse`, `GenerateRecipeRequest`, `GenerateRecipeResponse`.
- Создать `app/services/fridge_scan_service.py`:
  - Принимает `image_bytes`, `existing_products_json`, `scan_mode`.
  - Собирает промпт через `prompt_builder.build_fridge_scan_prompt`.
  - Вызывает `gemini_client.generate_with_image`.
  - Парсит ответ.
  - Если `scan_mode == append` — объединяет с existing_products.
- Создать `app/services/recipe_service.py`:
  - `suggest_recipes(request)` → промпт → Gemini → парсинг → список рецептов.
  - `generate_recipe(request)` → промпт → Gemini → парсинг → полный рецепт.
- Создать `app/api/v1/endpoints/fridge.py`:
  - `POST /api/v1/fridge/scan` — multipart/form-data (image + JSON полей).
- Создать `app/api/v1/endpoints/recipes.py`:
  - `POST /api/v1/recipes/suggest`
  - `POST /api/v1/recipes/generate`
- Создать `app/utils/image_utils.py` — ресайз фото перед отправкой в Gemini (снижение размера, конвертация формата).

### Как тестировать
- Swagger UI: загрузить реальное фото холодильника через `POST /fridge/scan` → получить JSON со списком продуктов, у каждого есть confidence.
- Swagger UI: `POST /recipes/suggest` с продуктами → список из 3–5 рецептов с КБЖУ.
- Swagger UI: `POST /recipes/generate` с описанием → полный рецепт с ингредиентами и шагами.
- `pytest`: мок Gemini → проверить корректность парсинга и обработки ошибок.
- Edge case: пустое фото / фото не еды → адекватный ответ (пустой список или сообщение).
- Edge case: `scan_mode=append` с existing_products → новый продукт добавлен, дубликаты объединены.

---

## Задача 16. Экран каталога рецептов

### Что сделать
- Создать `data/repository/recipe_repository.dart`:
  - `suggestRecipes(query, filters, fridgeProducts) → List<Recipe>` — через remote source.
  - `generateRecipe(prompt, preferences, nutritionTarget) → Recipe` — через remote source.
  - `getFavorites() → List<Recipe>` — из Drift.
  - `toggleFavorite(recipeId)` → в Drift.
  - `getRecipeById(id) → Recipe` — из Drift.
- Создать `domain/bloc/recipe/`:
  - Events: `RecipeSearchRequested(query, filters)`, `RecipeSuggestFromFridge`, `RecipeFavoritesRequested`, `RecipeFavoriteToggled(id)`.
  - States: `RecipeInitial`, `RecipeLoading`, `RecipeResults(recipes)`, `RecipeFavorites(recipes)`, `RecipeError`.
- Реализовать `module/recipes_catalog/`:
  - Поле поиска сверху.
  - Фильтры (чипсы): «Из моего холодильника», «До 15 мин», «До 30 мин», «Завтраки», «Обеды», «Ужины», «Перекусы», «Избранное».
  - Результаты — сетка или список карточек рецептов.
  - Фильтр «Из моего холодильника» — предзагрузка продуктов из Drift и передача в запрос.
  - По нажатию на карточку → экран рецепта (задача 12).
  - Избранное — отдельная секция или фильтр.
- Офлайн: доступны только избранные рецепты; поиск и AI-подбор недоступны.

### Как тестировать
- Ввести запрос «быстрый ужин» → отправляется запрос на backend → отображаются результаты.
- Выбрать фильтр «Из моего холодильника» → в запрос подставляются продукты из Drift → результаты релевантны.
- Нажать ❤️ → рецепт добавлен в избранное; переключить фильтр «Избранное» → рецепт отображается.
- Офлайн: показываются только избранные, кнопка поиска неактивна.
- Нажать на рецепт → открывается полный экран рецепта.

---

## Задача 17. Голосовой режим готовки (Cooking Mode)

### Что сделать
- Создать `services/speech_service.dart`:
  - Инициализация `speech_to_text`.
  - Метод `startListening(onResult: (String) → void)`.
  - Метод `stopListening()`.
  - Обработка команд: распознавание ключевых фраз («следующий шаг», «повтори», «назад», «таймер N минут», «стоп»). Нечёткое сопоставление — «следующий», «дальше», «далее» → одна команда.
  - Поддержка русского языка.
- Создать `services/tts_service.dart`:
  - Инициализация `flutter_tts`, русский язык, скорость речи.
  - Метод `speak(String text)`.
  - Метод `stop()`.
- Создать `services/cooking_foreground_service.dart`:
  - Foreground service через `flutter_foreground_task`.
  - При сворачивании / выключении экрана — сервис продолжает слушать голос и озвучивать.
  - Уведомление с текущим шагом и кнопками (Назад / Далее).
- Создать `domain/bloc/cooking_mode/`:
  - Events: `CookingStarted(recipe)`, `NextStepRequested`, `PreviousStepRequested`, `RepeatStepRequested`, `TimerStarted(seconds)`, `TimerFinished`, `CookingFinished`, `VoiceCommandReceived(command)`.
  - States: `CookingModeInitial`, `CookingModeActive(recipe, currentStepIndex, totalSteps, timerRemaining?, isListening)`, `CookingModeTimerRunning(...)`, `CookingModeCompleted`.
- Реализовать `module/cooking_mode/`:
  - Экран инструкции (при первом входе): голосовые команды, кнопка «Начать».
  - Основной экран: прогресс, номер шага крупно, текст шага очень крупно, таймер.
  - Нижняя панель: три кнопки (Назад, Повторить, Далее) на случай если голос не сработал.
  - Индикатор микрофона — пульсирующая иконка.
  - `widgets/step_display.dart`, `widgets/voice_indicator.dart`, `widgets/timer_widget.dart`.
  - Экран завершения: поздравление, отметить блюдо, оценить рецепт (5 звёзд), кнопка «Вернуться к плану».
- При переходе на новый шаг — автоматическое озвучивание через TTS.
- Таймеры: если в шаге есть время — автоматическое предложение таймера; по окончании — звук + вибрация + озвучивание.
- Push-уведомление при сворачивании: текущий шаг, кнопки управления.

### Как тестировать
- Нажать «Начать готовить» из рецепта → экран инструкции → «Начать» → первый шаг озвучен.
- Нажать кнопку «Далее» → следующий шаг, озвучен; «Назад» → предыдущий; «Повторить» → текущий шаг озвучен заново.
- Сказать «Следующий шаг» → переход; «Повтори» → повтор; «Назад» → возврат; «Таймер 5 минут» → таймер запущен.
- Таймер: обратный отсчёт отображается на экране; по окончании — звук, вибрация, голосовое сообщение.
- Свернуть приложение → уведомление показывает текущий шаг; голосовые команды продолжают работать (foreground service).
- Выключить экран → голосовые команды работают (проверить на реальном устройстве).
- Дойти до последнего шага → «Далее» → экран завершения; отметить блюдо → статус в Drift обновлён.
- Офлайн: если рецепт уже загружен в Drift — cooking mode работает полностью без интернета.
- Сказать «Стоп» → диалог подтверждения выхода.

---

## Задача 18. Экран профиля и трекинг прогресса

### Что сделать
- Создать `data/repository/progress_repository.dart`:
  - `addWeightEntry(weight, date)` → в Drift.
  - `getWeightHistory(period)` → из Drift.
  - `getStatistics()` → из Drift: дней на плане, блюд приготовлено, дней в калорийности, средняя калорийность.
- Создать `domain/bloc/progress/`:
  - Events: `ProgressLoadRequested`, `WeightEntryAdded(weight, date)`.
  - States: `ProgressLoaded(weightHistory, statistics, trend)`.
- Реализовать `module/profile/`:
  - Карточка пользователя: аватарка (эмодзи), имя, бейдж цели, кнопка «Редактировать».
  - «Мои параметры»: карточки с текущими значениями — редактирование inline; при смене цели → предложение пересоздать план.
  - `widgets/weight_chart.dart` — линейный график веса через `fl_chart`: переключатель 30 дн / 3 мес / 6 мес / год; пунктирная линия целевого веса; тренд (текстом).
  - Кнопка «+ Записать вес» → модальное окно.
  - Блок «Результативность» — карточки метрик.
  - Блок «Мои предпочтения»: чипсы нелюбимых/любимых продуктов (добавление/удаление), ползунок времени, выбор бюджета, аллергии — всё сохраняется в `ProfileRepository` / `PreferencesLocalSource`.
  - Блок «История планов» — список из Drift, по нажатию → просмотр плана.
  - Блок «Настройки»: уведомления о приёмах пищи (вкл/выкл + время), напоминание взвеситься, единицы измерения, тема (светлая/тёмная), кнопка сброса данных.
- Переключение темы: через `SettingsRepository` + перестройка `MaterialApp`.

### Как тестировать
- Открыть профиль → имя и параметры из онбординга отображаются.
- Нажать «Редактировать» → изменить вес → сохранить → обновление на экране.
- Изменить цель → появляется диалог «Пересоздать план?» → «Да» → переход на экран генерации.
- Нажать «+ Записать вес» → ввести 80.5 кг → запись появляется на графике.
- Добавить 3-4 записи веса → график рисуется, тренд считается.
- Добавить в нелюбимые «Брокколи» → чип появляется; удалить → исчезает.
- Переключить тему → приложение перестраивается.
- Блок «Результативность»: проверить, что метрики считаются корректно (количество приготовленных блюд = количество отмеченных в Drift).
- «История планов» → нажать на завершённый план → можно просмотреть блюда прошлого плана.

---

## Задача 19. Локальные уведомления

### Что сделать
- Полностью реализовать `services/local_notification_service.dart`:
  - Инициализация `flutter_local_notifications`.
  - Запрос разрешения на уведомления.
  - Расписание уведомлений о приёмах пищи: по времени из плана (08:00 — «Пора завтракать! Сегодня: Овсянка с бананом»).
  - Напоминание взвеситься (по настройке: каждый день / раз в неделю).
  - Таймер-уведомления из cooking mode: «Время вышло! Скажите "следующий шаг"».
  - Notification actions: кнопки в уведомлении (для cooking mode — «Далее», «Повтори»).
- При сохранении нового плана — автоматически создавать расписание уведомлений на основе приёмов пищи.
- При смене настроек уведомлений — отменять старые и создавать новые.
- При удалении / смене плана — отменять уведомления старого.

### Как тестировать
- Включить уведомления в настройках → установить время для завтрака 08:00 → в 08:00 приходит уведомление с названием блюда.
- Включить напоминание взвеситься «каждый день в 09:00» → приходит уведомление.
- В cooking mode поставить таймер на 10 секунд (для теста) → уведомление приходит с кнопками.
- Выключить уведомления в настройках → уведомления больше не приходят.
- Сменить план → старые уведомления отменены, новые созданы.

---

## Задача 20. Офлайн-режим, полировка, подготовка к релизу

### Что сделать
- Полная проверка офлайн-сценариев:
  - Главный экран: план, КБЖУ, навигация по дням — всё из Drift.
  - Рецепт: все данные из Drift. Cooking mode работает.
  - Список покупок: из Drift.
  - Профиль: все данные из Drift, запись веса работает.
  - Каталог рецептов: избранные из Drift, поиск и AI-подбор недоступны с пояснением.
  - Сканер: текущий список из Drift, сканирование недоступно с пояснением.
  - Генерация плана и замена блюда: недоступны с пояснением.
- `ConnectivityService`: стрим-статус → UI реагирует на изменения в реальном времени (бейдж «Офлайн», активация/деактивация кнопок).
- Skeleton-загрузка при ожидании данных от AI (генерация, замена, сканер, поиск рецептов).
- Haptic feedback при нажатии кнопок.
- Плавные анимации: slide-in переходы, shared element transitions для карточек блюд.
- Проверка адаптивности: экраны от 4.7" до 6.7"+.
- Проверка edge cases:
  - Очень длинные названия рецептов — текст не обрезается некрасиво.
  - План с 3 приёмами пищи — секции перекусов не показываются.
  - Пустой холодильник — экран генерации корректно обрабатывает отсутствие продуктов.
  - Потеря интернета во время генерации → корректное сообщение об ошибке, данные не теряются.
  - Убийство приложения во время cooking mode → при следующем запуске можно продолжить с того же шага (сохранение состояния в Drift).
- `flutter analyze` — ноль ошибок.
- Иконка приложения, сплеш-экран — финальные версии.

### Как тестировать
- Включить авиарежим → пройти по всем экранам → всё загруженное ранее доступно, AI-функции заблокированы с пояснениями.
- Включить интернет → бейдж «Офлайн» исчезает, кнопки разблокируются.
- Начать генерацию плана → выключить интернет → адекватное сообщение, без краша.
- Запустить cooking mode → свернуть → убить приложение → открыть → предложение продолжить.
- Проверить на минимум 3-х разных размерах экрана (эмулятор).
- Полный end-to-end тест: онбординг → генерация плана → просмотр дня → открыть рецепт → приготовить в cooking mode → отметить → записать вес → проверить статистику.

---

## Задача 21. Backend — CI/CD и Docker-compose для деплоя

### Что сделать
- Финализировать `Dockerfile`:
  - Multi-stage build: builder (установка зависимостей) + runtime (минимальный образ).
  - Python 3.12-slim.
  - Не от root.
  - Healthcheck.
- Финализировать `docker-compose.yml`:
  - Сервис `backend` — build, порт, env_file, restart: unless-stopped, healthcheck.
  - Сервис `nginx` (опционально для MVP, но если хочешь HTTPS на домене — нужен).
- CI/CD (GitHub Actions или аналог):
  - **Lint**: `ruff check`.
  - **Test**: `pytest`.
  - **Build**: `docker build`.
  - **Deploy**: SSH + docker-compose pull/up или push в container registry + deploy на Yandex Cloud.
- `.env.example` — финальная версия со всеми переменными.
- `README.md` — инструкция по запуску: клонировать, скопировать `.env`, `docker-compose up`.

### Как тестировать
- `docker-compose up --build` на чистой машине → backend поднимается, healthcheck зелёный.
- Изменить код → push в main → CI проходит (lint, test, build) → deploy на сервер → `curl /api/v1/health` → `ok`.
- Проверить, что `.env` не попадает в Git (`.gitignore`).
- Проверить, что при падении контейнер перезапускается (`restart: unless-stopped`).
- Нагрузочный smoke test: 10 параллельных запросов на генерацию плана → все отвечают (возможно медленно из-за AI, но без крашей).