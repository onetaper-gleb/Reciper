import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:client/domain/bloc/shopping_list/shopping_list_bloc.dart';
import 'package:client/domain/bloc/shopping_list/shopping_list_event.dart';
import 'package:client/domain/bloc/shopping_list/shopping_list_state.dart';
import 'package:client/data/repository/shopping_list_repository.dart';

class _FakeShoppingRepo implements ShoppingListRepositoryBase {
  @override
  Future<List<ShoppingListItemData>> generateListFromPlan(
    int planId, {
    DateTime? date,
  }) async =>
      const [
        ShoppingListItemData(
          id: 1,
          mealPlanId: 1,
          name: 'Яйца',
          amount: 6,
          unit: 'шт',
          category: 'Белки',
          purchased: false,
          inFridge: true,
        ),
      ];

  @override
  Future<List<ShoppingListItemData>> getList(int planId, {DateTime? date}) =>
      generateListFromPlan(planId, date: date);

  @override
  Future<void> toggleItemBought(int itemId) async {}

  @override
  Future<void> addCustomItem({
    required int planId,
    required String name,
    required double amount,
    required String unit,
    required String category,
  }) async {}

  @override
  Future<void> removeItem(int itemId) async {}
}

void main() {
  blocTest<ShoppingListBloc, ShoppingListState>(
    'load emits ShoppingListLoaded',
    build: () => ShoppingListBloc(repository: _FakeShoppingRepo()),
    act: (bloc) => bloc.add(const ShoppingListLoadRequested(planId: 1)),
    expect: () => [isA<ShoppingListLoaded>()],
  );
}

