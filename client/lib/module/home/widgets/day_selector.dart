import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DaySelector extends StatelessWidget {
  const DaySelector({
    super.key,
    required this.days,
    required this.selectedDate,
    required this.onDaySelected,
  });

  final List<DateTime> days;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDaySelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final day = days[index];
          final selected = _same(day, selectedDate);
          return ChoiceChip(
            label: Text(DateFormat('EEE dd').format(day)),
            selected: selected,
            onSelected: (_) => onDaySelected(day),
          );
        },
      ),
    );
  }

  bool _same(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

