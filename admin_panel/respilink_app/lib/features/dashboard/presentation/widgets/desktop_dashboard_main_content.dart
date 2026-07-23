import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:respilink_app/core/theme/app_colors.dart';
import 'package:respilink_app/core/utils/export/app_exporter.dart';
import 'package:respilink_app/core/utils/export/dashboard_export_builder.dart';
import 'package:respilink_app/core/utils/global_notifiers.dart';
import 'package:respilink_app/core/utils/snackbar_util.dart';
import 'package:respilink_app/features/auth/data/models/dashboard_model.dart';
import 'package:respilink_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:respilink_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:respilink_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:respilink_app/features/dashboard/data/model/engagement_data.dart';
import 'package:respilink_app/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:respilink_app/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:respilink_app/features/dashboard/presentation/widgets/engagement_chart.dart';
import 'package:respilink_app/routes/router_strings.dart';
import 'package:respilink_app/shared/model/admin_mode.dart';
import 'package:respilink_app/features/practioner/data/model/practioner_model.dart';
import 'package:respilink_app/features/practioner/presentation/bloc/practioner_bloc.dart';
import 'package:respilink_app/features/practioner/presentation/bloc/practioner_event.dart';
import 'package:respilink_app/features/practioner/presentation/bloc/practioner_state.dart';
import 'package:respilink_app/shared/widgets/app_network_image.dart';
import 'package:respilink_app/shared/widgets/app_popup_menu_button.dart';
import 'package:shimmer/shimmer.dart';

class DesktopDashboardMainContent extends StatelessWidget {
  const DesktopDashboardMainContent({
    super.key,
    required this.onNotificationTapped,
    required this.onPractitionerTapped,
    required this.onViewAllPractitionersTapped,
  });

  final VoidCallback onNotificationTapped;
  final void Function(Practioners) onPractitionerTapped;
  final VoidCallback onViewAllPractitionersTapped;

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
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, dashState) {
            final trend = dashState.data?.engagementTrend;
            final engagementPoints = trend != null
                ? EngagementDataPoint.fromTrend(trend)
                : EngagementDataPoint.mockWeeklyData;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderBar(onNotificationTapped: onNotificationTapped),
                  const SizedBox(height: 32),
                  TitleSection(
                    onExportTapped: () => _exportDashboard(
                      context,
                      dashboard: dashState.data,
                    ),
                  ),
                  const SizedBox(height: 24),
                  MetricsGrid(
                    dashboard: dashState.data,
                    isLoading: dashState.isLoading,
                  ),
                  const SizedBox(height: 24),
                  _MiddleRowSection(engagementPoints: engagementPoints),
                  const SizedBox(height: 24),
                  VerificationQueueSection(
                    onPractitionerTapped: onPractitionerTapped,
                    onViewAllTapped: onViewAllPractitionersTapped,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ==========================================
// Sub-Widgets Implementations
// ==========================================

class HeaderBar extends StatelessWidget {
  const HeaderBar({super.key, required this.onNotificationTapped});

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
        // IconButton(
        //   icon: const Icon(
        //     Icons.help_outline_rounded,
        //     color: AppColors.textDark,
        //   ),
        //   onPressed: () {},
        // ),
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
                      Icon(
                        Icons.logout_rounded,
                        size: 15,
                        color: Colors.redAccent,
                      ),
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
                children: [
                  AppNetworkImage(
                    imageUrl: "",
                    width: 30,
                    height: 30,
                    isCircle: true,
                    errorWidget: CircleAvatar(
                      backgroundColor: AppColors.white,
                      radius: 16,
                      child: Icon(
                        Icons.person,
                        size: 22,
                        color: AppColors.primary,
                      ),
                    ),
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
          },
        ),
      ],
    );
  }
}

Future<void> _exportDashboard(
  BuildContext context, {
  required DashboardModel? dashboard,
}) async {
  final practitioners =
      context.read<PractionerBloc>().state.practioners?.data ?? [];
  final saved = await AppExporter.export(
    document: buildDashboardExportDocument(
      dashboard: dashboard,
      practitioners: practitioners,
    ),
  );
  if (!context.mounted) return;
  if (saved) {
    SnackbarUtil.showSnackbar(context, message: 'Report exported successfully');
  }
}

class TitleSection extends StatelessWidget {
  final VoidCallback onExportTapped;

  const TitleSection({super.key, required this.onExportTapped});

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
              'RespiLink ecosystem and provider engagement.',
              style: TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
          ],
        ),
        Row(
          children: [
            // OutlinedButton.icon(
            //   onPressed: () {},
            //   icon: const Icon(
            //     Icons.calendar_today_outlined,
            //     size: 14,
            //     color: AppColors.textDark,
            //   ),
            //   label: const Text(
            //     'Last 30 Days',
            //     style: TextStyle(color: AppColors.textDark, fontSize: 13),
            //   ),
            //   style: OutlinedButton.styleFrom(
            //     backgroundColor: Colors.white,
            //     side: const BorderSide(color: AppColors.borderLight),
            //     padding: const EdgeInsets.symmetric(
            //       horizontal: 16,
            //       vertical: 16,
            //     ),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //   ),
            // ),
            // const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: onExportTapped,
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

String _fmtCount(int? v) {
  if (v == null) return '—';
  if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
  if (v >= 1000) return '${v ~/ 1000},${(v % 1000).toString().padLeft(3, '0')}';
  return v.toString();
}

String _changeBadge(int? pct) {
  if (pct == null || pct == 0) return '● No change';
  return pct > 0 ? '▲ +$pct%' : '▼ $pct%';
}

Color _changeBadgeColor(int? pct) {
  if (pct == null || pct == 0) return AppColors.textMuted;
  return pct > 0 ? AppColors.successGreen : AppColors.errorRed;
}

class MetricsGrid extends StatelessWidget {
  final DashboardModel? dashboard;
  final bool isLoading;

  const MetricsGrid({super.key, this.dashboard, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    final stats = dashboard?.statCounts;
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
              value: _fmtCount(stats?.activeDoctors?.count),
              badgeLabel: _changeBadge(stats?.activeDoctors?.changePercent),
              badgeColor: _changeBadgeColor(stats?.activeDoctors?.changePercent),
              isLoading: isLoading,
            ),
            MetricCard(
              width: cardWidth,
              icon: Icons.shield_outlined,
              title: 'PENDING VERIFICATIONS',
              value: _fmtCount(stats?.pendingVerifications?.count),
              badgeLabel: '● ${stats?.pendingVerifications?.critical ?? 0} critical',
              badgeColor: AppColors.errorRed,
              isLoading: isLoading,
            ),
            MetricCard(
              width: cardWidth,
              icon: Icons.emoji_events_outlined,
              title: 'QUIZ PARTICIPATION',
              value: '${stats?.quizParticipation?.percentage ?? 0}%',
              badgeLabel: _changeBadge(stats?.quizParticipation?.changePercent),
              badgeColor: _changeBadgeColor(stats?.quizParticipation?.changePercent),
              isLoading: isLoading,
            ),
            MetricCard(
              width: cardWidth,
              icon: Icons.menu_book_outlined,
              title: 'LIBRARY VIEWS',
              value: _fmtCount(stats?.libraryViews?.total),
              badgeLabel: '${_fmtCount(stats?.libraryViews?.recent)} recent',
              badgeColor: AppColors.textMuted,
              isLoading: isLoading,
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
  final bool isLoading;

  const MetricCard({
    super.key,
    required this.width,
    required this.icon,
    required this.title,
    required this.value,
    required this.badgeLabel,
    required this.badgeColor,
    this.isLoading = false,
  });

  Widget _shimmer(double w, double h) => Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.grey.shade50,
        child: Container(
          width: w,
          height: h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );

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
              isLoading
                  ? _shimmer(60, 14)
                  : Text(
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
          isLoading
              ? _shimmer(80, 28)
              : Text(
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
  final List<EngagementDataPoint> engagementPoints;

  const _MiddleRowSection({required this.engagementPoints});

  @override
  Widget build(BuildContext context) {
    final List<EngagementDataPoint> myApiDataList = engagementPoints;

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
        // const SizedBox(width: 24),
        // // System Health Gauge Card
        // Expanded(
        //   flex: 1,
        //   child: Container(
        //     height: 320,
        //     padding: const EdgeInsets.all(24),
        //     decoration: BoxDecoration(
        //       color: AppColors.cardBg,
        //       borderRadius: BorderRadius.circular(12),
        //       border: Border.all(color: AppColors.borderLight),
        //     ),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         const Text(
        //           'System Health',
        //           style: TextStyle(
        //             fontSize: 15,
        //             fontWeight: FontWeight.bold,
        //             color: AppColors.textDark,
        //           ),
        //         ),
        //         const SizedBox(height: 24),
        //         HealthRowItem(
        //           label: 'Health',
        //           value: 'Optimal',
        //           valueColor: AppColors.successGreen,
        //           showIndicator: true,
        //         ),
        //         const Divider(color: AppColors.borderLight, height: 32),
        //         HealthRowItem(
        //           label: 'Database Load',
        //           value: '24%',
        //           valueColor: AppColors.textDark,
        //           showIndicator: false,
        //         ),
        //         const SizedBox(height: 12),
        //         ClipRRect(
        //           borderRadius: BorderRadius.circular(4),
        //           child: const LinearProgressIndicator(
        //             value: 0.24,
        //             minHeight: 6,
        //             backgroundColor: AppColors.scaffoldBg,
        //             valueColor: AlwaysStoppedAnimation<Color>(
        //               AppColors.primary,
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
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

class VerificationQueueSection extends StatefulWidget {
  const VerificationQueueSection({
    super.key,
    required this.onPractitionerTapped,
    required this.onViewAllTapped,
  });

  final void Function(Practioners) onPractitionerTapped;
  final VoidCallback onViewAllTapped;

  @override
  State<VerificationQueueSection> createState() =>
      _VerificationQueueSectionState();
}

class _VerificationQueueSectionState extends State<VerificationQueueSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<PractionerBloc>().add(
          FetchPractionersRequested(page: 1, status: 'pending'),
        );
      }
    });
  }

  void _confirmApprove(BuildContext context, Practioners p) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Approve Practitioner'),
        content: Text(
          'Verify and approve ${p.fullName ?? 'this practitioner'}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.successGreen,
            ),
            onPressed: () {
              Navigator.pop(context);
              context.read<PractionerBloc>().add(
                VerifyPractionerRequested(p.id!),
              );
            },
            child: const Text('Approve', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmReject(BuildContext context, Practioners p) {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reject Practitioner'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reject the application of ${p.fullName ?? 'this practitioner'}?',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Reason for rejection',
                hintText: 'Enter rejection reason...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              reasonController.dispose();
              Navigator.pop(dialogContext);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
            ),
            onPressed: () {
              final reason = reasonController.text.trim();
              reasonController.dispose();
              Navigator.pop(dialogContext);
              context.read<PractionerBloc>().add(
                RejectPractionerRequested(
                  p.id!,
                  reason: reason.isNotEmpty ? reason : null,
                ),
              );
            },
            child: const Text('Reject', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

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
                onPressed: widget.onViewAllTapped,
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
          BlocBuilder<PractionerBloc, PractionerState>(
            builder: (context, state) {
              final pending = (state.practioners?.data ?? [])
                  .where((p) => (p.status ?? '').toLowerCase() == 'pending')
                  .take(5)
                  .toList();
              final isLoading = state.isLoadingPractioners;

              return Table(
                columnWidths: const {
                  0: FlexColumnWidth(3.5),
                  1: FlexColumnWidth(4.5),
                  2: FlexColumnWidth(3.0),
                  3: FlexColumnWidth(2.1),
                  4: FlexColumnWidth(2.2),
                  5: FlexColumnWidth(3.5),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  _buildHeaderRow(),
                  if (isLoading)
                    ..._buildSkeletonRows()
                  else if (pending.isEmpty)
                    _buildEmptyRow()
                  else
                    ...pending.map((p) => _buildDataRow(context, p, state)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  TableRow _buildHeaderRow() {
    const style = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.bold,
      color: AppColors.textMuted,
    );
    return const TableRow(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text('PRACTITIONER', style: style),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Text('SPECIALTY', style: style),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Text('HOSPITAL / FACILITY', style: style),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Text('REG. DATE', style: style),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Text('STATUS', style: style),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Text('ACTIONS', style: style, textAlign: TextAlign.right),
        ),
      ],
    );
  }

  static final _shBox = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(4),
  );

  List<TableRow> _buildSkeletonRows() {
    return List.generate(
      3,
      (_) => TableRow(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.borderLight)),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _QueueShimmer(
                  child: const CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _QueueShimmer(
                        child: Container(
                          height: 12,
                          width: 120,
                          decoration: _shBox,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _QueueShimmer(
                        child: Container(
                          height: 10,
                          width: 70,
                          decoration: _shBox,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: _QueueShimmer(
              child: Container(
                height: 22,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: _QueueShimmer(
              child: Container(height: 12, width: 110, decoration: _shBox),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: _QueueShimmer(
              child: Container(height: 12, width: 70, decoration: _shBox),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: _QueueShimmer(
              child: Container(
                height: 22,
                width: 72,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _QueueShimmer(
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                _QueueShimmer(
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildEmptyRow() {
    return const TableRow(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          child: Text(
            'No pending verifications.',
            style: TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
        ),
        SizedBox(),
        SizedBox(),
        SizedBox(),
        SizedBox(),
        SizedBox(),
      ],
    );
  }

  TableRow _buildDataRow(
    BuildContext context,
    Practioners p,
    PractionerState state,
  ) {
    final regDate = p.createdAt != null ? p.createdAt!.substring(0, 10) : '—';
    final status = (p.status ?? 'pending').toLowerCase();
    final statusColor = switch (status) {
      'verified' => AppColors.successGreen,
      'rejected' => AppColors.errorRed,
      _ => AppColors.warningOrange,
    };
    final photoUrl = p.photoUrl ?? p.photoPath;
    final isActioning = state.isActionLoading && state.actioningUserId == p.id;
    final specialties =
        p.specialties?.where((e) => e.name != null).toList() ?? [];

    return TableRow(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              AppNetworkImage(
                height: 25,
                width: 25,
                imageUrl: '$photoUrl',
                isCircle: true,
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.fullName ?? '—',
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      'ID: ${p.uuid?.substring(0, 8) ?? p.id?.toString() ?? '—'}',
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: specialties.isEmpty
              ? const Text(
                  '—',
                  style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                )
              : Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: specialties.map((s) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        s.name!,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            p.hospitalAffiliation ?? '—',
            style: const TextStyle(fontSize: 13, color: AppColors.textDark),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            regDate,
            style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: UnconstrainedBox(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.fiber_manual_record, color: statusColor, size: 8),
                  const SizedBox(width: 4),
                  Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (isActioning)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                )
              else ...[
                IconButton(
                  icon: const Icon(
                    Icons.visibility_outlined,
                    size: 18,
                    color: AppColors.textMuted,
                  ),
                  onPressed: () => widget.onPractitionerTapped(p),
                  tooltip: 'View Details',
                ),
                AppPopupMenuButton(
                  onSelected: (value) {
                    if (value == 'approve') _confirmApprove(context, p);
                    if (value == 'reject') _confirmReject(context, p);
                  },
                  items: const [
                    AppPopupMenuItem(
                      value: 'approve',
                      icon: Icons.check_circle_outline,
                      label: 'Approve',
                      color: AppColors.successGreen,
                      hasDividerAfter: true,
                    ),
                    AppPopupMenuItem(
                      value: 'reject',
                      icon: Icons.cancel_outlined,
                      label: 'Reject',
                      color: AppColors.errorRed,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _QueueShimmer extends StatelessWidget {
  final Widget child;
  const _QueueShimmer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: child,
    );
  }
}
