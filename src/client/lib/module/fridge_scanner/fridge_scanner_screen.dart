import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

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
      appBar: AppBar(title: const Text('Холодильник и сканер')),
      body: BlocBuilder<FridgeBloc, FridgeState>(
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: _buildContentForState(context, state),
          );
        },
      ),
    );
  }

  Widget _buildContentForState(BuildContext context, FridgeState state) {
    if (state is FridgeScanning) {
      return const _ScanningView();
    }

    if (state is FridgeScanResult) {
      return _ScanResult(
        key: const ValueKey('scan_result'),
        state: state,
        onConfirm: (products) {
          context.read<FridgeBloc>().add(
                FridgeProductsConfirmed(products, state.imageFile.path),
              );
        },
        onAppend: () => _pickAndScan(context, append: true),
        onManualAdd: (product) => context.read<FridgeBloc>().add(
              FridgeProductAdded(product),
            ),
      );
    }

    if (state is FridgeLoaded) {
      if (state.products.isEmpty) {
        return _EmptyFridgeView(
          key: const ValueKey('empty_fridge'),
          onCameraTap: () => _pickAndScan(context, source: ImageSource.camera),
          onGalleryTap: () => _pickAndScan(context, source: ImageSource.gallery),
        );
      }
      return _LoadedFridgeView(
        key: const ValueKey('loaded_fridge'),
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
      return _FridgeErrorView(
        key: const ValueKey('fridge_error'),
        message: state.message,
        onBack: () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
            return;
          }
          context.read<FridgeBloc>().add(const FridgeLoadRequested());
        },
        onRetry: () => context.read<FridgeBloc>().add(const FridgeLoadRequested()),
      );
    }

    return const SizedBox.shrink();
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
    super.key,
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
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(Icons.kitchen_outlined, size: 60),
        ),
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
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Сканирую фото и распознаю продукты...'),
          SizedBox(height: 4),
          Text('Это может занять несколько секунд'),
        ],
      ),
    );
  }
}

class _LoadedFridgeView extends StatelessWidget {
  const _LoadedFridgeView({
    super.key,
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
    final dateFmt = DateFormat('dd.MM.yyyy HH:mm');
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                const Icon(Icons.inventory_2_outlined),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    state.lastScanDate == null
                        ? 'Продукты в холодильнике'
                        : 'Обновлено: ${dateFmt.format(state.lastScanDate!.toLocal())}',
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        ...state.products.map(
          (p) => Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.egg_alt_outlined)),
              title: Text(p.name),
              subtitle: Text('${p.amount} ${p.unit}'),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => onRemove(p.name),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
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
        const SizedBox(height: 14),
        _ManualProductInlineForm(onSubmit: onManualAdd),
        const SizedBox(height: 6),
        ExpansionTile(
          title: const Text('История сканирований'),
          children: state.history.take(3).map((h) {
            return ListTile(
              leading: const Icon(Icons.image_outlined),
              title: Text(h.photoPath.split(Platform.pathSeparator).last),
              subtitle: Text(
                '${dateFmt.format(h.scanDate.toLocal())} • ${h.productCount} продуктов',
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ScanResult extends StatefulWidget {
  const _ScanResult({
    super.key,
    required this.state,
    required this.onConfirm,
    required this.onAppend,
    required this.onManualAdd,
  });
  final FridgeScanResult state;
  final ValueChanged<List<FridgeProductData>> onConfirm;
  final VoidCallback onAppend;
  final ValueChanged<FridgeProductData> onManualAdd;

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
        Text(
          'Проверьте распознанные продукты',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 4),
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
        _ManualProductInlineForm(
          onSubmit: (added) {
            widget.onManualAdd(added);
            setState(() {
              _products.add(added);
              _selectedNames.add(added.name);
            });
          },
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

class _ManualProductInlineForm extends StatefulWidget {
  const _ManualProductInlineForm({required this.onSubmit});

  final ValueChanged<FridgeProductData> onSubmit;

  @override
  State<_ManualProductInlineForm> createState() => _ManualProductInlineFormState();
}

class _ManualProductInlineFormState extends State<_ManualProductInlineForm> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController(text: '1');
  final _unitController = TextEditingController(text: 'шт');
  final _categoryController = TextEditingController(text: 'other');

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _unitController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    if (name.isEmpty || amount <= 0) return;
    widget.onSubmit(
      FridgeProductData(
        name: name,
        amount: amount,
        unit: _unitController.text.trim().isEmpty ? 'шт' : _unitController.text.trim(),
        category: _categoryController.text.trim().isEmpty
            ? 'other'
            : _categoryController.text.trim(),
      ),
    );
    _nameController.clear();
    _amountController.text = '1';
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.add_box_outlined),
                const SizedBox(width: 8),
                Text(
                  'Добавить вручную',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Название',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Количество',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _unitController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Ед. изм.',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _categoryController,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
              decoration: const InputDecoration(
                labelText: 'Категория',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.add),
                label: const Text('Добавить продукт'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FridgeErrorView extends StatelessWidget {
  const _FridgeErrorView({
    super.key,
    required this.message,
    required this.onBack,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onBack;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 48),
            const SizedBox(height: 12),
            Text(
              'Не удалось выполнить запрос',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Назад'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Повторить'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
