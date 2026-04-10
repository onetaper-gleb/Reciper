import '../../data/local/db/app_database.dart';
import '../../domain/models/ingredient.dart';

class RecipeIngredientView {
  const RecipeIngredientView({
    required this.ingredient,
    required this.amount,
    required this.inFridge,
  });

  final Ingredient ingredient;
  final double amount;
  final bool inFridge;
}

abstract final class RecipeDetailController {
  static List<Ingredient> scaleIngredients({
    required List<Ingredient> ingredients,
    required int portions,
  }) {
    return ingredients
        .map((i) => i.copyWith(amount: i.amount * portions))
        .toList();
  }

  static List<RecipeIngredientView> buildIngredientViews({
    required List<Ingredient> ingredients,
    required Set<String> fridgeNames,
    required int portions,
  }) {
    final normalized = fridgeNames.map(_normalize).toSet();
    return scaleIngredients(
      ingredients: ingredients,
      portions: portions,
    ).map((i) {
      return RecipeIngredientView(
        ingredient: i,
        amount: i.amount,
        inFridge: normalized.contains(_normalize(i.name)),
      );
    }).toList();
  }

  static Future<int> addMissingToShoppingList({
    required AppDatabase database,
    required int mealPlanId,
    required List<Ingredient> ingredients,
    required Set<String> fridgeNames,
    required int portions,
  }) async {
    final views = buildIngredientViews(
      ingredients: ingredients,
      fridgeNames: fridgeNames,
      portions: portions,
    );
    var inserted = 0;
    for (final item in views.where((v) => !v.inFridge)) {
      await database.shoppingListDao.insertShoppingItem(
        ShoppingItemsCompanion.insert(
          mealPlanId: mealPlanId,
          name: item.ingredient.name,
          amount: item.amount,
          unit: item.ingredient.unit,
          category: item.ingredient.category,
        ),
      );
      inserted += 1;
    }
    return inserted;
  }

  static String _normalize(String value) => value.trim().toLowerCase();
}

