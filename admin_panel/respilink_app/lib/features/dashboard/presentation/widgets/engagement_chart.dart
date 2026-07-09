import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:respilink_app/core/theme/app_colors.dart';
import 'package:respilink_app/features/dashboard/data/model/engagement_data.dart';

class EngagementChart extends StatelessWidget {
  final List<EngagementDataPoint> data;
  final bool isMobile;

  const EngagementChart({super.key, required this.data, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('No analytical data available.'));
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: AppColors.borderLight.withValues(alpha: 0.6),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: isMobile ? 2 : 1,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index < 0 || index >= data.length) {
                  return const SizedBox.shrink();
                }

                final DateTime date = data[index].date;
                final String label = isMobile
                    ? DateFormat('E').format(date)[0]
                    : DateFormat('E').format(date);

                return SideTitleWidget(
                  meta: meta, // Directing placement calculations cleanly
                  space: 8,
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: isMobile ? 28 : 40,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  meta: meta,
                  //axisSide: meta.axisSide,
                  space: 4,
                  child: Text(
                    value.toInt().toString(),
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          // 1. Line definitions for Content Views
          LineChartBarData(
            spots: data
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.views.toDouble()))
                .toList(),
            isCurved: true,
            curveSmoothness: 0.35,
            color: AppColors.primary,
            barWidth: isMobile ? 2.5 : 3.5,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary.withValues(alpha: 0.2),
                  AppColors.primary.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
          // 2. Line definitions for Quiz Participations
          LineChartBarData(
            spots: data
                .asMap()
                .entries
                .map(
                  (e) => FlSpot(e.key.toDouble(), e.value.quizzes.toDouble()),
                )
                .toList(),
            isCurved: true,
            curveSmoothness: 0.35,
            color: Colors.deepPurpleAccent,
            barWidth: isMobile ? 2.5 : 3.5,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.deepPurpleAccent.withValues(alpha: 0.15),
                  Colors.deepPurpleAccent.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ],
        // Beautiful crosshair interactions tailored for precise desktop hover cursors
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) =>
                AppColors.textDark.withValues(alpha: 0.9),
            tooltipBorderRadius: .all(.circular(8)),
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((barSpot) {
                final String prefix = barSpot.barIndex == 0
                    ? 'Views: '
                    : 'Quizzes: ';
                return LineTooltipItem(
                  '$prefix${barSpot.y.toInt()}',
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
