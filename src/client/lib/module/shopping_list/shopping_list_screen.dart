import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/dependencies_scope.dart';
import '../../domain/bloc/shopping_list/shopping_list_bloc.dart';
import '../../domain/bloc/shopping_list/shopping_list_event.dart';
import '../../domain/bloc/shopping_list/shopping_list_state.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({
    super.key,
    required this.planId,
    this.date,
  });

  final int planId;
  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);
    return BlocProvider(
      create: (_) => ShoppingListBloc(repository: deps.shoppingListRepository)
        ..add(ShoppingListLoadRequested(planId: planId, date: date)),
      child: _ShoppingListView(planId: planId, date: date),
    );
  }
}

class _ShoppingListView extends StatelessWidget {
  const _ShoppingListView({required this.planId, required this.date});
  final int planId;
  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список покупок'),
        actions: [
          IconButton(
            onPressed: () => _shareList(context),
            icon: const Icon(Icons.share_outlined),
          ),
        ],
      ),
      body: BlocBuilder<ShoppingListBloc, ShoppingListState>(
        builder: (context, state) {
          if (state is! ShoppingListLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          final grouped = state.groupedByCategory;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                date == null ? 'Все дни' : 'На выбранный день',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              ...grouped.entries.map((entry) {
                return ExpansionTile(
                  title: Text(entry.key),
                  children: entry.value.map((item) {
                    return Dismissible(
                      key: ValueKey(item.id),
                      onDismissed: (_) =>
                          context.read<ShoppingListBloc>().add(ShoppingItemRemoved(item.id)),
                      child: CheckboxListTile(
                        value: item.purchased,
                        onChanged: (_) => context
                            .read<ShoppingListBloc>()
                            .add(ShoppingItemToggled(item.id)),
                        title: Text(
                          '${item.name} — ${item.amount.toStringAsFixed(1)} ${item.unit}',
                          style: TextStyle(
                            decoration:
                                item.inFridge ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        subtitle: item.inFridge ? const Text('Есть в холодильнике') : null,
                      ),
                    );
                  }).toList(),
                );
              }),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addCustomItem(context, planId),
        icon: const Icon(Icons.add),
        label: const Text('Добавить'),
      ),
    );
  }

  Future<void> _addCustomItem(BuildContext context, int planId) async {
    final bloc = context.read<ShoppingListBloc>();
    final name = TextEditingController();
    final amount = TextEditingController(text: '1');
    final unit = TextEditingController(text: 'шт');
    final category = TextEditingController(text: 'Другое');
    final ok = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Добавить вручную'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: name, decoration: const InputDecoration(labelText: 'Название')),
                TextField(controller: amount, decoration: const InputDecoration(labelText: 'Количество')),
                TextField(controller: unit, decoration: const InputDecoration(labelText: 'Единица')),
                TextField(controller: category, decoration: const InputDecoration(labelText: 'Категория')),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Отмена')),
              ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Добавить')),
            ],
          ),
        ) ??
        false;
    if (!ok) return;
    bloc.add(
          ShoppingItemAdded(
            planId: planId,
            name: name.text.trim(),
            amount: double.tryParse(amount.text.trim()) ?? 1,
            unit: unit.text.trim(),
            category: category.text.trim(),
          ),
        );
  }

  Future<void> _shareList(BuildContext context) async {
    final state = context.read<ShoppingListBloc>().state;
    if (state is! ShoppingListLoaded) return;
    final lines = <String>['Список покупок'];
    for (final item in state.items) {
      final mark = item.purchased ? '[x]' : '[ ]';
      lines.add('$mark ${item.name} — ${item.amount} ${item.unit}');
    }
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Поделиться'),
        content: SelectableText(lines.join('\n')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }
}

