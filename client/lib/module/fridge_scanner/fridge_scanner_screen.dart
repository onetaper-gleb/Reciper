import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../app/dependencies_scope.dart';
import '../../data/repository/fridge_repository.dart';
import '../../domain/bloc/fridge/fridge_bloc.dart';
import '../../domain/bloc/fridge/fridge_event.dart';
import '../../domain/bloc/fridge/fridge_state.dart';

class FridgeScannerScreen extends StatelessWidget {
  const FridgeScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);
    return BlocProvider(
      create: (_) => FridgeBloc(repository: deps.fridgeRepository)
        ..add(const FridgeLoadRequested()),
      child: const _FridgeScannerView(),
    );
  }
}

class _FridgeScannerView extends StatefulWidget {
  const _FridgeScannerView();

  @override
  State<_FridgeScannerView> createState() => _FridgeScannerViewState();
}

class _FridgeScannerViewState extends State<_FridgeScannerView> {
  final _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Сканер')),
      body: BlocBuilder<FridgeBloc, FridgeState>(
        builder: (context, state) {
          if (state is FridgeScanning) {
            return const _ScanningView();
          }

          if (state is FridgeScanResult) {
            return _ScanResult(
              state: state,
              onConfirm: (products) {
                context.read<FridgeBloc>().add(
                      FridgeProductsConfirmed(products, state.imageFile.path),
                    );
              },
              onAppend: () => _pickAndScan(context, append: true),
            );
          }

          if (state is FridgeLoaded) {
            if (state.products.isEmpty) {
              return _EmptyFridgeView(
                onCameraTap: () => _pickAndScan(context, source: ImageSource.camera),
                onGalleryTap: () => _pickAndScan(context, source: ImageSource.gallery),
              );
            }
            return _LoadedFridgeView(
              state: state,
              onRescan: () => _pickAndScan(context),
              onAppend: () => _pickAndScan(context, append: true),
              onRemove: (name) => context.read<FridgeBloc>().add(
                    FridgeProductRemoved(name),
                  ),
              onManualAdd: (product) => context.read<FridgeBloc>().add(
                    FridgeProductAdded(product),
                  ),
            );
          }

          if (state is FridgeError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Future<void> _pickAndScan(
    BuildContext context, {
    ImageSource source = ImageSource.gallery,
    bool append = false,
  }) async {
    final bloc = context.read<FridgeBloc>();
    final picked = await _picker.pickImage(source: source);
    if (picked == null) return;
    final file = File(picked.path);
    if (append) {
      bloc.add(FridgeAppendScanStarted(file));
      return;
    }
    bloc.add(FridgeScanStarted(file));
  }
}

class _EmptyFridgeView extends StatelessWidget {
  const _EmptyFridgeView({
    required this.onCameraTap,
    required this.onGalleryTap,
  });
  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 24),
        const Icon(Icons.kitchen_outlined, size: 80),
        const SizedBox(height: 16),
        Text(
          'Покажите мне, что у вас в холодильнике, и я предложу подходящие рецепты!',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: onCameraTap,
          icon: const Icon(Icons.photo_camera_outlined),
          label: const Text('Сфотографировать'),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: onGalleryTap,
          icon: const Icon(Icons.photo_library_outlined),
          label: const Text('Загрузить фото'),
        ),
      ],
    );
  }
}

class _ScanningView extends StatelessWidget {
  const _ScanningView();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Colors.black12),
        const Center(child: CircularProgressIndicator()),
        const Positioned(
          left: 16,
          right: 16,
          bottom: 32,
          child: Text(
            'Сканирую фото и распознаю продукты...',
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class _LoadedFridgeView extends StatelessWidget {
  const _LoadedFridgeView({
    required this.state,
    required this.onRescan,
    required this.onAppend,
    required this.onRemove,
    required this.onManualAdd,
  });

  final FridgeLoaded state;
  final VoidCallback onRescan;
  final VoidCallback onAppend;
  final ValueChanged<String> onRemove;
  final ValueChanged<FridgeProductData> onManualAdd;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          state.lastScanDate == null
              ? 'Холодильник заполнен'
              : 'Последнее обновление: ${state.lastScanDate}',
        ),
        const SizedBox(height: 10),
        ...state.products.map(
          (p) => ListTile(
            leading: const Icon(Icons.inventory_2_outlined),
            title: Text(p.name),
            subtitle: Text('${p.amount} ${p.unit}'),
            trailing: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => onRemove(p.name),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            OutlinedButton.icon(
              onPressed: onRescan,
              icon: const Icon(Icons.refresh),
              label: const Text('Пересканировать'),
            ),
            OutlinedButton.icon(
              onPressed: onAppend,
              icon: const Icon(Icons.add_a_photo_outlined),
              label: const Text('Дополнить'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () async {
            final added = await _showManualProductDialog(context);
            if (added != null) onManualAdd(added);
          },
          icon: const Icon(Icons.add),
          label: const Text('Добавить продукт вручную'),
        ),
        const SizedBox(height: 10),
        ExpansionTile(
          title: const Text('История сканирований'),
          children: state.history.take(3).map((h) {
            return ListTile(
              leading: const Icon(Icons.image_outlined),
              title: Text(h.photoPath),
              subtitle: Text('${h.scanDate} • ${h.productCount} продуктов'),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.restaurant_menu_outlined),
          label: const Text('Показать рецепты из моих продуктов'),
        ),
      ],
    );
  }
}

class _ScanResult extends StatefulWidget {
  const _ScanResult({
    required this.state,
    required this.onConfirm,
    required this.onAppend,
  });
  final FridgeScanResult state;
  final ValueChanged<List<FridgeProductData>> onConfirm;
  final VoidCallback onAppend;

  @override
  State<_ScanResult> createState() => _ScanResultState();
}

class _ScanResultState extends State<_ScanResult> {
  late List<FridgeProductData> _products;
  final _selectedNames = <String>{};

  @override
  void initState() {
    super.initState();
    _products = [...widget.state.recognizedProducts];
    _selectedNames.addAll(_products.map((e) => e.name));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          height: 170,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: FileImage(widget.state.imageFile),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ..._products.map(
          (p) => ListTile(
            leading: Checkbox(
              value: _selectedNames.contains(p.name),
              onChanged: (v) => setState(() {
                if (v ?? false) {
                  _selectedNames.add(p.name);
                } else {
                  _selectedNames.remove(p.name);
                }
              }),
            ),
            title: Text(p.name),
            subtitle: Row(
              children: [
                Expanded(
                  child: Text(
                    '${p.amount} ${p.unit} • уверенность ${(p.confidence * 100).toStringAsFixed(0)}%',
                  ),
                ),
                SizedBox(
                  width: 90,
                  child: TextFormField(
                    initialValue: p.amount.toString(),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) {
                      final parsed = double.tryParse(v);
                      if (parsed == null) return;
                      final idx = _products.indexOf(p);
                      if (idx < 0) return;
                      _products[idx] = p.copyWith(amount: parsed);
                    },
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => setState(() {
                _selectedNames.remove(p.name);
                _products.remove(p);
              }),
            ),
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () async {
            final added = await _showManualProductDialog(context);
            if (added == null) return;
            setState(() {
              _products.add(added);
              _selectedNames.add(added.name);
            });
          },
          icon: const Icon(Icons.add),
          label: const Text('Добавить продукт вручную'),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: widget.onAppend,
          icon: const Icon(Icons.add_a_photo_outlined),
          label: const Text('Досканировать'),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => widget.onConfirm(
            _products.where((p) => _selectedNames.contains(p.name)).toList(),
          ),
          child: const Text('Подтвердить список'),
        ),
        TextButton(
          onPressed: () => context.read<FridgeBloc>().add(const FridgeLoadRequested()),
          child: const Text('Отмена'),
        ),
      ],
    );
  }
}

Future<FridgeProductData?> _showManualProductDialog(BuildContext context) async {
  final nameController = TextEditingController();
  final amountController = TextEditingController(text: '1');
  final unitController = TextEditingController(text: 'шт');
  final categoryController = TextEditingController(text: 'other');

  final result = await showDialog<FridgeProductData>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Добавить продукт'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Название'),
          ),
          TextField(
            controller: amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Количество'),
          ),
          TextField(
            controller: unitController,
            decoration: const InputDecoration(labelText: 'Ед. изм.'),
          ),
          TextField(
            controller: categoryController,
            decoration: const InputDecoration(labelText: 'Категория'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            final name = nameController.text.trim();
            final amount = double.tryParse(amountController.text.trim()) ?? 0;
            if (name.isEmpty || amount <= 0) return;
            Navigator.of(context).pop(
              FridgeProductData(
                name: name,
                amount: amount,
                unit: unitController.text.trim().isEmpty
                    ? 'шт'
                    : unitController.text.trim(),
                category: categoryController.text.trim().isEmpty
                    ? 'other'
                    : categoryController.text.trim(),
              ),
            );
          },
          child: const Text('Добавить'),
        ),
      ],
    ),
  );

  nameController.dispose();
  amountController.dispose();
  unitController.dispose();
  categoryController.dispose();
  return result;
}
