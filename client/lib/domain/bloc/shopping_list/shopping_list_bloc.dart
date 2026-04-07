import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repository/shopping_list_repository.dart';
import 'shopping_list_event.dart';
import 'shopping_list_state.dart';

class ShoppingListBloc extends Bloc<ShoppingListEvent, ShoppingListState> {
  ShoppingListBloc({required ShoppingListRepositoryBase repository})
      : _repo = repository,
        super(const ShoppingListInitial()) {
    on<ShoppingListLoadRequested>(_onLoad);
    on<ShoppingItemToggled>(_onToggle);
    on<ShoppingItemAdded>(_onAdd);
    on<ShoppingItemRemoved>(_onRemove);
  }

  final ShoppingListRepositoryBase _repo;

  Future<void> _onLoad(
    ShoppingListLoadRequested event,
    Emitter<ShoppingListState> emit,
  ) async {
    final items = await _repo.generateListFromPlan(event.planId, date: event.date);
    emit(ShoppingListLoaded(planId: event.planId, date: event.date, items: items));
  }

  Future<void> _onToggle(
    ShoppingItemToggled event,
    Emitter<ShoppingListState> emit,
  ) async {
    final current = state;
    if (current is! ShoppingListLoaded) return;
    await _repo.toggleItemBought(event.itemId);
    final refreshed = await _repo.getList(current.planId, date: current.date);
    emit(ShoppingListLoaded(planId: current.planId, date: current.date, items: refreshed));
  }

  Future<void> _onAdd(
    ShoppingItemAdded event,
    Emitter<ShoppingListState> emit,
  ) async {
    final current = state;
    if (current is! ShoppingListLoaded) return;
    await _repo.addCustomItem(
      planId: event.planId,
      name: event.name,
      amount: event.amount,
      unit: event.unit,
      category: event.category,
    );
    final refreshed = await _repo.getList(current.planId, date: current.date);
    emit(ShoppingListLoaded(planId: current.planId, date: current.date, items: refreshed));
  }

  Future<void> _onRemove(
    ShoppingItemRemoved event,
    Emitter<ShoppingListState> emit,
  ) async {
    final current = state;
    if (current is! ShoppingListLoaded) return;
    await _repo.removeItem(event.itemId);
    final refreshed = await _repo.getList(current.planId, date: current.date);
    emit(ShoppingListLoaded(planId: current.planId, date: current.date, items: refreshed));
  }
}

