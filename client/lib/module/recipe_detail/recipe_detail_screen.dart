import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/dependencies_scope.dart';
import '../../domain/bloc/meal_plan/meal_plan_bloc.dart';
import '../../domain/bloc/meal_plan/meal_plan_event.dart';
import '../../domain/models/ingredient.dart';
import '../../domain/models/meal.dart';
import '../../domain/models/recipe.dart';
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
  });

  final Recipe recipe;
  final List<Ingredient> ingredients;
  final Meal meal;
  final int mealPlanId;

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  int _portions = 1;
  Set<String> _fridgeNames = const {};
  bool _favorite = false;
  final Set<int> _checkedIngredientIds = {};

  @override
  void initState() {
    super.initState();
    _favorite = widget.recipe.isFavorite;
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

  Future<void> _toggleFavorite() async {
    final db = DependenciesScope.of(context).database;
    final row = await db.recipeDao.getRecipeById(widget.recipe.id);
    if (row == null) return;
    await db.recipeDao.updateRecipe(row.copyWith(isFavorite: !_favorite));
    if (!mounted) return;
    setState(() => _favorite = !_favorite);
  }

  Future<void> _addMissingToShoppingList() async {
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
        title: Text(widget.recipe.title),
        actions: [
          IconButton(
            onPressed: _toggleFavorite,
            icon: Icon(_favorite ? Icons.favorite : Icons.favorite_border),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Wrap(
            spacing: 8,
            children: [
              Chip(label: Text('${widget.recipe.cookingTimeMinutes} мин')),
              Chip(label: Text('${widget.recipe.calories.toStringAsFixed(0)} ккал')),
              Chip(label: Text('${widget.recipe.servings} порц.')),
              Chip(label: Text(widget.recipe.difficulty.name)),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _Macro(title: 'Ккал', value: widget.recipe.calories),
                  _Macro(title: 'Б', value: widget.recipe.proteinG),
                  _Macro(title: 'Ж', value: widget.recipe.fatG),
                  _Macro(title: 'У', value: widget.recipe.carbsG),
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
          ...widget.recipe.steps.map(
            (step) => ListTile(
              leading: CircleAvatar(child: Text('${step.order}')),
              title: Text(step.instruction),
              trailing: step.durationSeconds == null
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.timer_outlined),
                      onPressed: () {
                        final sec = step.durationSeconds!;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Таймер на $sec сек. добавлен (MVP)')),
                        );
                      },
                    ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
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

