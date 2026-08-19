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
          (prev.updateRoleSuccess != curr.updateRoleSuccess &&
              curr.updateRoleSuccess) ||
          (prev.createRoleSuccess != curr.createRoleSuccess &&
              curr.createRoleSuccess) ||
          (prev.deleteRoleSuccess != curr.deleteRoleSuccess &&
              curr.deleteRoleSuccess) ||
          (prev.error != curr.error && curr.error != null),
      listener: (context, state) {
        if (state.updateRoleSuccess) {
          SnackbarUtil.showSnackbar(
            context,
            message: 'Permissions updated successfully',
          );
        } else if (state.createRoleSuccess) {
          SnackbarUtil.showSnackbar(
            context,
            message: 'Role created successfully',
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
      _activePermissionIds = {};
    });
    if (role.id != null) {
      context.read<SettingsBloc>().add(FetchRolePermissionsRequested(role.id!));
    }
  }

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
    final allPerms = context.read<SettingsBloc>().state.permissions;
    final permissionNames = allPerms
        .where((p) => p.id != null && _activePermissionIds.contains(p.id))
        .map((p) => p.name!)
        .toList();
    context.read<SettingsBloc>().add(
          UpdateRoleRequested(
            roleId: _selectedRole!.id!,
            name: _selectedRole!.name ?? '',
            permissions: permissionNames,
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
    // Users
    'users.view': _PermMeta(
      category: 'users',
      label: 'View Users',
      description: 'Access the users and practitioners list.',
    ),
    'users.create': _PermMeta(
      category: 'users',
      label: 'Create Users',
      description: 'Manually enroll and create new practitioner accounts.',
    ),
    'users.edit': _PermMeta(
      category: 'users',
      label: 'Edit Users',
      description: 'Update user profiles and account details.',
    ),
    'users.verify': _PermMeta(
      category: 'users',
      label: 'Verify Users',
      description: 'Approve or override practitioner credential verifications.',
    ),
    'users.suspend': _PermMeta(
      category: 'users',
      label: 'Suspend Users',
      description: 'Temporarily suspend user access.',
    ),
    'users.manage': _PermMeta(
      category: 'users',
      label: 'Manage Users',
      description: 'Full user management including role assignments.',
    ),
    'users.delete': _PermMeta(
      category: 'users',
      label: 'Delete Users',
      description: 'Soft-delete user accounts.',
    ),
    'users.restore': _PermMeta(
      category: 'users',
      label: 'Restore Users',
      description: 'Restore previously deleted user accounts.',
    ),
    'users.force_delete': _PermMeta(
      category: 'users',
      label: 'Force Delete Users',
      description: 'Permanently remove user accounts from the system.',
    ),
    // Admins
    'admins.view': _PermMeta(
      category: 'admin',
      label: 'View Admins',
      description: 'View admin users and analytics.',
    ),
    'admins.create': _PermMeta(
      category: 'admin',
      label: 'Create Admins',
      description: 'Create new admin accounts.',
    ),
    'admins.edit': _PermMeta(
      category: 'admin',
      label: 'Edit Admins',
      description: 'Update admin profiles and credentials.',
    ),
    'admins.delete': _PermMeta(
      category: 'admin',
      label: 'Delete Admins',
      description: 'Remove admin accounts from the system.',
    ),
    'roles.manage': _PermMeta(
      category: 'admin',
      label: 'Manage Roles & Permissions',
      description: 'Create, edit, and assign roles and their permissions.',
    ),
    // Events
    'events.view': _PermMeta(
      category: 'events',
      label: 'View Events',
      description: 'Access the events listing.',
    ),
    'events.create': _PermMeta(
      category: 'events',
      label: 'Create Events',
      description: 'Schedule new events and webinars.',
    ),
    'events.edit': _PermMeta(
      category: 'events',
      label: 'Edit Events',
      description: 'Update event details and scheduling.',
    ),
    'events.publish': _PermMeta(
      category: 'events',
      label: 'Publish Events',
      description: 'Publish events to make them visible to users.',
    ),
    'events.delete': _PermMeta(
      category: 'events',
      label: 'Delete Events',
      description: 'Remove events from the platform.',
    ),
    // Quizzes
    'quizzes.view': _PermMeta(
      category: 'quizzes',
      label: 'View Quizzes',
      description: 'Access the quiz directory.',
    ),
    'quizzes.create': _PermMeta(
      category: 'quizzes',
      label: 'Create Quizzes',
      description: 'Draft and create new clinical assessments.',
    ),
    'quizzes.edit': _PermMeta(
      category: 'quizzes',
      label: 'Edit Quizzes',
      description: 'Update quiz questions and options.',
    ),
    'quizzes.publish': _PermMeta(
      category: 'quizzes',
      label: 'Publish Quizzes',
      description: 'Publish quizzes to make them available to users.',
    ),
    'quizzes.delete': _PermMeta(
      category: 'quizzes',
      label: 'Delete Quizzes',
      description: 'Remove quizzes from the platform.',
    ),
    'quizzes.leaderboard.manage': _PermMeta(
      category: 'quizzes',
      label: 'Manage Quiz Leaderboard',
      description: 'View and manage quiz leaderboard entries.',
    ),
    // Content
    'content.view': _PermMeta(
      category: 'content',
      label: 'View Content',
      description: 'Access the content repository.',
    ),
    'content.create': _PermMeta(
      category: 'content',
      label: 'Create Content',
      description: 'Upload and create new content items.',
    ),
    'content.edit': _PermMeta(
      category: 'content',
      label: 'Edit Content',
      description: 'Update existing content details.',
    ),
    'content.publish': _PermMeta(
      category: 'content',
      label: 'Publish Content',
      description: 'Publish content to make it visible to users.',
    ),
    'content.delete': _PermMeta(
      category: 'content',
      label: 'Delete Content',
      description: 'Remove content from the platform.',
    ),
    // Settings
    'settings.view': _PermMeta(
      category: 'settings',
      label: 'View Settings',
      description: 'Access platform settings.',
    ),
    'settings.update': _PermMeta(
      category: 'settings',
      label: 'Update Settings',
      description: 'Modify platform configuration and settings.',
    ),
    // Notifications
    'notifications.view': _PermMeta(
      category: 'notifications',
      label: 'View Notifications',
      description: 'View scheduled and sent notifications.',
    ),
    'notifications.create': _PermMeta(
      category: 'notifications',
      label: 'Create Notifications',
      description: 'Send and schedule push notifications.',
    ),
    'notifications.delete': _PermMeta(
      category: 'notifications',
      label: 'Delete Notifications',
      description: 'Remove scheduled or sent notifications.',
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
    return BlocConsumer<SettingsBloc, SettingsState>(
      listenWhen: (prev, curr) =>
          prev.isLoadingRolePermissions && !curr.isLoadingRolePermissions,
      listener: (context, state) {
        setState(() {
          _activePermissionIds = Set<int>.from(
            state.rolePermissions.map((p) => p.id).whereType<int>(),
          );
        });
      },
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
            // Update the reference so the DropdownButton value stays in sync.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) setState(() => _selectedRole = refreshed);
            });
          }
        }

        final allPerms = state.permissions;
        final byCategory = <String, List<RolesModel>>{};
        for (final p in allPerms) {
          byCategory.putIfAbsent(_categoryFor(p), () => []).add(p);
        }

        final isLoading = state.isLoadingRoles ||
            state.isLoadingPermissions ||
            state.isLoadingRolePermissions;

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
                  if (byCategory['users'] != null)
                    _buildCategoryBlock(
                      title: 'Users & Practitioners',
                      icon: Icons.people_alt_outlined,
                      perms: byCategory['users']!,
                    ),
                  if (byCategory['content'] != null) ...[
                    const SizedBox(height: 20),
                    _buildCategoryBlock(
                      title: 'Content',
                      icon: Icons.description_outlined,
                      perms: byCategory['content']!,
                    ),
                  ],
                  if (byCategory['events'] != null) ...[
                    const SizedBox(height: 20),
                    _buildCategoryBlock(
                      title: 'Events',
                      icon: Icons.calendar_today_outlined,
                      perms: byCategory['events']!,
                    ),
                  ],
                  if (byCategory['quizzes'] != null) ...[
                    const SizedBox(height: 20),
                    _buildCategoryBlock(
                      title: 'Quizzes',
                      icon: Icons.quiz_outlined,
                      perms: byCategory['quizzes']!,
                    ),
                  ],
                  if (byCategory['admin'] != null) ...[
                    const SizedBox(height: 20),
                    _buildCategoryBlock(
                      title: 'Admin Management',
                      icon: Icons.admin_panel_settings_outlined,
                      perms: byCategory['admin']!,
                    ),
                  ],
                  if (byCategory['settings'] != null) ...[
                    const SizedBox(height: 20),
                    _buildCategoryBlock(
                      title: 'Settings',
                      icon: Icons.settings_outlined,
                      perms: byCategory['settings']!,
                    ),
                  ],
                  if (byCategory['notifications'] != null) ...[
                    const SizedBox(height: 20),
                    _buildCategoryBlock(
                      title: 'Notifications',
                      icon: Icons.notifications_outlined,
                      perms: byCategory['notifications']!,
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
                    
                    ElevatedButton(
                      onPressed: state.isUpdatingRole || _selectedRole == null
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
                      child: state.isUpdatingRole
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
