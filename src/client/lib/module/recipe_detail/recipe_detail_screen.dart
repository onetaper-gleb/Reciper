import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/dependencies_scope.dart';
import '../../domain/bloc/meal_plan/meal_plan_bloc.dart';
import '../../domain/bloc/meal_plan/meal_plan_event.dart';
import '../../domain/models/ingredient.dart';
import '../../domain/models/meal.dart';
import '../../domain/models/recipe.dart';
import '../cooking_mode/cooking_mode_screen.dart';
import '../home/widgets/replace_meal_bottom_sheet.dart';
import 'recipe_detail_controller.dart';
import 'widgets/portion_selector.dart';

class RecipeDetailScreen extends StatefulWidget {
  const RecipeDetailScreen({
    super.key,
    required this.recipe,
    required this.ingredients,
    required this.meal,
    required this.mealPlanId,
    this.onRecipeUpdated,
  });

  final Recipe recipe;
  final List<Ingredient> ingredients;
  final Meal meal;
  final int mealPlanId;

  /// Called after favorite (or other local recipe row) changes — e.g. refresh catalog BLoC.
  final VoidCallback? onRecipeUpdated;

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  int _portions = 1;
  Set<String> _fridgeNames = const {};
  late Recipe _recipe;
  final Set<int> _checkedIngredientIds = {};

  @override
  void initState() {
    super.initState();
    _recipe = widget.recipe;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncRecipeFromDb();
    });
    _loadFridgeProducts();
  }

  Future<void> _loadFridgeProducts() async {
    final db = DependenciesScope.of(context).database;
    final rows = await db.fridgeDao.getAllFridgeProducts();
    if (!mounted) return;
    setState(() {
      _fridgeNames = rows.map((e) => e.name.trim().toLowerCase()).toSet();
    });
  }

  Future<void> _syncRecipeFromDb() async {
    final repo = DependenciesScope.of(context).recipeRepository;
    final fresh = await repo.getRecipeById(widget.recipe.id);
    if (!mounted || fresh == null) return;
    setState(() => _recipe = fresh);
  }

  Future<void> _toggleFavorite() async {
    final repo = DependenciesScope.of(context).recipeRepository;
    await repo.toggleFavorite(_recipe.id);
    final fresh = await repo.getRecipeById(_recipe.id);
    if (!mounted || fresh == null) return;
    setState(() => _recipe = fresh);
    widget.onRecipeUpdated?.call();
  }

  Future<void> _addMissingToShoppingList() async {
    if (widget.mealPlanId <= 0) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Сначала создайте план питания — список покупок привязан к плану'),
        ),
      );
      return;
    }
    final db = DependenciesScope.of(context).database;
    final ingredients = widget.ingredients
        .where((i) => !_checkedIngredientIds.contains(i.id))
        .toList();
    final inserted = await RecipeDetailController.addMissingToShoppingList(
      database: db,
      mealPlanId: widget.mealPlanId,
      ingredients: ingredients,
      fridgeNames: _fridgeNames,
      portions: _portions,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Добавлено в покупки: $inserted')),
    );
  }

  void _showReplaceMealBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => ReplaceMealBottomSheet(
        onSubmit: (reason, notes) {
          Navigator.of(context).pop();
          context.read<MealPlanBloc>().add(
                MealReplaceRequested(
                  mealId: widget.meal.id,
                  reason: reason,
                  notes: notes,
                ),
              );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ingredientViews = RecipeDetailController.buildIngredientViews(
      ingredients: widget.ingredients,
      fridgeNames: _fridgeNames,
      portions: _portions,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(_recipe.title),
        actions: [
          IconButton(
            onPressed: _toggleFavorite,
            icon: Icon(
              _recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _recipe.isFavorite ? Colors.red : null,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Wrap(
            spacing: 8,
            children: [
              Chip(label: Text('${_recipe.cookingTimeMinutes} мин')),
              Chip(label: Text('${_recipe.calories.toStringAsFixed(0)} ккал')),
              Chip(label: Text('${_recipe.servings} порц.')),
              Chip(label: Text(_recipe.difficulty.name)),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _Macro(title: 'Ккал', value: _recipe.calories),
                  _Macro(title: 'Б', value: _recipe.proteinG),
                  _Macro(title: 'Ж', value: _recipe.fatG),
                  _Macro(title: 'У', value: _recipe.carbsG),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Ингредиенты', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          PortionSelector(
            value: _portions,
            onChanged: (v) => setState(() => _portions = v),
          ),
          const SizedBox(height: 8),
          ...ingredientViews.map(
            (item) => CheckboxListTile(
              value: _checkedIngredientIds.contains(item.ingredient.id),
              onChanged: (v) => setState(() {
                if (v ?? false) {
                  _checkedIngredientIds.add(item.ingredient.id);
                } else {
                  _checkedIngredientIds.remove(item.ingredient.id);
                }
              }),
              title: Text(item.ingredient.name),
              subtitle: Text('${item.amount.toStringAsFixed(1)} ${item.ingredient.unit}'),
              secondary: Icon(
                item.inFridge ? Icons.check_circle : Icons.cancel,
                color: item.inFridge ? Colors.green : Colors.red,
              ),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _addMissingToShoppingList,
            child: const Text('Добавить недостающее в список покупок'),
          ),
          const SizedBox(height: 16),
          Text('Пошаговое приготовление', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ..._recipe.steps.map(
            (step) => ListTile(
              leading: CircleAvatar(child: Text('${step.order}')),
              title: Text(step.instruction),
              trailing: step.durationSeconds == null
                  ? null
                  : Tooltip(
                      message: 'Таймер в режиме готовки',
                      child: Icon(
                        Icons.timer_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => CookingModeScreen(
                          recipe: _recipe,
                          meal: widget.meal,
                          mealPlanId: widget.mealPlanId,
                        ),
                      ),
                    );
                  },
                  child: const Text('Начать готовить'),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _showReplaceMealBottomSheet,
                icon: const Icon(Icons.swap_horiz),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Macro extends StatelessWidget {
  const _Macro({required this.title, required this.value});

  final String title;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: Theme.of(context).textTheme.bodySmall),
        Text(value.toStringAsFixed(0)),
      ],
    );
  }
}

