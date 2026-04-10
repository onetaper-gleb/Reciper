import 'package:flutter/material.dart';

import '../../../core/utils/calendar_week.dart';

String _formatDayMonthRu(DateTime d) {
  const months = <String>[
    '',
    'янв',
    'фев',
    'мар',
    'апр',
    'мая',
    'июн',
    'июл',
    'авг',
    'сен',
    'окт',
    'ноя',
    'дек',
  ];
  return '${d.day} ${months[d.month]}';
}

/// Week strip Mon–Sun with horizontal paging between weeks.
/// [daysWithPlanData]: date-only keys for days that exist in the **active** plan.
class DaySelector extends StatefulWidget {
  const DaySelector({
    super.key,
    required this.selectedDate,
    required this.onDaySelected,
    this.daysWithPlanData,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDaySelected;
  final Set<DateTime>? daysWithPlanData;

  static const _shortWeekdays = <int, String>{
    DateTime.monday: 'Пн',
    DateTime.tuesday: 'Вт',
    DateTime.wednesday: 'Ср',
    DateTime.thursday: 'Чт',
    DateTime.friday: 'Пт',
    DateTime.saturday: 'Сб',
    DateTime.sunday: 'Вс',
  };

  @override
  State<DaySelector> createState() => _DaySelectorState();
}

class _DaySelectorState extends State<DaySelector> {
  static const _kCenterPage = 100000;

  late DateTime _anchorMonday;
  late PageController _controller;
  late int _visiblePageIndex;

  @override
  void initState() {
    super.initState();
    _anchorMonday = CalendarWeek.mondayOfWeek(widget.selectedDate);
    final off = CalendarWeek.weeksBetweenMondays(
      _anchorMonday,
      CalendarWeek.mondayOfWeek(widget.selectedDate),
    );
    _visiblePageIndex = _kCenterPage + off;
    _controller = PageController(initialPage: _visiblePageIndex);
  }

  @override
  void didUpdateWidget(covariant DaySelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldM = CalendarWeek.mondayOfWeek(oldWidget.selectedDate);
    final newM = CalendarWeek.mondayOfWeek(widget.selectedDate);
    if (!CalendarWeek.isSameDay(oldM, newM)) {
      final off = CalendarWeek.weeksBetweenMondays(_anchorMonday, newM);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final target = _kCenterPage + off;
        if (_controller.hasClients) {
          _controller.jumpToPage(target);
          setState(() => _visiblePageIndex = target);
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  DateTime _mondayForPage(int page) {
    return _anchorMonday.add(Duration(days: (page - _kCenterPage) * 7));
  }

  @override
  Widget build(BuildContext context) {
    final today = CalendarWeek.todayDateOnly();
    final monLabel = _mondayForPage(_visiblePageIndex);
    final sunLabel = monLabel.add(const Duration(days: 6));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            '${_formatDayMonthRu(monLabel)} — ${_formatDayMonthRu(sunLabel)}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        SizedBox(
          height: 96,
          child: PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _visiblePageIndex = i),
            itemBuilder: (context, index) {
              final mon = _mondayForPage(index);
              final weekDays = List.generate(7, (i) => mon.add(Duration(days: i)));
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: weekDays.map((day) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: _DayCell(
                        day: day,
                        today: today,
                        selectedDate: widget.selectedDate,
                        daysWithPlanData: widget.daysWithPlanData,
                        shortWeekdays: DaySelector._shortWeekdays,
                        onTap: () => widget.onDaySelected(CalendarWeek.dateOnly(day)),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.today,
    required this.selectedDate,
    required this.daysWithPlanData,
    required this.shortWeekdays,
    required this.onTap,
  });

  final DateTime day;
  final DateTime today;
  final DateTime selectedDate;
  final Set<DateTime>? daysWithPlanData;
  final Map<int, String> shortWeekdays;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final selected = CalendarWeek.isSameDay(day, selectedDate);
    final isToday = CalendarWeek.isSameDay(day, today);
    final wd = shortWeekdays[day.weekday] ?? '';
    final inActivePlan = _hasActivePlanDay(day);

    final baseColor = selected
        ? scheme.primaryContainer
        : scheme.surfaceContainerHighest.withValues(
            alpha: inActivePlan ? 0.85 : 0.55,
          );

    return Material(
      color: baseColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: isToday && !selected
                ? Border.all(color: scheme.primary, width: 2)
                : isToday && selected
                    ? Border.all(color: scheme.primary.withValues(alpha: 0.5), width: 2)
                    : null,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                wd,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: selected
                          ? scheme.onPrimaryContainer
                          : scheme.onSurfaceVariant.withValues(
                              alpha: inActivePlan ? 1 : 0.72,
                            ),
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                '${day.day}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: selected
                          ? scheme.onPrimaryContainer
                          : scheme.onSurface.withValues(
                              alpha: inActivePlan ? 1 : 0.72,
                            ),
                    ),
              ),
              if (isToday)
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: selected ? scheme.onPrimaryContainer : scheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  bool _hasActivePlanDay(DateTime day) {
    if (daysWithPlanData == null || daysWithPlanData!.isEmpty) return true;
    return daysWithPlanData!.contains(CalendarWeek.dateOnly(day));
  }
}
