import 'package:flutter/material.dart';
import 'package:respilink_app/core/theme/app_colors.dart';

class QuizDirectoryContent extends StatelessWidget {
  const QuizDirectoryContent({super.key, required this.onCreateQuizClicked});

  final VoidCallback onCreateQuizClicked;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Top Global Search Bar Line
            const _QuizSearchBarHeader(),
            const SizedBox(height: 24),

            // 2. Breadcrumbs and Title Action Section
            _QuizTitleActionRow(onCreateQuizClicked: onCreateQuizClicked),
            const SizedBox(height: 24),

            // 3. Grid Row Statistics Summary Layer
            const _QuizMetricsGridSection(),
            const SizedBox(height: 28),

            // 4. Utility Search Filters / Sort Row Controls
            const _QuizUtilityControlRow(),
            const SizedBox(height: 16),

            // 5. Main Structured Interactive Quiz Listing Panel
            const _QuizDirectoryListBlock(),
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// Header, Title and Control Components
// =========================================================================

class _QuizSearchBarHeader extends StatelessWidget {
  const _QuizSearchBarHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search quizzes or topics...',
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
        IconButton(
          icon: const Icon(
            Icons.help_outline_rounded,
            color: AppColors.textMuted,
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}

class _QuizTitleActionRow extends StatelessWidget {
  const _QuizTitleActionRow({required this.onCreateQuizClicked});

  final VoidCallback onCreateQuizClicked;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Management',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted.withValues(alpha: 0.8),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    '›',
                    style: TextStyle(fontSize: 14, color: AppColors.textMuted),
                  ),
                ),
                const Text(
                  'Quizzes',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Quiz Directory',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Manage educational modules and clinician assessments.',
              style: TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => onCreateQuizClicked.call(),
          icon: const Icon(Icons.add, size: 16, color: Colors.white),
          label: const Text(
            'Create New Quiz',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}

class _QuizUtilityControlRow extends StatelessWidget {
  const _QuizUtilityControlRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.filter_list_rounded,
                size: 14,
                color: AppColors.textDark,
              ),
              label: const Text(
                'Filter',
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: AppColors.borderLight),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.sort_rounded,
                size: 14,
                color: AppColors.textDark,
              ),
              label: const Text(
                'Sort: Newest',
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: AppColors.borderLight),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ],
        ),
        const Text(
          'Showing 1-10 of 128 results',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// =========================================================================
// Statistics Grid Summary Subsystem
// =========================================================================

class _QuizMetricsGridSection extends StatelessWidget {
  const _QuizMetricsGridSection();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = (constraints.maxWidth - (3 * 16)) / 4;
        if (cardWidth < 165) cardWidth = 165;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _QuizStatCard(
              width: cardWidth,
              title: 'Total Quizzes',
              value: '128',
              icon: Icons.grid_view_rounded,
              iconColor: Colors.teal,
              badgeLabel: '+4 this week',
            ),
            _QuizStatCard(
              width: cardWidth,
              title: 'Active Quizzes',
              value: '12',
              icon: Icons.bolt,
              iconColor: Colors.blueAccent,
            ),
            _QuizStatCard(
              width: cardWidth,
              title: 'Total Participants',
              value: '3,492',
              icon: Icons.people_outline_rounded,
              iconColor: Colors.orangeAccent,
              badgeLabel: '↑ 12%',
              badgeColor: Colors.orange,
            ),
            _QuizStatCard(
              width: cardWidth,
              title: 'Completion Rate',
              value: '84%',
              icon: Icons.assignment_turned_in_outlined,
              iconColor: Colors.purpleAccent,
            ),
          ],
        );
      },
    );
  }
}

class _QuizStatCard extends StatelessWidget {
  final double width;
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final String? badgeLabel;
  final Color badgeColor;

  const _QuizStatCard({
    required this.width,
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    this.badgeLabel,
    this.badgeColor = Colors.teal,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              if (badgeLabel != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badgeLabel!,
                    style: TextStyle(
                      color: badgeColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// Main Core Listing Data Matrix Table
// =========================================================================

class _QuizDirectoryListBlock extends StatelessWidget {
  const _QuizDirectoryListBlock();

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
              0: FlexColumnWidth(2.6),
              1: FlexColumnWidth(1.0),
              2: FlexColumnWidth(1.1),
              3: FlexColumnWidth(1.1),
              4: FlexColumnWidth(1.3),
              5: FlexColumnWidth(1.5),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              _buildTableHeaderRow(),
              _buildDataRow(
                'Advanced Asthma Management',
                'Updated Oct 12, 2023',
                Icons.medical_services_outlined,
                Colors.teal,
                'Asthma',
                '25 Questions',
                'Live',
                Colors.teal,
                '1,240',
                showAvatars: true,
              ),
              _buildDataRow(
                'COPD Diagnostic Protocols',
                'Updated Oct 08, 2023',
                Icons.analytics_outlined,
                Colors.redAccent,
                'COPD',
                '15 Questions',
                'Draft',
                Colors.grey,
                '—',
                showAvatars: false,
              ),
              _buildDataRow(
                'Vaccination Schedule Q3',
                'Ended Sep 30, 2023',
                Icons.shield_outlined,
                Colors.orangeAccent,
                'Immunology',
                '20 Questions',
                'Completed',
                Colors.blue,
                '2,105',
                showAvatars: false,
              ),
              _buildDataRow(
                'Neuro-Imaging Essentials',
                'Updated Sep 25, 2023',
                Icons.biotech_outlined,
                Colors.purpleAccent,
                'Radiology',
                '30 Questions',
                'Live',
                Colors.teal,
                '845',
                showAvatars: false,
              ),
            ],
          ),
          const _TablePaginationFooter(),
        ],
      ),
    );
  }

  TableRow _buildTableHeaderRow() {
    return const TableRow(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      children: [
        Padding(
          padding: EdgeInsets.all(14),
          child: Text(
            'Quiz Title',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textMuted,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(14),
          child: Text(
            'Topic',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textMuted,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(14),
          child: Text(
            'Questions',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textMuted,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(14),
          child: Text(
            'Status',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textMuted,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(14),
          child: Text(
            'Participants',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textMuted,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(14),
          child: Text(
            'Actions',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textMuted,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  TableRow _buildDataRow(
    String title,
    String timestamp,
    IconData leadingIcon,
    Color leadingColor,
    String topicTag,
    String questionCount,
    String statusText,
    Color statusColor,
    String totalParticipants, {
    required bool showAvatars,
  }) {
    return TableRow(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      children: [
        // Title cell row block
        Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: leadingColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(leadingIcon, size: 16, color: leadingColor),
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
                      timestamp,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Topic tag chip badge cell
        Padding(
          padding: const EdgeInsets.all(14),
          child: UnconstrainedBox(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                topicTag,
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        // Question totals count label
        Padding(
          padding: const EdgeInsets.all(14),
          child: Text(
            questionCount,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textDark,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // Status dot row item block
        Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(Icons.fiber_manual_record, color: statusColor, size: 8),
              const SizedBox(width: 6),
              Text(
                statusText,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        // Participant aggregate metric counter stack column layout
        Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showAvatars) ...[
                const CircleAvatar(
                  radius: 9,
                  backgroundColor: Colors.orange,
                  child: Text(
                    'JD',
                    style: TextStyle(
                      fontSize: 8,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Text(
                totalParticipants,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        // Control actions contextual button vectors icon strip assembly line
        Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (statusText != 'Draft')
                IconButton(
                  icon: const Icon(
                    Icons.analytics_outlined,
                    size: 16,
                    color: AppColors.textMuted,
                  ),
                  onPressed: () {},
                ),
              if (statusText != 'Completed')
                IconButton(
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 16,
                    color: AppColors.textMuted,
                  ),
                  onPressed: () {},
                ),
              IconButton(
                icon: const Icon(
                  Icons.more_vert,
                  size: 16,
                  color: AppColors.textMuted,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TablePaginationFooter extends StatelessWidget {
  const _TablePaginationFooter();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Showing 1-4 of 12 events',
            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.keyboard_arrow_left, size: 16),
                onPressed: () {},
              ),
              _PageIndicatorBox(label: '1', active: true),
              _PageIndicatorBox(label: '2', active: false),
              _PageIndicatorBox(label: '3', active: false),
              IconButton(
                icon: const Icon(Icons.keyboard_arrow_right, size: 16),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PageIndicatorBox extends StatelessWidget {
  final String label;
  final bool active;
  const _PageIndicatorBox({required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: active ? AppColors.sidebarBg : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: active ? Colors.white : AppColors.textDark,
        ),
      ),
    );
  }
}
