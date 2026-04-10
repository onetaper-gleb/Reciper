part of '../app_database.dart';

@DriftAccessor(tables: [ShoppingItems])
class ShoppingListDao extends DatabaseAccessor<AppDatabase>
    with _$ShoppingListDaoMixin {
  ShoppingListDao(super.db);

  Future<int> insertShoppingItem(ShoppingItemsCompanion row) =>
      into(shoppingItems).insert(row);

  Future<ShoppingListEntry?> getShoppingItemById(int id) =>
      (select(shoppingItems)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<ShoppingListEntry>> getAllShoppingItems() =>
      select(shoppingItems).get();

  Future<bool> updateShoppingItem(ShoppingListEntry row) =>
      update(shoppingItems).replace(row);

  Future<int> deleteShoppingItem(int id) =>
      (delete(shoppingItems)..where((t) => t.id.equals(id))).go();
}
