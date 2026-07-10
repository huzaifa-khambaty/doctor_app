import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_app/core/theme/app_colors.dart';
import 'package:respilink_app/core/utils/snackbar_util.dart';
import 'package:respilink_app/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:respilink_app/features/settings/presentation/bloc/settings_event.dart';
import 'package:respilink_app/features/settings/presentation/bloc/settings_state.dart';
import 'package:respilink_app/features/settings/presentation/pages/data/model/roles_model.dart';
import 'package:shimmer/shimmer.dart';

class UserPermissionsContent extends StatelessWidget {
  const UserPermissionsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listenWhen: (prev, curr) =>
          (prev.saveSuccess != curr.saveSuccess && curr.saveSuccess) ||
          (prev.createRoleSuccess != curr.createRoleSuccess &&
              curr.createRoleSuccess) ||
          (prev.updateRoleSuccess != curr.updateRoleSuccess &&
              curr.updateRoleSuccess) ||
          (prev.deleteRoleSuccess != curr.deleteRoleSuccess &&
              curr.deleteRoleSuccess) ||
          (prev.error != curr.error && curr.error != null),
      listener: (context, state) {
        if (state.saveSuccess) {
          SnackbarUtil.showSnackbar(
            context,
            message: 'Permissions updated successfully',
          );
        } else if (state.createRoleSuccess) {
          SnackbarUtil.showSnackbar(
            context,
            message: 'Role created successfully',
          );
        } else if (state.updateRoleSuccess) {
          SnackbarUtil.showSnackbar(
            context,
            message: 'Role updated successfully',
          );
        } else if (state.deleteRoleSuccess) {
          SnackbarUtil.showSnackbar(
            context,
            message: 'Role deleted successfully',
          );
        } else if (state.error != null) {
          SnackbarUtil.showSnackbar(
            context,
            message: state.error!,
            isError: true,
          );
        }
      },
      child: const _PermissionsBody(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Body
// ─────────────────────────────────────────────────────────────────────────────

class _PermissionsBody extends StatefulWidget {
  const _PermissionsBody();

  @override
  State<_PermissionsBody> createState() => _PermissionsBodyState();
}

class _PermissionsBodyState extends State<_PermissionsBody> {
  RolesModel? _selectedRole;
  Set<int> _activePermissionIds = {};

  // ── Role selection ──────────────────────────────────────────────────────

  void _onRoleSelected(RolesModel role) {
    setState(() {
      _selectedRole = role;
      _activePermissionIds = _permIdsFrom(role);
    });
  }

  void _resetToOriginal() {
    if (_selectedRole == null) return;
    setState(() => _activePermissionIds = _permIdsFrom(_selectedRole!));
  }

  Set<int> _permIdsFrom(RolesModel role) => Set<int>.from(
        role.permissions?.map((p) => p.id).whereType<int>() ?? [],
      );

  // ── Permission toggles ──────────────────────────────────────────────────

  void _togglePermission(int permId, bool value) {
    setState(() {
      if (value) {
        _activePermissionIds.add(permId);
      } else {
        _activePermissionIds.remove(permId);
      }
    });
  }

  void _save() {
    if (_selectedRole?.id == null) return;
    context.read<SettingsBloc>().add(
          AssignPermissionsRequested(
            roleId: _selectedRole!.id!,
            permissionIds: _activePermissionIds.toList(),
          ),
        );
  }

  // ── Dialogs ─────────────────────────────────────────────────────────────

  void _showCreateRoleDialog() {
    final bloc = context.read<SettingsBloc>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => BlocProvider.value(
        value: bloc,
        child: const _RoleFormDialog(mode: _RoleDialogMode.create),
      ),
    );
  }

  void _showEditRoleDialog() {
    if (_selectedRole == null) return;
    final bloc = context.read<SettingsBloc>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => BlocProvider.value(
        value: bloc,
        child: _RoleFormDialog(
          mode: _RoleDialogMode.edit,
          role: _selectedRole,
        ),
      ),
    );
  }

  void _showDeleteRoleDialog() {
    if (_selectedRole == null) return;
    final bloc = context.read<SettingsBloc>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => BlocProvider.value(
        value: bloc,
        child: _DeleteRoleDialog(role: _selectedRole!),
      ),
    );
  }

  // ── Permission display metadata ──────────────────────────────────────────

  static const Map<String, _PermMeta> _meta = {
    'view_dashboard': _PermMeta(
      category: 'user_practitioner',
      label: 'Access Main Admin Dashboard View',
      description: 'Grabs basic analytical dashboard overview entry rights.',
    ),
    'edit_users': _PermMeta(
      category: 'user_practitioner',
      label: 'Modify System Profiles & Edit Access Tiers',
      description: 'Permits account updating, banning, or role shifts.',
    ),
    'enroll_practitioners': _PermMeta(
      category: 'user_practitioner',
      label: 'Onboard & Execute Manual Practitioner Enrollments',
      description:
          'Allows direct entry addition bypass authorization workflows.',
    ),
    'publish_content': _PermMeta(
      category: 'content_events',
      label: 'Publish Content, Scientific Papers, and Clinical Modules',
      description:
          'Grants creation/publishing privileges to Content Repository.',
    ),
    'create_quizzes': _PermMeta(
      category: 'content_events',
      label: 'Draft & Publish Interactive Assessments / Quizzes',
      description: 'Allows authoring clinician tests or certification checks.',
    ),
    'manage_events': _PermMeta(
      category: 'content_events',
      label: 'Schedule New Events, Webinars & Summits',
      description: 'Grants control mapping of upcoming live streams.',
    ),
    'bypass_credentials': _PermMeta(
      category: 'admin',
      label: 'Execute Manual Verification Overrides',
      description:
          'Bypass automated medical certification and license tracking validations.',
    ),
    'view_analytics': _PermMeta(
      category: 'admin',
      label: 'Export Analytics Reports & Platform Engagement Stream',
      description: 'Permits reading and downloading systemic interaction logs.',
    ),
    'modify_settings': _PermMeta(
      category: 'admin',
      label: 'Alter Core Platform Settings & Activate Maintenance Mode',
      description:
          'Grants global operational override rights to structural setups.',
    ),
  };

  String _normalize(String? name) =>
      (name ?? '').toLowerCase().replaceAll(' ', '_').replaceAll('-', '_');

  _PermMeta? _metaFor(RolesModel perm) => _meta[_normalize(perm.name)];

  String _categoryFor(RolesModel perm) =>
      _metaFor(perm)?.category ?? 'other';

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        // Auto-select first role when roles first load
        if (_selectedRole == null && state.roles.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _onRoleSelected(state.roles.first);
          });
        }

        // Sync selected role after list refresh (create / update / delete)
        if (_selectedRole != null) {
          final refreshed = state.roles
              .where((r) => r.id == _selectedRole!.id)
              .firstOrNull;
          if (refreshed == null && state.roles.isNotEmpty) {
            // Role was deleted — fall back to first available
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _onRoleSelected(state.roles.first);
            });
          } else if (refreshed == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _selectedRole = null;
                  _activePermissionIds = {};
                });
              }
            });
          } else if (!identical(refreshed, _selectedRole)) {
            // Always update the reference so the DropdownButton value stays
            // in sync with the items list (avoids crash after list refresh).
            // Only reset _activePermissionIds if permissions actually changed
            // (e.g. after a successful save), not on create/update/delete.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  final permsChanged =
                      refreshed.permissions != _selectedRole!.permissions;
                  _selectedRole = refreshed;
                  if (permsChanged) {
                    _activePermissionIds = _permIdsFrom(refreshed);
                  }
                });
              }
            });
          }
        }

        final allPerms = state.permissions;
        final byCategory = <String, List<RolesModel>>{};
        for (final p in allPerms) {
          byCategory.putIfAbsent(_categoryFor(p), () => []).add(p);
        }

        final isLoading =
            state.isLoadingRoles || state.isLoadingPermissions;

        return Padding(
          padding: const EdgeInsets.all(32.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Breadcrumbs
                Row(
                  children: [
                    Text(
                      'Admin',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted.withValues(alpha: 0.8),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        Icons.chevron_right,
                        size: 14,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const Text(
                      'User Management',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        Icons.chevron_right,
                        size: 14,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const Text(
                      'Permissions',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Role Access Control',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Configure system-wide feature permissions and access overrides assigned per professional rank tier.',
                  style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                ),
                const SizedBox(height: 24),

                // Role management card
                _buildRoleSelectorCard(state),
                const SizedBox(height: 24),

                // Permissions area — skeleton or real content
                if (isLoading)
                  _buildPermissionsSkeleton()
                else if (allPerms.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 48),
                      child: Text(
                        'No permissions found.',
                        style: TextStyle(
                            fontSize: 13, color: AppColors.textMuted),
                      ),
                    ),
                  )
                else ...[
                  if (byCategory['user_practitioner'] != null)
                    _buildCategoryBlock(
                      title: 'User & Practitioner Matrix Access',
                      icon: Icons.people_alt_outlined,
                      perms: byCategory['user_practitioner']!,
                    ),
                  if (byCategory['content_events'] != null) ...[
                    const SizedBox(height: 20),
                    _buildCategoryBlock(
                      title: 'Content & Event Repository Matrix',
                      icon: Icons.assignment_outlined,
                      perms: byCategory['content_events']!,
                    ),
                  ],
                  if (byCategory['admin'] != null) ...[
                    const SizedBox(height: 20),
                    _buildCategoryBlock(
                      title:
                          'Administrative Overrides & Base System Configuration',
                      icon: Icons.gavel_rounded,
                      perms: byCategory['admin']!,
                    ),
                  ],
                  if (byCategory['other'] != null) ...[
                    const SizedBox(height: 20),
                    _buildCategoryBlock(
                      title: 'Other Permissions',
                      icon: Icons.lock_outline,
                      perms: byCategory['other']!,
                    ),
                  ],
                ],
                const SizedBox(height: 32),

                // Footer actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: _resetToOriginal,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Reset Matrix',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: state.isSaving || _selectedRole == null
                          ? null
                          : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF005B5C),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: state.isSaving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Save Permissions Layout',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Role selector card ───────────────────────────────────────────────────

  Widget _buildRoleSelectorCard(SettingsState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              const Icon(
                Icons.shield_outlined,
                size: 20,
                color: AppColors.primary,
              ),
              const SizedBox(width: 10),
              const Text(
                'Role Management',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _showCreateRoleDialog,
                icon: const Icon(Icons.add, size: 16),
                label: const Text(
                  'New Role',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Selector row
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDF2F7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: state.isLoadingRoles
                      ? _shimmerBox(double.infinity, 14, radius: 4)
                      : DropdownButtonHideUnderline(
                          child: DropdownButton<RolesModel>(
                            // Resolve value from the live items list by ID so
                            // a stale reference never causes an assertion crash.
                            value: state.roles
                                .where((r) => r.id == _selectedRole?.id)
                                .firstOrNull,
                            isExpanded: true,
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              size: 18,
                              color: AppColors.textMuted,
                            ),
                            style: const TextStyle(
                              color: AppColors.textDark,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                            onChanged: (role) {
                              if (role != null) _onRoleSelected(role);
                            },
                            items: state.roles
                                .map(
                                  (r) => DropdownMenuItem<RolesModel>(
                                    value: r,
                                    child: Text(r.name ?? ''),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 8),

              // Edit button
              _RoleActionButton(
                icon: Icons.edit_outlined,
                tooltip: 'Edit role name',
                color: AppColors.primary,
                enabled: _selectedRole != null,
                onTap: _showEditRoleDialog,
              ),
              const SizedBox(width: 4),

              // Delete button
              _RoleActionButton(
                icon: Icons.delete_outline,
                tooltip: 'Delete role',
                color: Colors.red,
                enabled: _selectedRole != null,
                onTap: _showDeleteRoleDialog,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Skeleton loading ─────────────────────────────────────────────────────

  Widget _buildPermissionsSkeleton() {
    return Column(
      children: [
        _buildSkeletonCategoryBlock(rowCount: 3),
        const SizedBox(height: 20),
        _buildSkeletonCategoryBlock(rowCount: 3),
        const SizedBox(height: 20),
        _buildSkeletonCategoryBlock(rowCount: 3),
      ],
    );
  }

  Widget _buildSkeletonCategoryBlock({required int rowCount}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category header shimmer
          Padding(
            padding: const EdgeInsets.only(
                left: 20, right: 20, top: 18, bottom: 14),
            child: Row(
              children: [
                _shimmerBox(16, 16, radius: 4),
                const SizedBox(width: 8),
                _shimmerBox(180, 14, radius: 4),
              ],
            ),
          ),
          const Divider(color: AppColors.borderLight, height: 1),
          ...List.generate(rowCount, (_) => _buildSkeletonToggleRow()),
        ],
      ),
    );
  }

  Widget _buildSkeletonToggleRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.borderLight, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(260, 13, radius: 4),
                const SizedBox(height: 6),
                _shimmerBox(180, 11, radius: 4),
              ],
            ),
          ),
          const SizedBox(width: 24),
          _shimmerBox(50, 28, radius: 14),
        ],
      ),
    );
  }

  Widget _shimmerBox(double width, double height, {double radius = 8}) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE2E8F0),
      highlightColor: const Color(0xFFF8FAFC),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  // ── Category block ───────────────────────────────────────────────────────

  Widget _buildCategoryBlock({
    required String title,
    required IconData icon,
    required List<RolesModel> perms,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 20, right: 20, top: 18, bottom: 8),
            child: Row(
              children: [
                Icon(icon, size: 16, color: AppColors.textMuted),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.borderLight, height: 1),
          ...perms.map(_buildToggleRow),
        ],
      ),
    );
  }

  Widget _buildToggleRow(RolesModel perm) {
    final meta = _metaFor(perm);
    final label = meta?.label ?? perm.name ?? 'Unknown Permission';
    final description = meta?.description ?? '';
    final isActive =
        perm.id != null && _activePermissionIds.contains(perm.id);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.borderLight, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 24),
          Switch.adaptive(
            value: isActive,
            activeThumbColor: AppColors.primary,
            onChanged: perm.id != null
                ? (v) => _togglePermission(perm.id!, v)
                : null,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Small action icon button with border
// ─────────────────────────────────────────────────────────────────────────────

class _RoleActionButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final Color color;
  final bool enabled;
  final VoidCallback onTap;

  const _RoleActionButton({
    required this.icon,
    required this.tooltip,
    required this.color,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            border: Border.all(
              color: enabled
                  ? color.withValues(alpha: 0.3)
                  : AppColors.borderLight,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 18,
            color: enabled ? color : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Create / Edit role dialog
// ─────────────────────────────────────────────────────────────────────────────

enum _RoleDialogMode { create, edit }

class _RoleFormDialog extends StatefulWidget {
  final _RoleDialogMode mode;
  final RolesModel? role;

  const _RoleFormDialog({required this.mode, this.role});

  @override
  State<_RoleFormDialog> createState() => _RoleFormDialogState();
}

class _RoleFormDialogState extends State<_RoleFormDialog> {
  late final TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.mode == _RoleDialogMode.edit ? widget.role?.name ?? '' : '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _isCreate => widget.mode == _RoleDialogMode.create;

  void _submit(SettingsBloc bloc) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final name = _nameController.text.trim();
    if (_isCreate) {
      bloc.add(CreateRoleRequested(name));
    } else {
      bloc.add(
        UpdateRoleRequested(roleId: widget.role!.id!, name: name),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsBloc, SettingsState>(
      listenWhen: (prev, curr) =>
          (_isCreate &&
              prev.createRoleSuccess != curr.createRoleSuccess &&
              curr.createRoleSuccess) ||
          (!_isCreate &&
              prev.updateRoleSuccess != curr.updateRoleSuccess &&
              curr.updateRoleSuccess),
      listener: (context, _) => Navigator.of(context).pop(),
      builder: (context, state) {
        final isLoading =
            _isCreate ? state.isCreatingRole : state.isUpdatingRole;

        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _isCreate
                                ? Icons.add_circle_outline
                                : Icons.edit_outlined,
                            size: 20,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _isCreate ? 'Create New Role' : 'Edit Role Name',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.only(left: 48),
                      child: Text(
                        _isCreate
                            ? 'Define a new role that can be assigned permissions.'
                            : 'Update the display name for this role.',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Role name field
                    const Text(
                      'Role Name',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      autofocus: true,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textDark,
                      ),
                      decoration: InputDecoration(
                        hintText: 'e.g. Medical Reviewer',
                        hintStyle: TextStyle(
                          color: AppColors.textMuted.withValues(alpha: 0.6),
                          fontSize: 13,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: AppColors.borderLight),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: AppColors.primary, width: 1.5),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Colors.red, width: 1.5),
                        ),
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty)
                              ? 'Role name is required'
                              : null,
                      onFieldSubmitted: (_) =>
                          _submit(context.read<SettingsBloc>()),
                    ),
                    const SizedBox(height: 28),

                    // Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: isLoading
                              ? null
                              : () => Navigator.of(context).pop(),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: AppColors.textMuted),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () =>
                                  _submit(context.read<SettingsBloc>()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  _isCreate ? 'Create Role' : 'Save Changes',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Delete role confirmation dialog
// ─────────────────────────────────────────────────────────────────────────────

class _DeleteRoleDialog extends StatelessWidget {
  final RolesModel role;

  const _DeleteRoleDialog({required this.role});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsBloc, SettingsState>(
      listenWhen: (prev, curr) =>
          prev.deleteRoleSuccess != curr.deleteRoleSuccess &&
          curr.deleteRoleSuccess,
      listener: (context, _) => Navigator.of(context).pop(),
      builder: (context, state) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon + title
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          size: 20,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Delete Role',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Warning message
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textMuted,
                        height: 1.5,
                      ),
                      children: [
                        const TextSpan(text: 'Are you sure you want to delete '),
                        TextSpan(
                          text: role.name ?? 'this role',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const TextSpan(
                          text:
                              '? This will remove all permission assignments for this role and cannot be undone.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: state.isDeletingRole
                            ? null
                            : () => Navigator.of(context).pop(),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: AppColors.textMuted),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: state.isDeletingRole
                            ? null
                            : () => context
                                .read<SettingsBloc>()
                                .add(DeleteRoleRequested(role.id!)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: state.isDeletingRole
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Delete Role',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Permission display metadata
// ─────────────────────────────────────────────────────────────────────────────

class _PermMeta {
  final String category;
  final String label;
  final String description;

  const _PermMeta({
    required this.category,
    required this.label,
    required this.description,
  });
}
