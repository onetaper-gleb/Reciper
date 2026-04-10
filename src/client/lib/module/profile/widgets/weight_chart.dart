import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:client/domain/models/weight_entry.dart';

/// Line chart for body weight; optional horizontal target line.
class WeightChart extends StatelessWidget {
  const WeightChart({
    super.key,
    required this.entries,
    required this.targetWeightKg,
    required this.trendLabel,
  });

  final List<WeightEntry> entries;
  final double? targetWeightKg;
  final String trendLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (entries.length < 2) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            Text(
              'Добавьте минимум две записи веса, чтобы увидеть график.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              trendLabel,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      );
    }

    final sorted = [...entries]..sort((a, b) => a.entryDate.compareTo(b.entryDate));
    final spots = <FlSpot>[
      for (var i = 0; i < sorted.length; i++)
        FlSpot(i.toDouble(), sorted[i].weightKg),
    ];

    final weights = sorted.map((e) => e.weightKg).toList();
    var minY = weights.reduce((a, b) => a < b ? a : b) - 2;
    var maxY = weights.reduce((a, b) => a > b ? a : b) + 2;
    if (targetWeightKg != null) {
      minY = minY < targetWeightKg! ? minY : targetWeightKg! - 1;
      maxY = maxY > targetWeightKg! ? maxY : targetWeightKg! + 1;
    }
    if (maxY - minY < 4) {
      final mid = (minY + maxY) / 2;
      minY = mid - 2;
      maxY = mid + 2;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              lineTouchData: const LineTouchData(enabled: false),
              minY: minY,
              maxY: maxY,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: (maxY - minY) > 8 ? 2 : null,
                getDrawingHorizontalLine: (v) => FlLine(
                  color: theme.dividerColor.withValues(alpha: 0.4),
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(),
                rightTitles: const AxisTitles(),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (v, _) => Text(
                      v.toStringAsFixed(0),
                      style: theme.textTheme.labelSmall,
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    interval: sorted.length > 6 ? (sorted.length / 4).ceilToDouble() : 1,
                    getTitlesWidget: (v, meta) {
                      final i = v.round();
                      if (i < 0 || i >= sorted.length) return const SizedBox.shrink();
                      final d = sorted[i].entryDate;
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '${d.day}.${d.month}',
                          style: theme.textTheme.labelSmall,
                        ),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              extraLinesData: targetWeightKg != null
                  ? ExtraLinesData(
                      horizontalLines: [
                        HorizontalLine(
                          y: targetWeightKg!,
                          color: theme.colorScheme.secondary.withValues(alpha: 0.85),
                          strokeWidth: 1.2,
                          dashArray: [6, 4],
                        ),
                      ],
                    )
                  : null,
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: theme.colorScheme.primary,
                  barWidth: 3,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Тренд: $trendLabel',
          style: theme.textTheme.bodySmall?.copyWith(
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
