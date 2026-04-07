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

class _RecipesCatalogViewState extends State<_RecipesCatalogView> {
  final TextEditingController _controller = TextEditingController();
  final Set<String> _selectedFilters = <String>{};
  bool _filtersExpanded = false;

  static const List<String> _allFilters = [
    'Из моего холодильника',
    'До 15 мин',
    'До 30 мин',
    'Завтраки',
    'Обеды',
    'Ужины',
    'Перекусы',
    'Избранное',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Рецепты')),
      body: StreamBuilder<bool>(
        stream: widget.connectivityService.isOnline,
        initialData: true,
        builder: (context, snapshot) {
          final isOnline = snapshot.data ?? true;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Поиск рецептов',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      onPressed: (isOnline || _selectedFilters.contains('Избранное'))
                          ? () => _runSearch(context, isOnline)
                          : null,
                      icon: const Icon(Icons.send),
                    ),
                  ),
                  onSubmitted: (_) => _runSearch(context, isOnline),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton.icon(
                    onPressed: () => setState(() => _filtersExpanded = !_filtersExpanded),
                    icon: Icon(
                      _filtersExpanded ? Icons.expand_less : Icons.expand_more,
                    ),
                    label: Text(
                      _filtersExpanded ? 'Скрыть фильтры' : 'Показать фильтры',
                    ),
                  ),
                ),
              ),
              if (_filtersExpanded)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _allFilters.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3.5,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (_, index) {
                      final f = _allFilters[index];
                      return FilterChip(
                        label: Text(f),
                        selected: _selectedFilters.contains(f),
                        onSelected: (v) => setState(() {
                          if (v) {
                            _selectedFilters.add(f);
                          } else {
                            _selectedFilters.remove(f);
                          }
                        }),
                      );
                    },
                  ),
                ),
              if (_selectedFilters.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      spacing: 8,
                      children: _selectedFilters
                          .map(
                            (f) => Chip(
                              label: Text(f),
                              onDeleted: () => setState(() => _selectedFilters.remove(f)),
                            ),
                          )
                          .toList(),
                    ),
                  ),
              ),
              if (!isOnline)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Chip(label: Text('Офлайн-режим: доступны только избранные')),
                ),
              const SizedBox(height: 8),
              Expanded(
                child: BlocBuilder<RecipeBloc, RecipeState>(
                  builder: (context, state) {
                    if (state is RecipeLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is RecipeError) {
                      return Center(child: Text(state.message));
                    }
                    final recipes = switch (state) {
                      RecipeResults() => state.recipes,
                      RecipeFavorites() => state.recipes,
                      _ => const <Recipe>[],
                    };
                    if (recipes.isEmpty && (state is RecipeResults || state is RecipeFavorites)) {
                      return const Center(
                        child: Text('Ничего не найдено по выбранным фильтрам'),
                      );
                    }
                    if (recipes.isEmpty) {
                      return const Center(
                        child: Text('Введите запрос или выберите фильтр'),
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemBuilder: (_, index) {
                        final recipe = recipes[index];
                        return Card(
                          child: ListTile(
                            onTap: () => _openRecipeDetails(context, recipe),
                            title: Text(recipe.title),
                            subtitle: Text(
                              '${recipe.cookingTimeMinutes} мин · ${recipe.calories.toStringAsFixed(0)} ккал',
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                context
                                    .read<RecipeBloc>()
                                    .add(RecipeFavoriteToggled(recipe.id));
                              },
                              icon: Icon(
                                recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: recipe.isFavorite ? Colors.red : null,
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemCount: recipes.length,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _runSearch(BuildContext context, bool isOnline) {
    if (_selectedFilters.contains('Избранное') || !isOnline) {
      context.read<RecipeBloc>().add(const RecipeFavoritesRequested());
      return;
    }
    if (_selectedFilters.contains('Из моего холодильника')) {
      context.read<RecipeBloc>().add(
            RecipeSuggestFromFridge(
              queryHint: _controller.text.trim(),
              filters: _buildFilters(),
            ),
          );
      return;
    }
    context.read<RecipeBloc>().add(
          RecipeSearchRequested(
            query: _controller.text.trim(),
            filters: _buildFilters(),
          ),
        );
  }

  Map<String, dynamic> _buildFilters() {
    final data = <String, dynamic>{};
    if (_selectedFilters.contains('До 15 мин')) data['max_cooking_time_min'] = 15;
    if (_selectedFilters.contains('До 30 мин')) data['max_cooking_time_min'] = 30;
    if (_selectedFilters.contains('Завтраки')) data['meal_type'] = 'breakfast';
    if (_selectedFilters.contains('Обеды')) data['meal_type'] = 'lunch';
    if (_selectedFilters.contains('Ужины')) data['meal_type'] = 'dinner';
    if (_selectedFilters.contains('Перекусы')) data['meal_type'] = 'snack';
    return data;
  }

  Future<void> _openRecipeDetails(BuildContext context, Recipe recipe) async {
    final deps = DependenciesScope.of(context);
    final ingredients = await deps.recipeRepository.getIngredientsByRecipeId(recipe.id);
    if (!context.mounted) return;
    final placeholderMeal = Meal(
      id: -recipe.id,
      dayPlanId: -1,
      mealType: MealType.dinner,
      mealTime: DateTime.now(),
      recipeId: recipe.id,
      isDone: false,
    );
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => RecipeDetailScreen(
          recipe: recipe,
          ingredients: _ensureIngredientsFallback(
            recipe: recipe,
            ingredients: ingredients,
          ),
          meal: placeholderMeal,
          mealPlanId: 0,
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
