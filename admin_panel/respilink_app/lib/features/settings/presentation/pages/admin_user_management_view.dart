import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:respilink_app/core/theme/app_colors.dart';
import 'package:respilink_app/core/utils/snackbar_util.dart';
import 'package:respilink_app/features/settings/data/model/admin_user_model.dart';
import 'package:respilink_app/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:respilink_app/features/settings/presentation/bloc/settings_event.dart';
import 'package:respilink_app/features/settings/presentation/bloc/settings_state.dart';
import 'package:respilink_app/features/settings/presentation/pages/data/model/roles_model.dart';
import 'package:shimmer/shimmer.dart';

class AdminUserManagementContent extends StatelessWidget {
  const AdminUserManagementContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listenWhen: (prev, curr) =>
          (prev.createAdminSuccess != curr.createAdminSuccess && curr.createAdminSuccess) ||
          (prev.updateAdminSuccess != curr.updateAdminSuccess && curr.updateAdminSuccess) ||
          (prev.deleteAdminSuccess != curr.deleteAdminSuccess && curr.deleteAdminSuccess) ||
          (prev.error != curr.error && curr.error != null),
      listener: (context, state) {
        if (state.createAdminSuccess) {
          SnackbarUtil.showSnackbar(context, message: 'Admin created successfully');
        } else if (state.updateAdminSuccess) {
          SnackbarUtil.showSnackbar(context, message: 'Admin updated successfully');
        } else if (state.deleteAdminSuccess) {
          SnackbarUtil.showSnackbar(context, message: 'Admin deleted successfully');
        } else if (state.error != null) {
          SnackbarUtil.showSnackbar(context, message: state.error!, isError: true);
        }
      },
      child: const _AdminUserBody(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _AdminUserBody extends StatefulWidget {
  const _AdminUserBody();

  @override
  State<_AdminUserBody> createState() => _AdminUserBodyState();
}

class _AdminUserBodyState extends State<_AdminUserBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<SettingsBloc>()
          ..add(FetchAdminsRequested())
          ..add(FetchRolesRequested());
      }
    });
  }

  String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return '—';
    final dt = DateTime.tryParse(raw) ??
        DateTime.tryParse(raw.replaceFirst(' ', 'T'));
    if (dt == null) return raw;
    return DateFormat('MMM d, yyyy').format(dt.toLocal());
  }

  void _showCreateDialog(BuildContext context, List<RolesModel> roles) {
    final bloc = context.read<SettingsBloc>();
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: _AdminFormDialog(
          roles: roles,
          onSubmit: (name, email, password, roleName) {
            bloc.add(CreateAdminRequested(
              name: name,
              email: email,
              password: password,
              passwordConfirmation: password,
              roles: [roleName],
            ));
          },
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, AdminUserModel admin, List<RolesModel> roles) {
    final bloc = context.read<SettingsBloc>();
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: _AdminFormDialog(
          existingAdmin: admin,
          roles: roles,
          onSubmit: (name, email, password, roleName) {
            bloc.add(UpdateAdminRequested(
              adminId: admin.id!,
              name: name,
              email: email,
              password: password.isNotEmpty ? password : null,
              passwordConfirmation: password.isNotEmpty ? password : null,
              roles: [roleName],
            ));
          },
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, AdminUserModel admin) {
    showDialog(
      context: context,
      builder: (_) => _DeleteAdminDialog(
        adminName: admin.name ?? 'this admin',
        onConfirm: () {
          context.read<SettingsBloc>().add(DeleteAdminRequested(admin.id!));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User Management',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Manage admin accounts and assign roles',
                        style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: state.isLoadingRoles
                        ? null
                        : () => _showCreateDialog(context, state.roles),
                    icon: const Icon(Icons.person_add_outlined, size: 18),
                    label: const Text('Invite Admin'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Table card
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderLight),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Table header
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.scaffoldBg,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          border: Border(
                            bottom: BorderSide(color: AppColors.borderLight),
                          ),
                        ),
                        child: Row(
                          children: [
                            _HeaderCell('NAME', flex: 3),
                            _HeaderCell('EMAIL', flex: 3),
                            _HeaderCell('ROLE', flex: 2),
                            _HeaderCell('CREATED', flex: 2),
                            _HeaderCell('ACTIONS', flex: 1),
                          ],
                        ),
                      ),

                      // Rows
                      Expanded(
                        child: state.isLoadingAdmins
                            ? _AdminShimmer()
                            : state.admins.isEmpty
                                ? Center(
                                    child: Text(
                                      'No admin users found.',
                                      style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                                    ),
                                  )
                                : ListView.separated(
                                    itemCount: state.admins.length,
                                    separatorBuilder: (_, _) =>
                                        Divider(height: 1, color: AppColors.borderLight),
                                    itemBuilder: (context, i) {
                                      final admin = state.admins[i];
                                      return _AdminRow(
                                        admin: admin,
                                        formattedDate: _formatDate(admin.createdAt),
                                        onEdit: () => _showEditDialog(context, admin, state.roles),
                                        onDelete: () => _showDeleteDialog(context, admin),
                                      );
                                    },
                                  ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _HeaderCell extends StatelessWidget {
  final String label;
  final int flex;

  const _HeaderCell(this.label, {this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.textMuted,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _AdminRow extends StatefulWidget {
  final AdminUserModel admin;
  final String formattedDate;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AdminRow({
    required this.admin,
    required this.formattedDate,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_AdminRow> createState() => _AdminRowState();
}

class _AdminRowState extends State<_AdminRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        color: _isHovered ? AppColors.scaffoldBg : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            // Name
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                    child: Text(
                      (widget.admin.name?.isNotEmpty == true)
                          ? widget.admin.name![0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      widget.admin.name ?? '—',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDark,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            // Email
            Expanded(
              flex: 3,
              child: Text(
                widget.admin.email ?? '—',
                style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Role
            Expanded(
              flex: 2,
              child: (widget.admin.roles?.isNotEmpty == true)
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.admin.roles!.first.name ?? '—',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  : Text('—', style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
            ),
            // Created
            Expanded(
              flex: 2,
              child: Text(
                widget.formattedDate,
                style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
              ),
            ),
            // Actions
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    color: AppColors.textMuted,
                    tooltip: 'Edit',
                    onPressed: widget.onEdit,
                    splashRadius: 18,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18),
                    color: Colors.red.shade400,
                    tooltip: 'Delete',
                    onPressed: widget.onDelete,
                    splashRadius: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _AdminFormDialog extends StatefulWidget {
  final AdminUserModel? existingAdmin;
  final List<RolesModel> roles;
  final void Function(String name, String email, String password, String roleName) onSubmit;

  const _AdminFormDialog({
    this.existingAdmin,
    required this.roles,
    required this.onSubmit,
  });

  @override
  State<_AdminFormDialog> createState() => _AdminFormDialogState();
}

class _AdminFormDialogState extends State<_AdminFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  final TextEditingController _passwordCtrl = TextEditingController();
  String? _selectedRoleName;
  bool _obscurePassword = true;

  bool get _isEdit => widget.existingAdmin != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.existingAdmin?.name ?? '');
    _emailCtrl = TextEditingController(text: widget.existingAdmin?.email ?? '');
    _selectedRoleName = widget.existingAdmin?.roles?.isNotEmpty == true
        ? widget.existingAdmin!.roles!.first.name
        : null;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        _isEdit ? 'Edit Admin' : 'Invite Admin',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
      ),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _FormField(
                controller: _nameCtrl,
                label: 'Full Name',
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 14),
              _FormField(
                controller: _emailCtrl,
                label: 'Email Address',
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (!v.contains('@')) return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _passwordCtrl,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: _isEdit ? 'New Password (leave blank to keep)' : 'Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                validator: (v) {
                  if (!_isEdit && (v == null || v.trim().isEmpty)) return 'Required';
                  if (v != null && v.isNotEmpty && v.length < 6) return 'Min 6 characters';
                  return null;
                },
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                initialValue: _selectedRoleName,
                decoration: InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                ),
                items: widget.roles
                    .map((r) => DropdownMenuItem(value: r.name, child: Text(r.name ?? '—')))
                    .toList(),
                onChanged: (v) => _selectedRoleName = v,
                validator: (v) => v == null ? 'Select a role' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            final isLoading = _isEdit ? state.isUpdatingAdmin : state.isCreatingAdmin;
            return ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      if (_formKey.currentState!.validate()) {
                        widget.onSubmit(
                          _nameCtrl.text.trim(),
                          _emailCtrl.text.trim(),
                          _passwordCtrl.text,
                          _selectedRoleName!,
                        );
                        Navigator.pop(context);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Text(_isEdit ? 'Save Changes' : 'Invite'),
            );
          },
        ),
      ],
    );
  }
}

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _FormField({
    required this.controller,
    required this.label,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
      validator: validator,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _DeleteAdminDialog extends StatelessWidget {
  final String adminName;
  final VoidCallback onConfirm;

  const _DeleteAdminDialog({required this.adminName, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Delete Admin', style: TextStyle(fontWeight: FontWeight.bold)),
      content: Text('Are you sure you want to delete "$adminName"? This action cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _AdminShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: ListView.separated(
        itemCount: 5,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (_, _) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              const CircleAvatar(radius: 16, backgroundColor: Colors.white),
              const SizedBox(width: 10),
              Expanded(flex: 3, child: _ShimmerBox(height: 14)),
              const SizedBox(width: 16),
              Expanded(flex: 3, child: _ShimmerBox(height: 14)),
              const SizedBox(width: 16),
              Expanded(flex: 2, child: _ShimmerBox(height: 22, borderRadius: 20)),
              const SizedBox(width: 16),
              Expanded(flex: 2, child: _ShimmerBox(height: 14)),
              const SizedBox(width: 16),
              Expanded(flex: 1, child: _ShimmerBox(height: 14)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double height;
  final double borderRadius;

  const _ShimmerBox({required this.height, this.borderRadius = 4});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
