import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/dependencies_scope.dart';
import '../../domain/bloc/recipe/recipe_bloc.dart';
import '../../domain/bloc/recipe/recipe_event.dart';
import '../../domain/bloc/recipe/recipe_state.dart';
import '../../domain/models/enums/meal_type.dart';
import '../../domain/models/ingredient.dart';
import '../../domain/models/meal.dart';
import '../../domain/models/recipe.dart';
import '../../services/connectivity_service.dart';
import '../recipe_detail/recipe_detail_screen.dart';

class RecipesCatalogScreen extends StatelessWidget {
  const RecipesCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);
    return BlocProvider(
      create: (_) => RecipeBloc(
        repository: deps.recipeRepository,
        fridgeProductsLoader: () async {
          final rows = await deps.database.fridgeDao.getAllFridgeProducts();
          return rows
              .map((e) => {'name': e.name, 'amount': e.amount, 'unit': e.unit})
              .toList();
        },
      ),
      child: _RecipesCatalogView(connectivityService: deps.connectivityService),
    );
  }
}

class _RecipesCatalogView extends StatefulWidget {
  const _RecipesCatalogView({required this.connectivityService});
  final ConnectivityService connectivityService;

  @override
  State<_RecipesCatalogView> createState() => _RecipesCatalogViewState();
}

class _RecipesCatalogViewState extends State<_RecipesCatalogView>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final Set<String> _selectedAiFilters = <String>{};
  int _filterPanelGeneration = 0;
  late TabController _tabController;

  List<Recipe> _aiRecipes = const [];
  List<Recipe> _favoriteRecipes = const [];
  bool _favoritesReady = false;
  String? _aiError;

  /// Фильтры только для подбора через AI (без «Избранного» — отдельная вкладка).
  static const List<String> _aiFilterLabels = [
    'Из моего холодильника',
    'До 15 мин',
    'До 30 мин',
    'Завтраки',
    'Обеды',
    'Ужины',
    'Перекусы',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<RecipeBloc>().add(const RecipeFavoritesRequested());
    });
  }

  void _onTabChanged() {
    setState(() {});
    if (_tabController.indexIsChanging) return;
    if (_tabController.index == 1) {
      context.read<RecipeBloc>().add(const RecipeFavoritesRequested());
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecipeBloc, RecipeState>(
      listener: (context, state) {
        if (state is RecipeResults) {
          setState(() {
            _aiRecipes = state.recipes;
            _aiError = null;
          });
        } else if (state is RecipeFavorites) {
          setState(() {
            _favoriteRecipes = state.recipes;
            _favoritesReady = true;
          });
        } else if (state is RecipeError) {
          setState(() => _aiError = state.message);
        }
      },
      child: StreamBuilder<bool>(
        stream: widget.connectivityService.isOnline,
        initialData: true,
        builder: (context, snapshot) {
          final isOnline = snapshot.data ?? true;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Рецепты'),
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(
                    icon: Icon(Icons.auto_awesome_outlined),
                    text: 'Подбор с AI',
                  ),
                  Tab(
                    icon: Icon(Icons.favorite_outline),
                    text: 'Избранное',
                  ),
                ],
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildAiTab(context, isOnline),
                _buildFavoritesTab(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAiTab(BuildContext context, bool isOnline) {
    return BlocBuilder<RecipeBloc, RecipeState>(
      buildWhen: (prev, next) =>
          next is RecipeLoading || next is RecipeError || next is RecipeResults,
      builder: (context, state) {
        final aiLoading = state is RecipeLoading && _tabController.index == 0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!isOnline)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                color: Theme.of(context)
                    .colorScheme
                    .errorContainer
                    .withValues(alpha: 0.45),
                child: Text(
                  'Подбор через AI недоступен офлайн. Избранное доступно без сети.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                ),
              ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  Text(
                    'Запрос к нейросети',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Опишите блюдо, ингредиенты или стиль — мы подберём варианты на сервере.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _controller,
                    minLines: 1,
                    maxLines: 3,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Например: лёгкий ужин с курицей до 30 минут',
                      prefixIcon: const Icon(Icons.search),
                    ),
                    onSubmitted: (_) =>
                        isOnline ? _runAiSearch(context) : null,
                  ),
                  const SizedBox(height: 8),
                  Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      key: ValueKey(_filterPanelGeneration),
                      title: Text(
                        'Фильтры',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      subtitle: Text(
                        _selectedAiFilters.isEmpty
                            ? 'Необязательно'
                            : 'Выбрано: ${_selectedAiFilters.length}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _aiFilterLabels.map((label) {
                            final selected = _selectedAiFilters.contains(label);
                            return FilterChip(
                              label: Text(label),
                              selected: selected,
                              onSelected: isOnline
                                  ? (v) => setState(() {
                                        if (v) {
                                          _selectedAiFilters.add(label);
                                        } else {
                                          _selectedAiFilters.remove(label);
                                        }
                                      })
                                  : null,
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: isOnline && !aiLoading
                        ? () => _runAiSearch(context)
                        : null,
                    icon: const Icon(Icons.auto_awesome),
                    label: Text(aiLoading ? 'Ищем рецепты…' : 'Найти рецепты'),
                  ),
                  if (_aiError != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _aiError!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Text(
                    'Результаты подбора',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  if (aiLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (_aiRecipes.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          'Здесь появятся рецепты после запроса к AI',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                        ),
                      ),
                    )
                  else
                    ..._aiRecipes.map(
                      (recipe) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _RecipeCard(
                          recipe: recipe,
                          onOpen: () => _openRecipeDetails(context, recipe),
                          onToggleFavorite: () {
                            context
                                .read<RecipeBloc>()
                                .add(RecipeFavoriteToggled(recipe.id));
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFavoritesTab(BuildContext context) {
    if (!_favoritesReady) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<RecipeBloc>().add(const RecipeFavoritesRequested());
        await Future<void>.delayed(const Duration(milliseconds: 200));
      },
      child: _favoriteRecipes.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.35,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Пока нет избранных рецептов.\n'
                        'Нажмите ❤️ в подборе с AI или в карточке блюда из плана.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              itemCount: _favoriteRecipes.length,
              separatorBuilder: (_, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final recipe = _favoriteRecipes[index];
                return _RecipeCard(
                  recipe: recipe,
                  onOpen: () => _openRecipeDetails(context, recipe),
                  onToggleFavorite: () {
                    context
                        .read<RecipeBloc>()
                        .add(RecipeFavoriteToggled(recipe.id));
                  },
                );
              },
            ),
    );
  }

  void _runAiSearch(BuildContext context) {
    setState(() {
      _aiError = null;
      _filterPanelGeneration++;
    });

    if (_selectedAiFilters.contains('Из моего холодильника')) {
      context.read<RecipeBloc>().add(
            RecipeSuggestFromFridge(
              queryHint: _controller.text.trim(),
              filters: _buildAiFilters(),
            ),
          );
      return;
    }

    context.read<RecipeBloc>().add(
          RecipeSearchRequested(
            query: _controller.text.trim(),
            filters: _buildAiFilters(),
          ),
        );
  }

  Map<String, dynamic> _buildAiFilters() {
    final data = <String, dynamic>{};
    if (_selectedAiFilters.contains('До 15 мин')) {
      data['max_cooking_time_min'] = 15;
    }
    if (_selectedAiFilters.contains('До 30 мин')) {
      data['max_cooking_time_min'] = 30;
    }
    if (_selectedAiFilters.contains('Завтраки')) {
      data['meal_type'] = 'breakfast';
    }
    if (_selectedAiFilters.contains('Обеды')) {
      data['meal_type'] = 'lunch';
    }
    if (_selectedAiFilters.contains('Ужины')) {
      data['meal_type'] = 'dinner';
    }
    if (_selectedAiFilters.contains('Перекусы')) {
      data['meal_type'] = 'snack';
    }
    return data;
  }

  Future<void> _openRecipeDetails(BuildContext context, Recipe recipe) async {
    final deps = DependenciesScope.of(context);
    final ingredients = await deps.recipeRepository.getIngredientsByRecipeId(recipe.id);
    final activePlan = await deps.mealPlanRepository.getActivePlan();
    if (!context.mounted) return;
    final planId = activePlan?.mealPlan.id ?? 0;
    final placeholderMeal = Meal(
      id: -recipe.id,
      dayPlanId: -1,
      mealType: MealType.dinner,
      mealTime: DateTime.now(),
      recipeId: recipe.id,
      isDone: false,
    );
    final catalogContext = context;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => RecipeDetailScreen(
          recipe: recipe,
          ingredients: _ensureIngredientsFallback(
            recipe: recipe,
            ingredients: ingredients,
          ),
          meal: placeholderMeal,
          mealPlanId: planId,
          onRecipeUpdated: () {
            if (catalogContext.mounted) {
              catalogContext.read<RecipeBloc>().add(const RecipeCatalogSyncRequested());
            }
          },
        ),
      ),
    );
  }

  List<Ingredient> _ensureIngredientsFallback({
    required Recipe recipe,
    required List<Ingredient> ingredients,
  }) {
    if (ingredients.isNotEmpty) return ingredients;
    return [
      Ingredient(
        id: -1,
        recipeId: recipe.id,
        name: 'Ингредиенты не указаны',
        amount: 1,
        unit: 'порция',
        category: 'other',
      ),
    ];
  }
}

class _RecipeCard extends StatelessWidget {
  const _RecipeCard({
    required this.recipe,
    required this.onOpen,
    required this.onToggleFavorite,
  });

  final Recipe recipe;
  final VoidCallback onOpen;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onOpen,
        title: Text(recipe.title),
        subtitle: Text(
          '${recipe.cookingTimeMinutes} мин · ${recipe.calories.toStringAsFixed(0)} ккал',
        ),
        trailing: IconButton(
          onPressed: onToggleFavorite,
          icon: Icon(
            recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: recipe.isFavorite ? Colors.red : null,
          ),
        ),
      ),
    );
  }
}
