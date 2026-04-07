import 'package:equatable/equatable.dart';

class ShoppingListEvent extends Equatable {
  const ShoppingListEvent();
  @override
  List<Object?> get props => [];
}

class ShoppingListLoadRequested extends ShoppingListEvent {
  const ShoppingListLoadRequested({required this.planId, this.date});
  final int planId;
  final DateTime? date;
  @override
  List<Object?> get props => [planId, date];
}

class ShoppingItemToggled extends ShoppingListEvent {
  const ShoppingItemToggled(this.itemId);
  final int itemId;
  @override
  List<Object?> get props => [itemId];
}

class ShoppingItemAdded extends ShoppingListEvent {
  const ShoppingItemAdded({
    required this.planId,
    required this.name,
    required this.amount,
    required this.unit,
    required this.category,
  });
  final int planId;
  final String name;
  final double amount;
  final String unit;
  final String category;
  @override
  List<Object?> get props => [planId, name, amount, unit, category];
}

class ShoppingItemRemoved extends ShoppingListEvent {
  const ShoppingItemRemoved(this.itemId);
  final int itemId;
  @override
  List<Object?> get props => [itemId];
}

