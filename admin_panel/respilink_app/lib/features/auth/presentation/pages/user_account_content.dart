import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:respilink_app/core/theme/app_colors.dart';
import 'package:respilink_app/core/utils/global_notifiers.dart';
import 'package:respilink_app/core/utils/snackbar_util.dart';
import 'package:respilink_app/features/auth/data/models/requests/change_password_request.dart';
import 'package:respilink_app/features/auth/data/models/requests/edit_profile_request.dart';
import 'package:respilink_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:respilink_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:respilink_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:respilink_app/injections.dart';
import 'package:respilink_app/routes/router_strings.dart';
import 'package:respilink_app/shared/model/admin_mode.dart';
import 'package:respilink_app/shared/widgets/app_network_image.dart';

class UserAccountContent extends StatefulWidget {
  const UserAccountContent({super.key});

  @override
  State<UserAccountContent> createState() => _UserAccountContentState();
}

class _UserAccountContentState extends State<UserAccountContent> {
  late final AuthBloc _authBloc;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;

  Uint8List? _photoBytes;
  String? _photoName;

  @override
  void initState() {
    super.initState();
    _authBloc = locator<AuthBloc>();
    final admin = GlobalNotifiers.adminNotifier.value;
    _nameCtrl  = TextEditingController(text: admin?.name  ?? '');
    _emailCtrl = TextEditingController(text: admin?.email ?? '');
  }

  @override
  void dispose() {
    _authBloc.close();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _discard(Admin? admin) {
    setState(() {
      _nameCtrl.text  = admin?.name  ?? '';
      _emailCtrl.text = admin?.email ?? '';
      _photoBytes = null;
      _photoName  = null;
    });
  }

  Future<void> _pickPhoto() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.single;
    if (file.bytes == null) return;
    setState(() {
      _photoBytes = file.bytes;
      _photoName  = file.name;
    });
  }

  void _showChangePasswordDialog(Admin? admin) {
    if (admin?.id == null) {
      SnackbarUtil.showSnackbar(context, message: 'Admin ID not found', isError: true);
      return;
    }
    showDialog(
      context: context,
      builder: (dialogContext) => _ChangePasswordDialog(
        onSubmit: (current, password, confirm) {
          Navigator.of(dialogContext).pop();
          _authBloc.add(ChangeAdminPasswordRequested(
            adminId: admin!.id!,
            request: ChangePasswordRequest(
              current: current,
              password: password,
              cnfPassword: confirm,
            ),
          ));
        },
      ),
    );
  }

  void _submit(Admin? admin) {
    final name  = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    if (name.isEmpty) {
      SnackbarUtil.showSnackbar(context, message: 'Name is required', isError: true);
      return;
    }
    if (email.isEmpty) {
      SnackbarUtil.showSnackbar(context, message: 'Email is required', isError: true);
      return;
    }
    if (admin?.id == null) {
      SnackbarUtil.showSnackbar(context, message: 'Admin ID not found', isError: true);
      return;
    }
    _authBloc.add(UpdateAdminRequested(
      adminId: admin!.id!,
      request: EditProfileRequest(
        name: name,
        email: email,
        photoBytes: _photoBytes,
        photoName: _photoName,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _authBloc,
      child: BlocConsumer<AuthBloc, AuthState>(
        listenWhen: (prev, curr) =>
            curr is AuthSuccess || curr is AuthFailed || curr is ChangePasswordSuccess,
        listener: (context, state) {
          if (state is AuthSuccess) {
            setState(() { _photoBytes = null; _photoName = null; });
            SnackbarUtil.showSnackbar(context, message: 'Profile updated successfully');
          } else if (state is ChangePasswordSuccess) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                title: const Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: AppColors.primary, size: 22),
                    SizedBox(width: 8),
                    Text('Password Changed', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                content: const Text(
                  'Your password has been changed successfully.\nPlease log in again with your new password.',
                  style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () => context.go(RouterStrings.initial),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF005B5C),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Go to Login', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          } else if (state is AuthFailed) {
            SnackbarUtil.showSnackbar(context, message: state.message, isError: true);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          return ValueListenableBuilder<Admin?>(
            valueListenable: GlobalNotifiers.adminNotifier,
            builder: (context, admin, _) {
              return Padding(
                padding: const EdgeInsets.all(32.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Breadcrumb
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
                            padding: EdgeInsets.symmetric(horizontal: 4.0),
                            child: Icon(Icons.chevron_right, size: 14, color: AppColors.textMuted),
                          ),
                          const Text(
                            'My Account',
                            style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Account Settings',
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textDark),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Manage your personal administrator identity details and authentication credentials.',
                        style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 24),

                      // Profile header card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: isLoading ? null : _pickPhoto,
                              child: Stack(
                                children: [
                                  Container(
                                    width: 72,
                                    height: 72,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF0C4A60),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: _photoBytes != null
                                        ? AppNetworkImage(
                                            bytes: _photoBytes,
                                            width: 72,
                                            height: 72,
                                            fit: BoxFit.cover,
                                          )
                                        : (admin?.photoUrl != null && admin!.photoUrl!.isNotEmpty)
                                            ? AppNetworkImage(
                                                imageUrl: admin.photoUrl,
                                                width: 72,
                                                height: 72,
                                                fit: BoxFit.cover,
                                                errorWidget: _avatarInitial(admin.name),
                                              )
                                            : _avatarInitial(admin?.name),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.camera_alt_outlined, size: 12, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    admin?.name ?? '',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'Super Admin Profile',
                                    style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'System Level Root Access • Last login: ${_formatDate(admin?.lastLoginAt)}',
                                    style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Personal information card
                      Container(
                        width: double.infinity,
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
                              'Personal Information',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark),
                            ),
                            const SizedBox(height: 16),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final isCompact = constraints.maxWidth < 600;
                                return Flex(
                                  direction: isCompact ? Axis.vertical : Axis.horizontal,
                                  children: [
                                    Expanded(
                                      flex: isCompact ? 0 : 1,
                                      child: _buildField(label: 'Full Name', controller: _nameCtrl, enabled: !isLoading),
                                    ),
                                    SizedBox(width: isCompact ? 0 : 16, height: isCompact ? 16 : 0),
                                    Expanded(
                                      flex: isCompact ? 0 : 1,
                                      child: _buildField(label: 'Email Address', controller: _emailCtrl, enabled: !isLoading, keyboardType: TextInputType.emailAddress),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Security card
                      Container(
                        width: double.infinity,
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
                              'Security & Access',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Account Access Password',
                                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Update your credential passkey periodically to protect access.',
                                      style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                                    ),
                                  ],
                                ),
                                OutlinedButton(
                                  onPressed: isLoading ? null : () => _showChangePasswordDialog(admin),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: AppColors.borderLight),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  ),
                                  child: const Text(
                                    'Change Password',
                                    style: TextStyle(color: AppColors.textDark, fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Footer actions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: isLoading ? null : () => _discard(admin),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              side: const BorderSide(color: Color(0xFFCBD5E1)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text(
                              'Discard',
                              style: TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: isLoading ? null : () => _submit(admin),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF005B5C),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              elevation: 0,
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : const Text(
                                    'Save Profile Changes',
                                    style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
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
        },
      ),
    );
  }

  String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return '—';
    final dt = DateTime.tryParse(raw) ??
        DateTime.tryParse(raw.replaceFirst(' ', 'T'));
    if (dt == null) return raw;
    return DateFormat('d MMM yyyy, h:mm a').format(dt.toLocal());
  }

  Widget _avatarInitial(String? name) {
    return Center(
      child: Text(
        name?.isNotEmpty == true ? name![0].toUpperCase() : '?',
        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 42,
          child: TextField(
            controller: controller,
            enabled: enabled,
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 13, color: AppColors.textDark, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              filled: true,
              fillColor: enabled ? Colors.white : const Color(0xFFF8FAFC),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.borderLight, width: 1.2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.borderLight, width: 1.2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ChangePasswordDialog extends StatefulWidget {
  final void Function(String current, String password, String confirm) onSubmit;
  const _ChangePasswordDialog({required this.onSubmit});

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final _currentCtrl  = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl  = TextEditingController();

  bool _obscureCurrent  = true;
  bool _obscurePassword = true;
  bool _obscureConfirm  = true;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final current  = _currentCtrl.text.trim();
    final password = _passwordCtrl.text.trim();
    final confirm  = _confirmCtrl.text.trim();

    if (current.isEmpty || password.isEmpty || confirm.isEmpty) {
      SnackbarUtil.showSnackbar(context, message: 'All fields are required', isError: true);
      return;
    }
    if (password != confirm) {
      SnackbarUtil.showSnackbar(context, message: 'Passwords do not match', isError: true);
      return;
    }
    if (password.length < 8) {
      SnackbarUtil.showSnackbar(context, message: 'Password must be at least 8 characters', isError: true);
      return;
    }
    widget.onSubmit(current, password, confirm);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text('Change Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _passwordField('Current Password', _currentCtrl, _obscureCurrent, () => setState(() => _obscureCurrent = !_obscureCurrent)),
            const SizedBox(height: 14),
            _passwordField('New Password', _passwordCtrl, _obscurePassword, () => setState(() => _obscurePassword = !_obscurePassword)),
            const SizedBox(height: 14),
            _passwordField('Confirm New Password', _confirmCtrl, _obscureConfirm, () => setState(() => _obscureConfirm = !_obscureConfirm)),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF005B5C),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          child: const Text('Update Password', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
        ),
      ],
    );
  }

  Widget _passwordField(String label, TextEditingController ctrl, bool obscure, VoidCallback toggle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          obscureText: obscure,
          style: const TextStyle(fontSize: 13, color: AppColors.textDark),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.borderLight, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            suffixIcon: IconButton(
              icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18, color: AppColors.textMuted),
              onPressed: toggle,
            ),
          ),
        ),
      ],
    );
  }
}
