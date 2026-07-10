import 'package:flutter/material.dart';
import 'package:respilink_app/core/theme/app_colors.dart';
import 'package:respilink_app/shared/widgets/app_popup_menu_button.dart';

class ContentRepositoryContent extends StatelessWidget {
  const ContentRepositoryContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Top Search Header Area
            const _RepositoryHeader(),
            const SizedBox(height: 32),

            // 2. Title Section
            const _RepositoryTitleSection(),
            const SizedBox(height: 24),

            // 3. Horizontal Content Summary Metrics
            const _RepositoryMetricsGrid(),
            const SizedBox(height: 24),

            // 4. Main Data Table Frame
            const _ContentRepositoryTable(),
            const SizedBox(height: 24),

            // 5. Bottom Informational Row (System Logs + Content Mix breakdown)
            const _RepositoryBottomSection(),
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// Top & Header Sub-Widgets
// =========================================================================

class _RepositoryHeader extends StatelessWidget {
  const _RepositoryHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search content, scientific papers, or events...',
                hintStyle: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.textMuted,
                  size: 18,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.borderLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(
            Icons.notifications_none_outlined,
            color: AppColors.textDark,
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}

class _RepositoryTitleSection extends StatelessWidget {
  const _RepositoryTitleSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Content Repository',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Manage clinical studies, educational modules, and scientific events.',
              style: TextStyle(fontSize: 14, color: AppColors.textMuted),
            ),
          ],
        ),
        // Filter Controls Segmented Pill Layout
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: const [
                  _SegmentedFilterChip(label: 'All', isActive: true),
                  _SegmentedFilterChip(label: 'Drafts', isActive: false),
                  _SegmentedFilterChip(label: 'Published', isActive: false),
                ],
              ),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.filter_list,
                size: 16,
                color: AppColors.textDark,
              ),
              label: const Text(
                'Filters',
                style: TextStyle(color: AppColors.textDark, fontSize: 13),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: AppColors.borderLight),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SegmentedFilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  const _SegmentedFilterChip({required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? AppColors.scaffoldBg : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          color: isActive ? AppColors.textDark : AppColors.textMuted,
        ),
      ),
    );
  }
}

// =========================================================================
// Repository Metrics Strip
// =========================================================================

class _RepositoryMetricsGrid extends StatelessWidget {
  const _RepositoryMetricsGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = (constraints.maxWidth - (3 * 16)) / 4;
        if (cardWidth < 180) cardWidth = 180;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _RepoMiniCard(
              width: cardWidth,
              title: 'Total Content',
              value: '1,248',
              icon: Icons.description_outlined,
              color: Colors.blueAccent,
            ),
            _RepoMiniCard(
              width: cardWidth,
              title: 'Webinars',
              value: '42',
              icon: Icons.video_library_outlined,
              color: Colors.purpleAccent,
            ),
            _RepoMiniCard(
              width: cardWidth,
              title: 'Live Quizzes',
              value: '156',
              icon: Icons.quiz_outlined,
              color: Colors.orangeAccent,
            ),
            _RepoMiniCard(
              width: cardWidth,
              title: 'Upcoming Events',
              value: '12',
              icon: Icons.calendar_today_outlined,
              color: Colors.redAccent,
            ),
          ],
        );
      },
    );
  }
}

class _RepoMiniCard extends StatelessWidget {
  final double width;
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _RepoMiniCard({
    required this.width,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// Content Core Data Table
// =========================================================================

class _ContentRepositoryTable extends StatelessWidget {
  const _ContentRepositoryTable();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          Table(
            columnWidths: const {
              0: FlexColumnWidth(3.0),
              1: FlexColumnWidth(1.2),
              2: FlexColumnWidth(1.2),
              3: FlexColumnWidth(1.4),
              4: FlexColumnWidth(1.2),
              5: FlexColumnWidth(0.8),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              _buildTableHeader(),
              _buildTableRow(
                'Introduction to Respiratory Physiology',
                'By Dr. Julianne Reed • Clinical Paper',
                'Article',
                Colors.teal,
                'Physiology',
                'Oct 20, 2023',
              ),
              _buildTableRow(
                'Respiratory System Anatomy Mastery Quiz',
                '12 Questions • Medical Student Track',
                'Quiz',
                Colors.orange,
                'Anatomy',
                'Nov 02, 2023',
              ),
              _buildTableRow(
                'Annual Pulmonology Summit 2024',
                'Geneva, Switzerland • Hybrid Format',
                'Webinar',
                Colors.blue,
                'General',
                'Nov 05, 2023',
              ),
              _buildTableRow(
                'Spirometry Guidelines & Interpretation',
                'Full PDF Guide • 2024 Edition',
                'PDF',
                Colors.red,
                'Diagnosis',
                'Oct 30, 2023',
              ),
              _buildTableRow(
                'Vaping-Associated Lung Injury Study',
                'Case Study Analysis • Multi-center Review',
                'Article',
                Colors.teal,
                'Environmental',
                'Nov 12, 2023',
              ),
            ],
          ),
          const _TableFooterPagination(),
        ],
      ),
    );
  }

  TableRow _buildTableHeader() {
    return const TableRow(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'TITLE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textMuted,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'TYPE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textMuted,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'TOPIC',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textMuted,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'DATE CREATED',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textMuted,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'STATUS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textMuted,
            ),
          ),
        ),
        Padding(padding: EdgeInsets.all(16), child: SizedBox()),
      ],
    );
  }

  TableRow _buildTableRow(
    String title,
    String subtitle,
    String typeLabel,
    Color typeColor,
    String topic,
    String date,
  ) {
    return TableRow(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: UnconstrainedBox(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: typeColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: typeColor.withValues(alpha: 0.2)),
              ),
              child: Text(
                typeLabel,
                style: TextStyle(
                  color: typeColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            topic,
            style: const TextStyle(fontSize: 13, color: AppColors.textDark),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            date,
            style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: const [
              Icon(
                Icons.fiber_manual_record,
                color: AppColors.successGreen,
                size: 8,
              ),
              SizedBox(width: 6),
              Text(
                'Published',
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: AppPopupMenuButton(
            onSelected: (value) {
              switch (value) {
                case 'unpublish':
                  break;
                case 'delete':
                  break;
              }
            },
            items: const [
              AppPopupMenuItem(
                value: 'unpublish',
                icon: Icons.visibility_off_outlined,
                label: 'Unpublish',
                color: AppColors.sidebarBg,
                hasDividerAfter: true,
              ),
              AppPopupMenuItem(
                value: 'delete',
                icon: Icons.delete_outline,
                label: 'Delete',
                color: Colors.red,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TableFooterPagination extends StatelessWidget {
  const _TableFooterPagination();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Showing 1 to 5 of 1,248 content items',
            style: TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
          Row(
            children: [
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.borderLight),
                  padding: const EdgeInsets.all(8),
                  minimumSize: Size.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Icon(
                  Icons.keyboard_arrow_left,
                  size: 16,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.sidebarBg,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '1',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              _buildPageNum('2'),
              _buildPageNum('3'),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  '...',
                  style: TextStyle(color: AppColors.textMuted),
                ),
              ),
              _buildPageNum('250'),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.borderLight),
                  padding: const EdgeInsets.all(8),
                  minimumSize: Size.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Icon(
                  Icons.keyboard_arrow_right,
                  size: 16,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageNum(String label) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: 28,
      height: 28,
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(color: AppColors.textDark, fontSize: 13),
      ),
    );
  }
}

// =========================================================================
// Bottom Informational Split Grid Section
// =========================================================================

class _RepositoryBottomSection extends StatelessWidget {
  const _RepositoryBottomSection();

  @override
  Widget build(BuildContext context) {
    final bool stackVertically = MediaQuery.of(context).size.width < 1000;

    return Flex(
      direction: stackVertically ? Axis.vertical : Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column: Recent System Logs
        Expanded(
          flex: stackVertically ? 0 : 2,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.history_toggle_off,
                      size: 18,
                      color: AppColors.textDark,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Recent System Logs',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildLogItem(
                  'New Quiz Published',
                  '"Pharmacological Interventions in Asthma" was moved to published by Dr. Thorne.',
                  '14 MINUTES AGO',
                  AppColors.primary,
                ),
                const Divider(color: AppColors.borderLight, height: 24),
                _buildLogItem(
                  'PDF Upload Failed',
                  '"Invasive Ventilation Protocol.pdf" failed validation due to file size limits.',
                  '2 HOURS AGO',
                  AppColors.errorRed,
                ),
                const Divider(color: AppColors.borderLight, height: 24),
                _buildLogItem(
                  'Event Registration Peak',
                  '"Pulmonology Summit 2024" reached 85% capacity in the Geneva venue.',
                  '4 HOURS AGO',
                  AppColors.warningOrange,
                ),
              ],
            ),
          ),
        ),
        stackVertically
            ? const SizedBox(height: 24)
            : const SizedBox(width: 24),
        // Right Column: Content Mix Chart
        Expanded(
          flex: stackVertically ? 0 : 1,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Content Mix',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 24),
                _buildMixRow('Scientific Articles', '48%', Colors.teal, 0.48),
                const SizedBox(height: 16),
                _buildMixRow('Quizzes & Education', '32%', Colors.orange, 0.32),
                const SizedBox(height: 16),
                _buildMixRow('Clinical Webinars', '15%', Colors.blue, 0.15),
                const SizedBox(height: 16),
                _buildMixRow('Regulatory PDFs', '5%', Colors.red, 0.05),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.borderLight),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'View Full Audit Report',
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogItem(
    String title,
    String detail,
    String time,
    Color indicatorColor,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Icon(
            Icons.fiber_manual_record,
            color: indicatorColor,
            size: 8,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                detail,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMuted.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMixRow(
    String title,
    String percent,
    Color metricColor,
    double fillValue,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
              ),
            ),
            Text(
              percent,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: fillValue,
            minHeight: 6,
            backgroundColor: AppColors.scaffoldBg,
            valueColor: AlwaysStoppedAnimation<Color>(metricColor),
          ),
        ),
      ],
    );
  }
}
