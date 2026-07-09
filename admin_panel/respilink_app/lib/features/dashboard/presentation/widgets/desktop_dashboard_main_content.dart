import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:respilink_app/core/theme/app_colors.dart';
import 'package:respilink_app/core/utils/global_notifiers.dart';
import 'package:respilink_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:respilink_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:respilink_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:respilink_app/features/dashboard/data/model/engagement_data.dart';
import 'package:respilink_app/features/dashboard/presentation/widgets/engagement_chart.dart';
import 'package:respilink_app/routes/router_strings.dart';
import 'package:respilink_app/shared/model/admin_mode.dart';
import 'package:respilink_app/shared/widgets/app_network_image.dart';

class DesktopDashboardMainContent extends StatelessWidget {
  const DesktopDashboardMainContent({
    super.key,
    required this.onNotificationTapped,
  });

  final VoidCallback onNotificationTapped;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLogoutSuccess) {
          context.go(RouterStrings.initial);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderBar(onNotificationTapped: onNotificationTapped),
              const SizedBox(height: 32),
              const TitleSection(),
              const SizedBox(height: 24),
              const MetricsGrid(),
              const SizedBox(height: 24),
              const _MiddleRowSection(),
              const SizedBox(height: 24),
              const VerificationQueueSection(),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// Sub-Widgets Implementations
// ==========================================

class HeaderBar extends StatelessWidget {
    const HeaderBar({
    super.key,
    required this.onNotificationTapped,
  });

  final VoidCallback onNotificationTapped;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search clinical records, doctors, or content...',
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.borderLight),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.borderLight),
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
          onPressed: () => onNotificationTapped.call(),
        ),
        IconButton(
          icon: const Icon(
            Icons.help_outline_rounded,
            color: AppColors.textDark,
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 16),

        ValueListenableBuilder<Admin?>(
          valueListenable: GlobalNotifiers.adminNotifier,
          builder: (context, user, child) {
            return PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'logout') {
                  context.read<AuthBloc>().add(LogoutRequested());
                }
              },
              offset: const Offset(0, 44),
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: AppColors.borderLight),
              ),
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: const [
                      Icon(Icons.logout_rounded, size: 15, color: Colors.redAccent),
                      SizedBox(width: 10),
                      Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              child: Row(
                children:  [
                  AppNetworkImage(
                    imageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=150',
                    isCircle: true,
                    height: 30,
                    width: 30,
                  ),
                  SizedBox(width: 8),
                  Text(
                    user?.name ?? 'Admin',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textDark,
                    size: 16,
                  ),
                ],
              ),
            );
          }
        ),
      ],
    );
  }
}

class TitleSection extends StatelessWidget {
  const TitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Clinical Dashboard',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Real-time overview of RespiLink ecosystem and provider engagement.',
              style: TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
          ],
        ),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.calendar_today_outlined,
                size: 14,
                color: AppColors.textDark,
              ),
              label: const Text(
                'Last 30 Days',
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
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.file_download_outlined,
                size: 16,
                color: Colors.white,
              ),
              label: const Text(
                'Export Report',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
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

class MetricsGrid extends StatelessWidget {
  const MetricsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = (constraints.maxWidth - (3 * 16)) / 4;
        if (cardWidth < 200) cardWidth = 200;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            MetricCard(
              width: cardWidth,
              icon: Icons.medical_services_outlined,
              title: 'ACTIVE DOCTORS',
              value: '1,284',
              badgeLabel: '▲ +12%',
              badgeColor: AppColors.successGreen,
            ),
            MetricCard(
              width: cardWidth,
              icon: Icons.shield_outlined,
              title: 'PENDING VERIFICATIONS',
              value: '42',
              badgeLabel: '● 18 critical',
              badgeColor: AppColors.errorRed,
            ),
            MetricCard(
              width: cardWidth,
              icon: Icons.emoji_events_outlined,
              title: 'QUIZ PARTICIPATION',
              value: '86%',
              badgeLabel: '▲ +5.4%',
              badgeColor: AppColors.successGreen,
            ),
            MetricCard(
              width: cardWidth,
              icon: Icons.menu_book_outlined,
              title: 'LIBRARY VIEWS',
              value: '45,902',
              badgeLabel: '12.4k views',
              badgeColor: AppColors.textMuted,
            ),
          ],
        );
      },
    );
  }
}

class MetricCard extends StatelessWidget {
  final double width;
  final IconData icon;
  final String title;
  final String value;
  final String badgeLabel;
  final Color badgeColor;

  const MetricCard({
    super.key,
    required this.width,
    required this.icon,
    required this.title,
    required this.value,
    required this.badgeLabel,
    required this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
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
              Icon(icon, color: AppColors.primary, size: 22),
              Text(
                badgeLabel,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: badgeColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textMuted,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiddleRowSection extends StatelessWidget {
  const _MiddleRowSection();

  @override
  Widget build(BuildContext context) {
    final List<EngagementDataPoint> myApiDataList =
        EngagementDataPoint.mockWeeklyData;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main Engagement Trends Card
        Expanded(
          flex: 3,
          child: Container(
            height: 320,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Engagement Trends',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Content views vs Quiz submissions',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: const [
                        IndicatorLegend(
                          color: AppColors.primary,
                          label: 'Views',
                        ),
                        SizedBox(width: 16),
                        IndicatorLegend(
                          color: Colors.deepPurpleAccent,
                          label: 'Quizzes',
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24.0, right: 8.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Evaluate constraint thresholds dynamically to flag styling states
                        final bool mobileMode = constraints.maxWidth < 500;

                        // Pass your structural API state down safely
                        return EngagementChart(
                          data: myApiDataList,
                          isMobile: mobileMode,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 24),
        // System Health Gauge Card
        Expanded(
          flex: 1,
          child: Container(
            height: 320,
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
                  'System Health',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 24),
                HealthRowItem(
                  label: 'Health',
                  value: 'Optimal',
                  valueColor: AppColors.successGreen,
                  showIndicator: true,
                ),
                const Divider(color: AppColors.borderLight, height: 32),
                HealthRowItem(
                  label: 'Database Load',
                  value: '24%',
                  valueColor: AppColors.textDark,
                  showIndicator: false,
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: const LinearProgressIndicator(
                    value: 0.24,
                    minHeight: 6,
                    backgroundColor: AppColors.scaffoldBg,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
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
}

class IndicatorLegend extends StatelessWidget {
  final Color color;
  final String label;
  const IndicatorLegend({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textDark),
        ),
      ],
    );
  }
}

class HealthRowItem extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final bool showIndicator;

  const HealthRowItem({
    super.key,
    required this.label,
    required this.value,
    required this.valueColor,
    required this.showIndicator,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
        ),
        Row(
          children: [
            if (showIndicator) ...[
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: valueColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class VerificationQueueSection extends StatelessWidget {
  const VerificationQueueSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Verification Queue',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Practitioners awaiting license verification',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: Row(
                  children: const [
                    Text(
                      'View All',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      size: 14,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2.5),
              1: FlexColumnWidth(1.5),
              2: FlexColumnWidth(1.5),
              3: FlexColumnWidth(1.2),
              4: FlexColumnWidth(1.0),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              _buildTableHeaderRow(),
              _buildTableRow(
                name: 'Dr. Michael Ross',
                subText: 'NPF 9821034421',
                specialty: 'Pulmonology',
                date: 'Oct 24, 2023',
                status: 'Pending',
              ),
              _buildTableRow(
                name: 'Dr. Elena Rodriguez',
                subText: 'NPF 2391090009',
                specialty: 'Critical Care',
                date: 'Oct 23, 2023',
                status: 'Pending',
              ),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _buildTableHeaderRow() {
    return TableRow(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.borderLight, width: 1),
        ),
      ),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'PRACTITIONER',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textMuted,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'SPECIALTY',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textMuted,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'APPLIED DATE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textMuted,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'STATUS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textMuted,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'ACTION',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textMuted,
            ),
            textAlign: .right,
          ),
        ),
      ],
    );
  }

  TableRow _buildTableRow({
    required String name,
    required String subText,
    required String specialty,
    required String date,
    required String status,
  }) {
    return TableRow(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.borderLight, width: 1),
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.scaffoldBg,
                child: Icon(Icons.person, size: 16, color: AppColors.textMuted),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    subText,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            specialty,
            style: const TextStyle(fontSize: 13, color: AppColors.textDark),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            date,
            style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: UnconstrainedBox(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.warningOrange.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Pending',
                style: TextStyle(
                  color: AppColors.warningOrange,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Verify',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
