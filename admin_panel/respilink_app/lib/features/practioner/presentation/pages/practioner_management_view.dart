import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_app/core/theme/app_colors.dart';
import 'package:respilink_app/core/utils/snackbar_util.dart';
import 'package:respilink_app/features/practioner/data/model/practioner_model.dart';
import 'package:respilink_app/features/practioner/presentation/bloc/practioner_bloc.dart';
import 'package:respilink_app/features/practioner/presentation/bloc/practioner_event.dart';
import 'package:respilink_app/features/practioner/presentation/bloc/practioner_state.dart';
import 'package:respilink_app/shared/widgets/app_network_image.dart';
import 'package:respilink_app/shared/widgets/app_popup_menu_button.dart';
import 'package:shimmer/shimmer.dart';

class PractitionerManagementContent extends StatefulWidget {
  const PractitionerManagementContent({
    super.key,
    this.onManualEnrollmentClicked,
    required this.onUserTapped,
  });

  final VoidCallback? onManualEnrollmentClicked;
  final Function(Practioners) onUserTapped;

  @override
  State<PractitionerManagementContent> createState() =>
      _PractitionerManagementContentState();
}

class _PractitionerManagementContentState
    extends State<PractitionerManagementContent> {
  String _searchQuery = '';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<PractionerBloc>().add(FetchPractionersRequested());
      }
    });
  }

  void _onSearch(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _searchQuery = value.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PractionerBloc, PractionerState>(
      listenWhen: (prev, curr) =>
          (prev.actionSuccess != curr.actionSuccess && curr.actionSuccess) ||
          (prev.error != curr.error && curr.error != null),
      listener: (context, state) {
        if (state.actionSuccess) {
          SnackbarUtil.showSnackbar(
            context,
            message: 'Action completed successfully',
          );
        } else if (state.error != null) {
          SnackbarUtil.showSnackbar(
            context,
            message: state.error!,
            isError: true,
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PractitionerHeader(onSearch: _onSearch),
              const SizedBox(height: 32),
              _PipelineTitleSection(
                onManualEnrollmentClicked: widget.onManualEnrollmentClicked,
              ),
              const SizedBox(height: 24),
              const _PipelineMetricsGrid(),
              const SizedBox(height: 24),
              const _FilterControlsBar(),
              const SizedBox(height: 20),
              _PractitionerDataTable(
                onUserTapped: widget.onUserTapped,
                searchQuery: _searchQuery,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =========================================================================
// UI Layout Components
// =========================================================================

class _PractitionerHeader extends StatelessWidget {
  const _PractitionerHeader({required this.onSearch});

  final ValueChanged<String> onSearch;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: TextField(
              onChanged: onSearch,
              decoration: InputDecoration(
                hintText: 'Search practitioners by name or ID...',
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

class _PipelineTitleSection extends StatelessWidget {
  const _PipelineTitleSection({this.onManualEnrollmentClicked});

  final VoidCallback? onManualEnrollmentClicked;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'VERIFICATION PIPELINE',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                letterSpacing: 1.0,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Practitioner Management',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.file_download_outlined,
                size: 16,
                color: AppColors.textDark,
              ),
              label: const Text(
                'Export Report',
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
            if (onManualEnrollmentClicked != null) ...[
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: onManualEnrollmentClicked,
                icon: const Icon(Icons.add, size: 16, color: Colors.white),
                label: const Text(
                  'Manual Enrollment',
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
          ],
        ),
      ],
    );
  }
}

class _PipelineMetricsGrid extends StatelessWidget {
  const _PipelineMetricsGrid();

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
            _PipelineCard(
              width: cardWidth,
              title: 'AWAITING APPROVAL',
              value: '24',
              subtitle: '+12% vs last week',
              subColor: AppColors.errorRed,
              icon: Icons.assignment_late_outlined,
            ),
            _PipelineCard(
              width: cardWidth,
              title: 'VERIFIED TODAY',
              value: '08',
              subtitle: 'On Target',
              subColor: AppColors.successGreen,
              icon: Icons.verified_outlined,
            ),
            _PipelineCard(
              width: cardWidth,
              title: 'AVERAGE WAIT',
              value: '1.4h',
              subtitle: '-15m improvement',
              subColor: AppColors.successGreen,
              icon: Icons.hourglass_empty_rounded,
            ),
            _PipelineCard(
              width: cardWidth,
              title: 'SYSTEM INTEGRITY',
              value: '99.9%',
              subtitle: 'Live monitoring active',
              subColor: AppColors.textMuted,
              icon: Icons.gpp_good_outlined,
            ),
          ],
        );
      },
    );
  }
}

class _PipelineCard extends StatelessWidget {
  final double width;
  final String title;
  final String value;
  final String subtitle;
  final Color subColor;
  final IconData icon;

  const _PipelineCard({
    required this.width,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.subColor,
    required this.icon,
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
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              Icon(
                icon,
                color: AppColors.textMuted.withValues(alpha: 0.7),
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: subColor,
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// Filter Bar
// =========================================================================

class _FilterControlsBar extends StatefulWidget {
  const _FilterControlsBar();

  @override
  State<_FilterControlsBar> createState() => _FilterControlsBarState();
}

class _FilterControlsBarState extends State<_FilterControlsBar> {
  String? _selectedSpecialtyId;
  String? _selectedStatus;

  void _dispatchFetch() {
    context.read<PractionerBloc>().add(
      FetchPractionersRequested(
        page: 1,
        status: _selectedStatus,
        specialtyId: _selectedSpecialtyId != null
            ? int.tryParse(_selectedSpecialtyId!)
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              _StatusFilterChip(
                label: 'All',
                isActive: _selectedStatus == null,
                onTap: () {
                  setState(() => _selectedStatus = null);
                  _dispatchFetch();
                },
              ),
              _StatusFilterChip(
                label: 'Pending',
                isActive: _selectedStatus == 'pending',
                onTap: () {
                  setState(() => _selectedStatus = 'pending');
                  _dispatchFetch();
                },
              ),
              _StatusFilterChip(
                label: 'Verified',
                isActive: _selectedStatus == 'verified',
                onTap: () {
                  setState(() => _selectedStatus = 'verified');
                  _dispatchFetch();
                },
              ),
              _StatusFilterChip(
                label: 'Rejected',
                isActive: _selectedStatus == 'rejected',
                onTap: () {
                  setState(() => _selectedStatus = 'rejected');
                  _dispatchFetch();
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        BlocBuilder<PractionerBloc, PractionerState>(
          builder: (context, state) {
            return Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: state.isLoadingSpecialties
                  ? const SizedBox(
                      width: 120,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Loading...',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    )
                  : DropdownButton<String?>(
                      value: _selectedSpecialtyId,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('Specialty: All'),
                        ),
                        ...state.specialties.map(
                          (s) => DropdownMenuItem<String?>(
                            value: s.id?.toString(),
                            child: Text(s.name ?? s.slug ?? ''),
                          ),
                        ),
                      ],
                      onChanged: (val) {
                        setState(() => _selectedSpecialtyId = val);
                        context.read<PractionerBloc>().add(
                          FetchPractionersRequested(
                            page: 1,
                            status: _selectedStatus,
                            specialtyId: val != null ? int.tryParse(val) : null,
                          ),
                        );
                      },
                    ),
            );
          },
        ),
        // const Spacer(),
        // OutlinedButton.icon(
        //   onPressed: () {},
        //   icon: const Icon(
        //     Icons.tune_rounded,
        //     size: 16,
        //     color: AppColors.textDark,
        //   ),
        //   label: const Text(
        //     'Advanced Filters',
        //     style: TextStyle(color: AppColors.textDark, fontSize: 13),
        //   ),
        //   style: OutlinedButton.styleFrom(
        //     backgroundColor: Colors.white,
        //     side: const BorderSide(color: AppColors.borderLight),
        //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(8),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

class _StatusFilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _StatusFilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive ? AppColors.white : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}

// =========================================================================
// Data Table with real data + pagination
// =========================================================================

class _PractitionerDataTable extends StatelessWidget {
  const _PractitionerDataTable({
    required this.onUserTapped,
    required this.searchQuery,
  });

  final Function(Practioners) onUserTapped;
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PractionerBloc, PractionerState>(
      builder: (context, state) {
        final all = state.practioners?.data ?? [];
        final practitioners = searchQuery.isEmpty
            ? all
            : all.where((p) {
                final name = (p.fullName ?? '').toLowerCase();
                final id = (p.uuid ?? p.id?.toString() ?? '').toLowerCase();
                return name.contains(searchQuery) || id.contains(searchQuery);
              }).toList();
        final isLoading = state.isLoadingPractioners;

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
                  0: FlexColumnWidth(3.5),
                  1: FlexColumnWidth(4.5),
                  2: FlexColumnWidth(3.0),
                  3: FlexColumnWidth(2.0),
                  4: FlexColumnWidth(2.2),
                  5: FlexColumnWidth(3.5),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  _buildHeaderRow(),
                  if (isLoading)
                    ..._buildSkeletonRows()
                  else if (practitioners.isEmpty)
                    _buildEmptyRow()
                  else
                    ...practitioners.map(
                      (p) => _buildDataRow(context, p, state),
                    ),
                ],
              ),
              const _TablePaginationFooter(),
            ],
          ),
        );
      },
    );
  }

  TableRow _buildHeaderRow() {
    return const TableRow(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      children: [
        Padding(
          padding: EdgeInsets.all(16),
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
          padding: EdgeInsets.all(16),
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
          padding: EdgeInsets.all(16),
          child: Text(
            'HOSPITAL / FACILITY',
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
            'REG. DATE',
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
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'ACTIONS',
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

  List<TableRow> _buildSkeletonRows() {
    return List.generate(
      6,
      (_) => TableRow(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.borderLight)),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _Shimmer(
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
                      _Shimmer(
                        child: Container(
                          height: 12,
                          width: 120,
                          decoration: _shBox,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _Shimmer(
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
          // Specialty — chip pills
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _Shimmer(
                  child: Container(
                    height: 22,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                _Shimmer(
                  child: Container(
                    height: 22,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Hospital
          Padding(
            padding: const EdgeInsets.all(16),
            child: _Shimmer(
              child: Container(height: 12, width: 110, decoration: _shBox),
            ),
          ),
          // Reg. Date
          Padding(
            padding: const EdgeInsets.all(16),
            child: _Shimmer(
              child: Container(height: 12, width: 70, decoration: _shBox),
            ),
          ),
          // Status pill
          Padding(
            padding: const EdgeInsets.all(16),
            child: _Shimmer(
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
          // Actions — eye icon + more_vert icon
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _Shimmer(
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
                _Shimmer(
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

  static final _shBox = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(4),
  );

  TableRow _buildEmptyRow() {
    return const TableRow(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          child: Text(
            'No practitioners found.',
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
              ? const Text('—', style: TextStyle(fontSize: 13, color: AppColors.textMuted))
              : Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: specialties.map((s) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
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
                  onPressed: () => onUserTapped(p),
                  tooltip: 'View Details',
                ),
                _PractitionerRowMenu(
                  practioner: p,
                  status: status,
                  onApprove: _confirmApprove,
                  onReject: _confirmReject,
                ),
              ],
            ],
          ),
        ),
      ],
    );
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
            Text('Reject the application of ${p.fullName ?? 'this practitioner'}?'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Reason for rejection',
                hintText: 'Enter rejection reason...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.errorRed),
            onPressed: () {
              final reason = reasonController.text.trim();
              reasonController.dispose();
              Navigator.pop(dialogContext);
              context.read<PractionerBloc>().add(
                RejectPractionerRequested(p.id!, reason: reason.isNotEmpty ? reason : null),
              );
            },
            child: const Text('Reject', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// Per-row popup menu
// =========================================================================

class _PractitionerRowMenu extends StatelessWidget {
  final Practioners practioner;
  final String status;
  final void Function(BuildContext, Practioners) onApprove;
  final void Function(BuildContext, Practioners) onReject;

  const _PractitionerRowMenu({
    required this.practioner,
    required this.status,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final isPending = status == 'pending';
    return AppPopupMenuButton(
      onSelected: (value) {
        if (value == 'approve') onApprove(context, practioner);
        if (value == 'reject') onReject(context, practioner);
      },
      items: [
        if (isPending) ...[
          const AppPopupMenuItem(
            value: 'approve',
            icon: Icons.check_circle_outline,
            label: 'Approve',
            color: AppColors.successGreen,
            hasDividerAfter: true,
          ),
          const AppPopupMenuItem(
            value: 'reject',
            icon: Icons.cancel_outlined,
            label: 'Reject',
            color: AppColors.errorRed,
          ),
        ],
      ],
    );
  }
}

// =========================================================================
// Pagination Footer
// =========================================================================

class _TablePaginationFooter extends StatelessWidget {
  const _TablePaginationFooter();

  void _goToPage(BuildContext context, PractionerState state, int page) {
    context.read<PractionerBloc>().add(
      FetchPractionersRequested(
        page: page,
        status: state.activeStatus,
        specialtyId: state.activeSpecialtyId,
      ),
    );
  }

  List<int?> _pageNumbers(int current, int last) {
    if (last <= 7) return List.generate(last, (i) => i + 1);

    final Set<int> show = {1, last, current};
    if (current > 1) show.add(current - 1);
    if (current < last) show.add(current + 1);

    final sorted = show.toList()..sort();
    final result = <int?>[];
    for (int i = 0; i < sorted.length; i++) {
      if (i > 0 && sorted[i] - sorted[i - 1] > 1) result.add(null);
      result.add(sorted[i]);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PractionerBloc, PractionerState>(
      builder: (context, state) {
        final model = state.practioners;
        final current = model?.currentPage ?? 1;
        final last = model?.lastPage ?? 1;
        final from = model?.from ?? 0;
        final to = model?.to ?? 0;
        final total = model?.total ?? 0;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                total == 0 ? '' : 'Showing $from – $to of $total practitioners',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                ),
              ),
              if (last > 1)
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_left, size: 18),
                      onPressed: current > 1
                          ? () => _goToPage(context, state, current - 1)
                          : null,
                    ),
                    ..._pageNumbers(current, last).map((page) {
                      if (page == null) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            '…',
                            style: TextStyle(color: AppColors.textMuted),
                          ),
                        );
                      }
                      return _PageNumberItem(
                        page: page.toString(),
                        isActive: page == current,
                        onTap: () => _goToPage(context, state, page),
                      );
                    }),
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_right, size: 18),
                      onPressed: current < last
                          ? () => _goToPage(context, state, current + 1)
                          : null,
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}

class _Shimmer extends StatelessWidget {
  final Widget child;
  const _Shimmer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: child,
    );
  }
}

class _PageNumberItem extends StatelessWidget {
  final String page;
  final bool isActive;
  final VoidCallback onTap;

  const _PageNumberItem({
    required this.page,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        width: 28,
        height: 28,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? AppColors.sidebarBg : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          page,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.white : AppColors.textDark,
          ),
        ),
      ),
    );
  }
}
