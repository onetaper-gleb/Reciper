import 'package:flutter/material.dart';

class ReplaceMealBottomSheet extends StatefulWidget {
  const ReplaceMealBottomSheet({super.key, required this.onSubmit});

  final void Function(String reason, String? notes) onSubmit;

  @override
  State<ReplaceMealBottomSheet> createState() => _ReplaceMealBottomSheetState();
}

class _ReplaceMealBottomSheetState extends State<ReplaceMealBottomSheet> {
  final _controller = TextEditingController();
  String _reason = 'other';

  static const _reasons = [
    'no_ingredients',
    'too_long_to_cook',
    'dont_like',
    'other',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Причина замены'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _reasons
                .map(
                  (r) => ChoiceChip(
                    label: Text(r),
                    selected: _reason == r,
                    onSelected: (_) => setState(() => _reason = r),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Доп. комментарий',
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => widget.onSubmit(
                _reason,
                _controller.text.trim().isEmpty ? null : _controller.text.trim(),
              ),
              child: const Text('Заменить'),
            ),
          ),
        ],
      ),
    );
  }
}

