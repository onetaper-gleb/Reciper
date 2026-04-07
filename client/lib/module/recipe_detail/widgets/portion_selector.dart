import 'package:flutter/material.dart';

class PortionSelector extends StatelessWidget {
  const PortionSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const options = [1, 2, 4];
    return Wrap(
      spacing: 8,
      children: options
          .map(
            (p) => ChoiceChip(
              label: Text('$p порц.'),
              selected: value == p,
              onSelected: (_) => onChanged(p),
            ),
          )
          .toList(),
    );
  }
}

