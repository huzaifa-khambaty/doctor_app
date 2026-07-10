import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_app/core/theme/app_colors.dart';
import 'package:respilink_app/core/utils/snackbar_util.dart';
import 'package:respilink_app/features/practioner/data/model/practioner_model.dart';
import 'package:respilink_app/features/practioner/data/model/requests/suspend_user_request.dart';
import 'package:respilink_app/features/practioner/presentation/bloc/practioner_bloc.dart';
import 'package:respilink_app/features/practioner/presentation/bloc/practioner_event.dart';
import 'package:respilink_app/features/practioner/presentation/bloc/practioner_state.dart';
import 'package:respilink_app/shared/widgets/app_network_image.dart';

class PractionerDetailView extends StatelessWidget {
  final Practioners practioner;
  final VoidCallback onBackToUsers;

  const PractionerDetailView({
    super.key,
    required this.practioner,
    required this.onBackToUsers,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<PractionerBloc, PractionerState>(
      listenWhen: (prev, curr) =>
          (prev.actionSuccess != curr.actionSuccess && curr.actionSuccess) ||
          (prev.error != curr.error && curr.error != null),
      listener: (context, state) {
        if (state.actionSuccess) {
          SnackbarUtil.showSnackbar(context, message: 'Action completed successfully');
          onBackToUsers();
        } else if (state.error != null) {
          SnackbarUtil.showSnackbar(context, message: state.error!, isError: true);
        }
      },
      child: _DetailContent(practioner: practioner, onBackToUsers: onBackToUsers),
    );
  }
}

class _DetailContent extends StatelessWidget {
  final Practioners practioner;
  final VoidCallback onBackToUsers;

  const _DetailContent({required this.practioner, required this.onBackToUsers});

  InputDecoration _fieldDecoration(String value) => InputDecoration(
        hintText: value,
        hintStyle: const TextStyle(color: AppColors.textDark, fontSize: 13, fontWeight: FontWeight.w500),
        filled: true,
        fillColor: const Color(0xFFEDF2F7),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final bool useVerticalLayout = MediaQuery.of(context).size.width < 1100;
    final status = (practioner.status ?? 'pending').toLowerCase();
    final isSuspended = status == 'suspended';
    final photoUrl = practioner.photoUrl ?? practioner.photoPath;

    return BlocBuilder<PractionerBloc, PractionerState>(
      builder: (context, state) {
        final specialtyName = practioner.specialties?.map((e) => e.name).whereType<String>().join(", ") ?? 'Unknown';

        final isActioning = state.isActionLoading &&
            state.actioningUserId == practioner.id;

        return Padding(
          padding: const EdgeInsets.all(32.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Breadcrumb
                Row(
                  children: [
                    InkWell(
                      onTap: onBackToUsers,
                      child: Text('Management',
                          style: TextStyle(fontSize: 12, color: AppColors.textMuted.withValues(alpha: 0.8))),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.0),
                      child: Text('›', style: TextStyle(fontSize: 14, color: AppColors.textMuted)),
                    ),
                    InkWell(
                      onTap: onBackToUsers,
                      child: Text('Users',
                          style: TextStyle(fontSize: 12, color: AppColors.textMuted.withValues(alpha: 0.8))),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.0),
                      child: Text('›', style: TextStyle(fontSize: 14, color: AppColors.textMuted)),
                    ),
                    Text(
                      practioner.fullName ?? 'Practitioner',
                      style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A5C5A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.tealAccent.withValues(alpha: 0.6), width: 2),
                            ),
                            child: AppNetworkImage(
                              imageUrl: '$photoUrl',
                              width: 72,
                              height: 72,
                              isCircle: true,
                            ),
                          ),
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                              child: Icon(
                                isSuspended ? Icons.block : Icons.check_circle,
                                color: isSuspended ? Colors.orange : Colors.green,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              practioner.fullName ?? '—',
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$specialtyName • ${practioner.qualifications ?? '—'}',
                              style: const TextStyle(fontSize: 13, color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Info + Stats
                Flex(
                  direction: useVerticalLayout ? Axis.vertical : Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: useVerticalLayout ? 0 : 2,
                      child: Container(
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
                                const Row(
                                  children: [
                                    Icon(Icons.assignment_ind_outlined, size: 16, color: AppColors.primary),
                                    SizedBox(width: 8),
                                    Text('General Information',
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                                  ],
                                ),
                                if (practioner.createdAt != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(color: const Color(0xFFEDF2F7), borderRadius: BorderRadius.circular(4)),
                                    child: Text(
                                      'Registered: ${practioner.createdAt!.substring(0, 10)}',
                                      style: const TextStyle(fontSize: 10, color: AppColors.textMuted, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                              ],
                            ),
                            const Divider(color: AppColors.borderLight, height: 28),
                            Row(
                              children: [
                                Expanded(child: _buildField('FULL NAME', practioner.fullName ?? '—', _fieldDecoration)),
                                const SizedBox(width: 16),
                                Expanded(child: _buildField('EMAIL ADDRESS', practioner.email ?? '—', _fieldDecoration)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(child: _buildField('PHONE NUMBER', practioner.phone ?? '—', _fieldDecoration)),
                                const SizedBox(width: 16),
                                Expanded(child: _buildField('HOSPITAL / FACILITY', practioner.hospitalAffiliation ?? '—', _fieldDecoration)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(child: _buildField('SPECIALTY', specialtyName, _fieldDecoration)),
                                const SizedBox(width: 16),
                                Expanded(child: _buildField('LOCATION', practioner.location ?? '—', _fieldDecoration)),
                              ],
                            ),
                            if (practioner.rejectionReason != null) ...[
                              const SizedBox(height: 16),
                              _buildField('REJECTION REASON', practioner.rejectionReason!, _fieldDecoration),
                            ],
                          ],
                        ),
                      ),
                    ),

                    useVerticalLayout ? const SizedBox(height: 20) : const SizedBox(width: 20),

                    Expanded(
                      flex: useVerticalLayout ? 0 : 1,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.analytics_outlined, size: 16, color: AppColors.primary),
                                SizedBox(width: 8),
                                Text('Account Statistics',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                              ],
                            ),
                            const Divider(color: AppColors.borderLight, height: 28),
                            _buildStatWidget('Quizzes Taken', '—', Icons.help_outline_rounded, Colors.teal),
                            const SizedBox(height: 12),
                            _buildStatWidget('Average Score', '—', Icons.emoji_events_outlined, Colors.orange),
                            const SizedBox(height: 12),
                            _buildStatWidget('Events Attended', '—', Icons.calendar_today_outlined, Colors.purple),
                            const SizedBox(height: 12),
                            _buildStatWidget('Library Items', '—', Icons.bookmark_border_rounded, Colors.blue),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Suspend / Reinstate panel
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSuspended ? const Color(0xFFF0FFF4) : const Color(0xFFFFF5F5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSuspended ? const Color(0xFFC6F6D5) : const Color(0xFFFED7D7),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSuspended ? const Color(0xFFC6F6D5) : const Color(0xFFFEEBC8),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isSuspended ? Icons.refresh_rounded : Icons.warning_amber_rounded,
                          color: isSuspended ? Colors.green : Colors.orange,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isSuspended ? 'Reinstate Account Access' : 'Restrict Account Access',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isSuspended ? const Color(0xFF276749) : const Color(0xFF9B2C2C),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isSuspended
                                  ? 'Reinstating will restore full access for ${practioner.fullName ?? 'this user'}.'
                                  : 'Suspending will revoke all access for ${practioner.fullName ?? 'this user'} immediately.',
                              style: TextStyle(
                                fontSize: 12,
                                color: isSuspended
                                    ? const Color(0xFF2F855A).withValues(alpha: 0.9)
                                    : const Color(0xFFC53030).withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      isActioning
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                            )
                          : isSuspended
                              ? OutlinedButton(
                                  onPressed: () => _reinstate(context),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Color(0xFF38A169)),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: const Text('Reinstate Account',
                                      style: TextStyle(color: Color(0xFF38A169), fontSize: 13, fontWeight: FontWeight.bold)),
                                )
                              : OutlinedButton(
                                  onPressed: () => _showSuspendDialog(context),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Color(0xFFE53E3E)),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: const Text('Suspend Account',
                                      style: TextStyle(color: Color(0xFFE53E3E), fontSize: 13, fontWeight: FontWeight.bold)),
                                ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _reinstate(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reinstate Account'),
        content: Text('Reinstate access for ${practioner.fullName ?? 'this user'}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              Navigator.pop(context);
              context.read<PractionerBloc>().add(ReinstatePractionerRequested(practioner.id!));
            },
            child: const Text('Reinstate', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSuspendDialog(BuildContext context) {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Suspend Account'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Provide a reason for suspending ${practioner.fullName ?? 'this user'}:'),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter suspension reason...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              final reason = reasonController.text.trim();
              if (reason.isEmpty) return;
              Navigator.pop(context);
              context.read<PractionerBloc>().add(SuspendPractionerRequested(
                    userId: practioner.id!,
                    request: SuspendUserRequest(reason: reason),
                  ));
            },
            child: const Text('Suspend', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, String value, InputDecoration Function(String) decoration) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textMuted, letterSpacing: 0.5)),
        const SizedBox(height: 6),
        TextField(readOnly: true, decoration: decoration(value)),
      ],
    );
  }

  Widget _buildStatWidget(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            ],
          ),
          Icon(icon, color: color.withValues(alpha: 0.5), size: 20),
        ],
      ),
    );
  }
}
