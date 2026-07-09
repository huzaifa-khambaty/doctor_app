import 'package:flutter/material.dart';
import 'package:respilink_app/core/theme/app_colors.dart';

class EngagementAnalyticsContent extends StatelessWidget {
  const EngagementAnalyticsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Top Dashboard Navigation / Action Bar Control Row
            const _AnalyticsHeaderActionRow(),
            const SizedBox(height: 24),
        
            // 2. High-level Performance Metrics Banner Row
            const _AnalyticsMetricsGrid(),
            const SizedBox(height: 24),
        
            // 3. Middle Section: Trends Chart & Specialty Breakdown Matrix
            LayoutBuilder(
              builder: (context, constraints) {
                final bool stackMiddleSection = constraints.maxWidth < 1100;
                return Flex(
                  direction: stackMiddleSection ? Axis.vertical : Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: stackMiddleSection ? 0 : 2,
                      child: const _EngagementTrendsChartCard(),
                    ),
                    stackMiddleSection ? const SizedBox(height: 20) : const SizedBox(width: 20),
                    Expanded(
                      flex: stackMiddleSection ? 0 : 1,
                      child: const _GrowthBySpecialtyCard(),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
        
            // 4. Bottom Section: Top Performing Content & Activity Feed Stream
            LayoutBuilder(
              builder: (context, constraints) {
                final bool stackBottomSection = constraints.maxWidth < 1100;
                return Flex(
                  direction: stackBottomSection ? Axis.vertical : Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: stackBottomSection ? 0 : 2,
                      child: const _TopPerformingContentCard(),
                    ),
                    stackBottomSection ? const SizedBox(height: 20) : const SizedBox(width: 20),
                    Expanded(
                      flex: stackBottomSection ? 0 : 1,
                      child: const _ActivityStreamCard(),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// 1. Header Component Section
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
        const Spacer(),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textDark),
          label: const Text('Last 30 Days', style: TextStyle(color: AppColors.textDark, fontSize: 13, fontWeight: FontWeight.w600)),
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: AppColors.borderLight),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
        ),
        const SizedBox(width: 12),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.file_download_outlined, size: 14, color: AppColors.textDark),
          label: const Text('Export Report', style: TextStyle(color: AppColors.textDark, fontSize: 13, fontWeight: FontWeight.w600)),
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: AppColors.borderLight),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
        ),
      ],
    );
  }
}

// =========================================================================
// 2. Metrics Grid Section
// =========================================================================
class _AnalyticsMetricsGrid extends StatelessWidget {
  const _AnalyticsMetricsGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double itemWidth = (constraints.maxWidth - (3 * 16)) / 4;
        if (itemWidth < 220) itemWidth = 220;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _MetricSummaryTile(width: itemWidth, title: 'Total Active Doctors', value: '4,829', icon: Icons.people_outline, iconColor: Colors.teal, badgeText: '+12.5%', badgeIsPositive: true),
            _MetricSummaryTile(width: itemWidth, title: 'Avg. Quiz Score', value: '86.4%', icon: Icons.emoji_events_outlined, iconColor: Colors.orange, badgeText: '+4.2%', badgeIsPositive: true),
            _MetricSummaryTile(width: itemWidth, title: 'Event RSVP Rate', value: '62.8%', icon: Icons.calendar_today_outlined, iconColor: Colors.blue, badgeText: '-2.1%', badgeIsPositive: false),
            _MetricSummaryTile(width: itemWidth, title: 'Content Reach', value: '1.2M', icon: Icons.visibility_outlined, iconColor: Colors.teal, badgeText: '+28.3%', badgeIsPositive: true),
          ],
        );
      },
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
// 3. Trends Chart & Specialty Cards
// =========================================================================
class _EngagementTrendsChartCard extends StatelessWidget {
  const _EngagementTrendsChartCard();

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
              _buildToggleChip('Daily', true),
              const SizedBox(width: 6),
              _buildToggleChip('Weekly', false),
            ],
          ),
          const Spacer(),
          // Mock Bar Graphical Visualization Columns
          SizedBox(
            height: 220,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBarGroup('Mon', 90, 110),
                _buildBarGroup('Tue', 120, 95),
                _buildBarGroup('Wed', 150, 130),
                _buildBarGroup('Thu', 100, 125),
                _buildBarGroup('Fri', 180, 160),
                _buildBarGroup('Sat', 60, 50),
                _buildBarGroup('Sun', 45, 35),
              ],
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
          )
        ],
      ),
    );
  }

  Widget _buildToggleChip(String label, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFEDF2F7) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: active ? Colors.transparent : AppColors.borderLight),
      ),
      child: Text(label, style: TextStyle(fontSize: 12, fontWeight: active ? FontWeight.bold : FontWeight.w500, color: AppColors.textDark)),
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
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w500)),
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

class _GrowthBySpecialtyCard extends StatelessWidget {
  const _GrowthBySpecialtyCard();

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
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSpecialtyItem('Pulmonology', 0.72, '+18%'),
                _buildSpecialtyItem('Internal Medicine', 0.54, '+12%'),
                _buildSpecialtyItem('Allergy & Immunology', 0.40, '+24%'),
                _buildSpecialtyItem('Critical Care', 0.18, '-3%', isNegative: true),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSpecialtyItem(String title, double percentage, String growth, {bool isNegative = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            Text(growth, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isNegative ? Colors.red : Colors.teal)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 6,
            backgroundColor: const Color(0xFFEDF2F7),
            valueColor: AlwaysStoppedAnimation<Color>(isNegative ? Colors.redAccent : AppColors.primary),
          ),
        )
      ],
    );
  }
}

// =========================================================================
// 4. Content Listing & Recent Streams Subsystem
// =========================================================================
class _TopPerformingContentCard extends StatelessWidget {
  const _TopPerformingContentCard();

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Top Performing Content', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              TextButton(onPressed: () {}, child: const Text('View All Content', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 12),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2.5),
              1: FlexColumnWidth(1.2),
              2: FlexColumnWidth(1.0),
              3: FlexColumnWidth(0.8),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderLight))),
                children: const [
                  Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Text('TITLE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textMuted))),
                  Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Text('TYPE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textMuted))),
                  Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Text('VIEWS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textMuted))),
                  Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Text('AVG RATING', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textMuted))),
                ],
              ),
              _buildContentRow('Modern COPD\nManagement 2024', 'INTERACTIVE\nMODULE', '12,402', '4.9', Colors.teal, const Color(0xFFE6F2F2)),
              _buildContentRow('Breakthroughs in Biologics', 'RESEARCH PAPER', '8,920', '4.7', Colors.purple, const Color(0xFFF3E8FF)),
              _buildContentRow('Inhaler Technique\nMasterclass', 'VIDEO TUTORIAL', '6,155', '4.8', Colors.blue, const Color(0xFFEFF6FF)),
            ],
          )
        ],
      ),
    );
  }

  TableRow _buildContentRow(String title, String type, String views, String rating, Color tagColor, Color tagBg) {
    return TableRow(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderLight))),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Container(width: 32, height: 32, decoration: BoxDecoration(color: const Color(0xFFEDF2F7), borderRadius: BorderRadius.circular(6), image: const DecorationImage(image: NetworkImage('https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?q=80&w=50'), fit: BoxFit.cover))),
              const SizedBox(width: 12),
              Expanded(child: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark))),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: UnconstrainedBox(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(color: tagBg, borderRadius: BorderRadius.circular(4)),
              child: Text(type, style: TextStyle(color: tagColor, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.3)),
            ),
          ),
        ),
        Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(views, style: const TextStyle(fontSize: 13, color: AppColors.textDark, fontWeight: FontWeight.w500))),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 14),
              const SizedBox(width: 4),
              Text(rating, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            ],
          ),
        ),
      ],
    );
  }
}

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