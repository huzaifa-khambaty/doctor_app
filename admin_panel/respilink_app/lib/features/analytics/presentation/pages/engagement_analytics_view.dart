import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_app/core/theme/app_colors.dart';
import 'package:respilink_app/features/analytics/data/model/analytics_model.dart';
import 'package:respilink_app/features/analytics/presentation/bloc/analytics_bloc.dart';
import 'package:respilink_app/features/analytics/presentation/bloc/analytics_event.dart';
import 'package:respilink_app/features/analytics/presentation/bloc/analytics_state.dart';

class EngagementAnalyticsContent extends StatelessWidget {
  const EngagementAnalyticsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsBloc, AnalyticsState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(32.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _AnalyticsHeaderActionRow(),
                const SizedBox(height: 24),
                _AnalyticsMetricsGrid(statCards: state.data?.statCards, isLoading: state.isLoading),
                const SizedBox(height: 24),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final trendsCard = _EngagementTrendsChartCard(
                      trends: state.data?.engagementTrends,
                      isLoading: state.isLoading,
                      selectedPeriod: state.selectedPeriod,
                    );
                    final specialtyCard = _GrowthBySpecialtyCard(
                      items: state.data?.growthBySpecialty ?? [],
                      isLoading: state.isLoading,
                    );
                    if (constraints.maxWidth < 1100) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          trendsCard,
                          const SizedBox(height: 20),
                          specialtyCard,
                        ],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: trendsCard),
                        const SizedBox(width: 20),
                        Expanded(flex: 1, child: specialtyCard),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final contentCard = _TopPerformingContentCard(
                      items: state.data?.topPerformingContent ?? [],
                      isLoading: state.isLoading,
                    );
                    if (constraints.maxWidth < 1100) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          contentCard,
                          const SizedBox(height: 20),
                          const _ActivityStreamCard(),
                        ],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: contentCard),
                        const SizedBox(width: 20),
                        const Expanded(flex: 1, child: _ActivityStreamCard()),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// =========================================================================
// 1. Header
// =========================================================================
class _AnalyticsHeaderActionRow extends StatelessWidget {
  const _AnalyticsHeaderActionRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'RESPILINK DASHBOARD',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textMuted.withValues(alpha: 0.7), letterSpacing: 0.5),
            ),
            const SizedBox(height: 4),
            const Text(
              'Engagement Analytics',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
          ],
        ),
        // const Spacer(),
        // OutlinedButton.icon(
        //   onPressed: () {},
        //   icon: const Icon(Icons.file_download_outlined, size: 14, color: AppColors.textDark),
        //   label: const Text('Export Report', style: TextStyle(color: AppColors.textDark, fontSize: 13, fontWeight: FontWeight.w600)),
        //   style: OutlinedButton.styleFrom(
        //     backgroundColor: Colors.white,
        //     side: const BorderSide(color: AppColors.borderLight),
        //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        //     padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        //   ),
        // ),
      ],
    );
  }
}

// =========================================================================
// 2. Metrics Grid
// =========================================================================
class _AnalyticsMetricsGrid extends StatelessWidget {
  final StatCards? statCards;
  final bool isLoading;

  const _AnalyticsMetricsGrid({this.statCards, required this.isLoading});

  String _fmtChange(double change) {
    if (change == 0) return '0%';
    return '${change > 0 ? '+' : ''}${change.toStringAsFixed(1)}%';
  }

  @override
  Widget build(BuildContext context) {
    final doctors = statCards?.totalActiveDoctors;
    final quiz = statCards?.avgQuizScore;
    final rsvp = statCards?.eventRsvpRate;
    final reach = statCards?.contentReach;

    return LayoutBuilder(
      builder: (context, constraints) {
        double itemWidth = (constraints.maxWidth - (3 * 16)) / 4;
        if (itemWidth < 220) itemWidth = 220;

        if (isLoading) {
          return Wrap(
            spacing: 16,
            runSpacing: 16,
            children: List.generate(4, (_) => _SkeletonCard(width: itemWidth)),
          );
        }

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _MetricSummaryTile(
              width: itemWidth,
              title: 'Total Active Doctors',
              value: doctors?.count.toString() ?? '—',
              icon: Icons.people_outline,
              iconColor: Colors.teal,
              badgeText: _fmtChange((doctors?.changePercent ?? 0).toDouble()),
              badgeIsPositive: (doctors?.changePercent ?? 0) >= 0,
            ),
            _MetricSummaryTile(
              width: itemWidth,
              title: 'Avg. Quiz Score',
              value: quiz != null ? '${quiz.percentage}%' : '—',
              icon: Icons.emoji_events_outlined,
              iconColor: Colors.orange,
              badgeText: _fmtChange((quiz?.changePercent ?? 0).toDouble()),
              badgeIsPositive: (quiz?.changePercent ?? 0) >= 0,
            ),
            _MetricSummaryTile(
              width: itemWidth,
              title: 'Event RSVP Rate',
              value: rsvp != null ? '${rsvp.percentage}%' : '—',
              icon: Icons.calendar_today_outlined,
              iconColor: Colors.blue,
              badgeText: _fmtChange((rsvp?.changePercent ?? 0).toDouble()),
              badgeIsPositive: (rsvp?.changePercent ?? 0) >= 0,
            ),
            _MetricSummaryTile(
              width: itemWidth,
              title: 'Content Reach',
              value: reach?.count.toString() ?? '—',
              icon: Icons.visibility_outlined,
              iconColor: Colors.teal,
              badgeText: _fmtChange((reach?.changePercent ?? 0).toDouble()),
              badgeIsPositive: (reach?.changePercent ?? 0) >= 0,
            ),
          ],
        );
      },
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  final double width;
  const _SkeletonCard({required this.width});

  @override
  Widget build(BuildContext context) {
    final box = BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(4));
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 36, width: 36, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8))),
          const SizedBox(height: 16),
          Container(height: 28, width: 80, decoration: box),
          const SizedBox(height: 8),
          Container(height: 12, width: 120, decoration: box),
        ],
      ),
    );
  }
}

class _MetricSummaryTile extends StatelessWidget {
  final double width;
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final String badgeText;
  final bool badgeIsPositive;

  const _MetricSummaryTile({
    required this.width,
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.badgeText,
    required this.badgeIsPositive,
  });

  @override
  Widget build(BuildContext context) {
    final Color badgeColor = badgeIsPositive ? Colors.teal : Colors.red;
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, size: 18, color: iconColor),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: badgeColor.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
                child: Text(badgeText, style: TextStyle(color: badgeColor, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 2),
          Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// =========================================================================
// 3. Engagement Trends Chart
// =========================================================================
class _EngagementTrendsChartCard extends StatelessWidget {
  final EngagementTrends? trends;
  final bool isLoading;
  final String selectedPeriod;

  const _EngagementTrendsChartCard({
    this.trends,
    required this.isLoading,
    required this.selectedPeriod,
  });

  // Shorten "May 04 - May 10" → "May 4"
  String _shortLabel(String raw) {
    final parts = raw.split(' - ');
    if (parts.isEmpty) return raw;
    final first = parts[0].trim();
    final segments = first.split(' ');
    if (segments.length >= 2) {
      final day = int.tryParse(segments[1]);
      return '${segments[0]} ${day ?? segments[1]}';
    }
    return first;
  }

  @override
  Widget build(BuildContext context) {
    final labels = trends?.labels ?? [];
    final views = trends?.contentViews ?? [];
    final quizzes = trends?.quizAttempts ?? [];

    // Show last 7 data points to match the 7-bar layout
    final count = labels.length;
    final start = count > 7 ? count - 7 : 0;
    final displayLabels = labels.sublist(start);
    final displayViews = views.length > start ? views.sublist(start) : views;
    final displayQuizzes = quizzes.length > start ? quizzes.sublist(start) : quizzes;

    final maxVal = [
      ...displayViews,
      ...displayQuizzes,
    ].fold<int>(1, (m, v) => v > m ? v : m);

    const maxBarH = 180.0;

    double barH(int val) => val == 0 ? 2.0 : (val / maxVal) * maxBarH;

    return Container(
      height: 340,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Engagement Trends', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 2),
                  Text('Views vs. Quiz Attempts over time', style: TextStyle(fontSize: 12, color: AppColors.textMuted.withValues(alpha: 0.8))),
                ],
              ),
              const Spacer(),
              _PeriodChip(
                label: 'Weekly',
                period: 'weekly',
                selectedPeriod: selectedPeriod,
              ),
              const SizedBox(width: 6),
              _PeriodChip(
                label: 'Monthly',
                period: 'monthly',
                selectedPeriod: selectedPeriod,
              ),
            ],
          ),
          const Spacer(),
          if (isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator(color: AppColors.primary)))
          else
            SizedBox(
              height: 220,
              child: displayLabels.isEmpty
                  ? const Center(child: Text('No data available', style: TextStyle(color: AppColors.textMuted, fontSize: 13)))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(displayLabels.length, (i) {
                        final v = i < displayViews.length ? displayViews[i] : 0;
                        final q = i < displayQuizzes.length ? displayQuizzes[i] : 0;
                        return _buildBarGroup(_shortLabel(displayLabels[i]), barH(v), barH(q));
                      }),
                    ),
            ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendDot('Content Views', const Color(0xFF0A8080)),
              const SizedBox(width: 24),
              _buildLegendDot('Quiz Attempts', const Color(0xFF93C5FD)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBarGroup(String label, double valA, double valB) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(width: 14, height: valA, decoration: const BoxDecoration(color: Color(0xFF0A8080), borderRadius: BorderRadius.vertical(top: Radius.circular(3)))),
            const SizedBox(width: 4),
            Container(width: 14, height: valB, decoration: const BoxDecoration(color: Color(0xFF93C5FD), borderRadius: BorderRadius.vertical(top: Radius.circular(3)))),
          ],
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildLegendDot(String text, Color color) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12, color: AppColors.textDark, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _PeriodChip extends StatelessWidget {
  final String label;
  final String period;
  final String selectedPeriod;

  const _PeriodChip({
    required this.label,
    required this.period,
    required this.selectedPeriod,
  });

  @override
  Widget build(BuildContext context) {
    final active = period == selectedPeriod;
    return GestureDetector(
      onTap: active
          ? null
          : () => context.read<AnalyticsBloc>().add(FetchAnalyticsRequested(period: period)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFEDF2F7) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: active ? Colors.transparent : AppColors.borderLight),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: active ? FontWeight.bold : FontWeight.w500,
            color: AppColors.textDark,
          ),
        ),
      ),
    );
  }
}

// =========================================================================
// 4. Growth by Specialty
// =========================================================================
class _GrowthBySpecialtyCard extends StatelessWidget {
  final List<GrowthBySpecialty> items;
  final bool isLoading;

  const _GrowthBySpecialtyCard({required this.items, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 340,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Growth by Specialty', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 20),
          if (isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator(color: AppColors.primary)))
          else if (items.isEmpty)
            const Expanded(child: Center(child: Text('No data available', style: TextStyle(color: AppColors.textMuted, fontSize: 13))))
          else
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: items.take(5).map((item) {
                  return _buildSpecialtyItem(
                    item.name ?? '—',
                    (item.percentage ?? 0) / 100.0,
                    '${item.contentCount ?? 0} items',
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSpecialtyItem(String title, double fraction, String sub) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            Text(sub, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: fraction.clamp(0.0, 1.0),
            minHeight: 6,
            backgroundColor: const Color(0xFFEDF2F7),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ],
    );
  }
}

// =========================================================================
// 5. Top Performing Content
// =========================================================================
class _TopPerformingContentCard extends StatelessWidget {
  final List<TopPerformingContent> items;
  final bool isLoading;

  const _TopPerformingContentCard({required this.items, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Top Performing Content', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 12),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
            )
          else if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(child: Text('No content data available', style: TextStyle(color: AppColors.textMuted, fontSize: 13))),
            )
          else
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2.5),
                1: FlexColumnWidth(1.2),
                2: FlexColumnWidth(1.0),
                3: FlexColumnWidth(0.8),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                const TableRow(
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderLight))),
                  children: [
                    Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Text('TITLE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textMuted))),
                    Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Text('TYPE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textMuted))),
                    Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Text('VIEWS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textMuted))),
                    Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Text('LIKES', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textMuted))),
                  ],
                ),
                ...items.map((item) => _buildContentRow(item)),
              ],
            ),
        ],
      ),
    );
  }

  static const _typeColors = {
    'Article': (Color(0xFF553C9A), Color(0xFFF3E8FF)),
    'Webinar': (Color(0xFF0A5C5A), Color(0xFFE6F2F2)),
    'Quiz': (Color(0xFF744210), Color(0xFFFFFAF0)),
    'PDF': (Color(0xFF276749), Color(0xFFECFDF5)),
  };

  TableRow _buildContentRow(TopPerformingContent item) {
    final type = item.type ?? 'Article';
    final colors = _typeColors[type] ?? (const Color(0xFF4A5568), const Color(0xFFEDF2F7));
    final (tagColor, tagBg) = colors;

    return TableRow(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderLight))),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            item.title ?? '—',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: UnconstrainedBox(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(color: tagBg, borderRadius: BorderRadius.circular(4)),
              child: Text(type.toUpperCase(), style: TextStyle(color: tagColor, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.3)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text('${item.viewsCount ?? 0}', style: const TextStyle(fontSize: 13, color: AppColors.textDark, fontWeight: FontWeight.w500)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
               Icon(Icons.thumb_up, color: AppColors.primary, size: 14),
              const SizedBox(width: 4),
              Text('${item.likesCount ?? 0}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            ],
          ),
        ),
      ],
    );
  }
}

// =========================================================================
// 6. Activity Stream (static — left as-is)
// =========================================================================
class _ActivityStreamCard extends StatelessWidget {
  const _ActivityStreamCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Activity Stream', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 18),
          _buildActivityItem('Dr. James Wilson completed\nAsthma Pathway Quiz', 'SCORE: 95%', '2 mins ago', Icons.person_outline, Colors.teal),
          const Divider(color: AppColors.borderLight, height: 20),
          _buildActivityItem("Dr. Elena Rodriguez RSVP'd for\nPulmoSummit 2024", 'SPECIALTY: PULMONOLOGY', '15 mins ago', Icons.calendar_today_outlined, Colors.orange),
          const Divider(color: AppColors.borderLight, height: 20),
          _buildActivityItem('Dr. Robert Chen logged in from\nHouston, TX', 'RETURNING USER', '1 hr ago', Icons.login_outlined, Colors.blue),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String headline, String subText, String timestamp, IconData icon, Color accent) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: accent.withValues(alpha: 0.08), shape: BoxShape.circle),
          child: Icon(icon, size: 16, color: accent),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(headline, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark), maxLines: 2),
              const SizedBox(height: 2),
              Text(subText, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.textMuted.withValues(alpha: 0.6), letterSpacing: 0.3)),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(timestamp, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
      ],
    );
  }
}
