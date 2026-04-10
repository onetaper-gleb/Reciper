import 'package:drift/drift.dart';

import '../local/db/app_database.dart';

class ShoppingListItemData {
  const ShoppingListItemData({
    required this.id,
    required this.mealPlanId,
    required this.name,
    required this.amount,
    required this.unit,
    required this.category,
    required this.purchased,
    required this.inFridge,
  });

  final int id;
  final int mealPlanId;
  final String name;
  final double amount;
  final String unit;
  final String category;
  final bool purchased;
  final bool inFridge;
}

abstract class ShoppingListRepositoryBase {
  Future<List<ShoppingListItemData>> generateListFromPlan(
    int planId, {
    DateTime? date,
  });
  Future<List<ShoppingListItemData>> getList(int planId, {DateTime? date});
  Future<void> toggleItemBought(int itemId);
  Future<void> addCustomItem({
    required int planId,
    required String name,
    required double amount,
    required String unit,
    required String category,
  });
  Future<void> removeItem(int itemId);
}

class ShoppingListRepository implements ShoppingListRepositoryBase {
  ShoppingListRepository({required AppDatabase database}) : _db = database;
  final AppDatabase _db;

  @override
  Future<List<ShoppingListItemData>> generateListFromPlan(
    int planId, {
    DateTime? date,
  }) async {
    final days = (await _db.mealPlanDao.getAllDayPlans())
        .where((d) => d.mealPlanId == planId)
        .where((d) => date == null || _sameDate(d.planDate, date))
        .toList();
    final dayIds = days.map((d) => d.id).toSet();
    final meals = (await _db.mealPlanDao.getAllMeals())
        .where((m) => dayIds.contains(m.dayPlanId))
        .toList();
    final recipeIds = meals.map((m) => m.recipeId).toSet();
    final ingredients = (await _db.recipeDao.getAllIngredients())
        .where((i) => recipeIds.contains(i.recipeId))
        .toList();
    final fridge = await _db.fridgeDao.getAllFridgeProducts();
    final inFridgeNames = fridge.map((f) => _norm(f.name)).toSet();

    final aggregated = <String, ({double amount, String name, String unit, String category, bool inFridge})>{};
    for (final i in ingredients) {
      final key = '${_norm(i.name)}|${_norm(i.unit)}';
      final prev = aggregated[key];
      final current = prev?.amount ?? 0;
      aggregated[key] = (
        amount: current + i.amount,
        name: i.name,
        unit: i.unit,
        category: i.category,
        inFridge: inFridgeNames.contains(_norm(i.name)),
      );
    }

    final existing = await _db.shoppingListDao.getAllShoppingItems();
    for (final row in existing.where((e) => e.mealPlanId == planId)) {
      await _db.shoppingListDao.deleteShoppingItem(row.id);
    }

    for (final item in aggregated.values) {
      await _db.shoppingListDao.insertShoppingItem(
        ShoppingItemsCompanion.insert(
          mealPlanId: planId,
          name: item.name,
          amount: item.amount,
          unit: item.unit,
          category: item.category,
          inFridge: Value(item.inFridge),
        ),
      );
    }

    return getList(planId, date: date);
  }

  @override
  Future<List<ShoppingListItemData>> getList(int planId, {DateTime? date}) async {
    final all = await _db.shoppingListDao.getAllShoppingItems();
    return all
        .where((e) => e.mealPlanId == planId)
        .map(
          (e) => ShoppingListItemData(
            id: e.id,
            mealPlanId: e.mealPlanId,
            name: e.name,
            amount: e.amount,
            unit: e.unit,
            category: e.category,
            purchased: e.purchased,
            inFridge: e.inFridge,
          ),
        )
        .toList();
  }

  @override
  Future<void> toggleItemBought(int itemId) async {
    final row = await _db.shoppingListDao.getShoppingItemById(itemId);
    if (row == null) return;
    await _db.shoppingListDao.updateShoppingItem(
      row.copyWith(purchased: !row.purchased),
    );
  }

  @override
  Future<void> addCustomItem({
    required int planId,
    required String name,
    required double amount,
    required String unit,
    required String category,
  }) async {
    await _db.shoppingListDao.insertShoppingItem(
      ShoppingItemsCompanion.insert(
        mealPlanId: planId,
        name: name,
        amount: amount,
        unit: unit,
        category: category,
        inFridge: const Value(false),
      ),
    );
  }

  @override
  Future<void> removeItem(int itemId) async {
    await _db.shoppingListDao.deleteShoppingItem(itemId);
  }

  static bool _sameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
  static String _norm(String s) => s.trim().toLowerCase();
}

