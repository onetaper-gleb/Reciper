import 'package:flutter/material.dart';

class TimerWidget extends StatelessWidget {
  const TimerWidget({
    super.key,
    required this.remainingSeconds,
    required this.onStartFromStep,
    this.stepDurationSeconds,
  });

  final int? remainingSeconds;
  final int? stepDurationSeconds;
  final VoidCallback onStartFromStep;

  String _format(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (remainingSeconds != null) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.timer_outlined, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Text(
                _format(remainingSeconds!),
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (stepDurationSeconds != null && stepDurationSeconds! > 0) {
      final sec = stepDurationSeconds!;
      final label = sec >= 60
          ? 'На этом шаге указано ~${sec ~/ 60} мин. Поставить таймер?'
          : 'Поставить таймер на $sec с?';
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: OutlinedButton.icon(
          onPressed: onStartFromStep,
          icon: const Icon(Icons.timer_outlined),
          label: Text(label),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
