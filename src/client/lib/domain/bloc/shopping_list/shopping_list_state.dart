import 'package:equatable/equatable.dart';

import '../../../data/repository/shopping_list_repository.dart';

class ShoppingListState extends Equatable {
  const ShoppingListState();
  @override
  List<Object?> get props => [];
}

class ShoppingListInitial extends ShoppingListState {
  const ShoppingListInitial();
}

class ShoppingListLoaded extends ShoppingListState {
  const ShoppingListLoaded({
    required this.planId,
    required this.date,
    required this.items,
  });
  final int planId;
  final DateTime? date;
  final List<ShoppingListItemData> items;

  Map<String, List<ShoppingListItemData>> get groupedByCategory {
    final map = <String, List<ShoppingListItemData>>{};
    for (final item in items) {
      map.putIfAbsent(item.category, () => []).add(item);
    }
    return map;
  }

  @override
  List<Object?> get props => [planId, date, items];
}

