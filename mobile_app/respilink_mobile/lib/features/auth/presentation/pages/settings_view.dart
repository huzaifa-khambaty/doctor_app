import 'package:respilink_mobile/core/network/api_endpoints.dart';
import 'package:respilink_mobile/core/utils/global_notifiers.dart';
import 'package:respilink_mobile/features/auth/domain/models/user_model.dart';
import 'package:respilink_mobile/shared/widgets/app_notification_bell.dart';

import '../../../../exports.dart';

class SettingsView extends StatefulWidget {
  final bool showBackButton;

  const SettingsView({super.key, this.showBackButton = true});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _pushNotifications = true;
  bool _newsletter = false;
  bool _biometricLogin = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        leading: widget.showBackButton
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 18.sp,
                  color: AppColors.black,
                ),
                onPressed: () => locator<NavigationService>().pop(),
              )
            : null,
        title: AppText.medium(
          label: 'Settings',
          fontWeight: FontWeight.bold,
          color: AppColors.black,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: AppNotificationBell(color: AppColors.black),
          ),
        ],
      ),
      body: ValueListenableBuilder<Doctor?>(
        valueListenable: GlobalNotifiers.userNotifier,
        builder: (context, user, child) {
          return SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        user?.profilePhotoPath != null
                            ? AppNetworkImage(
                                imageUrl:
                                    "${ApiEndpoints.imageUrl}/${user!.profilePhotoPath}",
                                width: 80.r,
                                height: 80.r,
                                isCircle: true,
                              )
                            : CircleAvatar(
                                radius: 40.r,
                                backgroundColor: AppColors.fieldColor,
                                child: Icon(
                                  Icons.person,
                                  color: AppColors.grey,
                                  size: 40.sp,
                                ),
                              ),
                        SizedBox(height: 12.h),
                        AppText.large(
                          label: user?.fullName ?? 'Dr. Sarah Jenkins',
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                        ),
                        SizedBox(height: 4.h),
                        AppText.small(
                          label: "${user?.specialties?.map((e) => e.name).whereType<String>().join(", ") ?? 'General Physician'}\n${user?.hospitalAffiliation ?? 'St. Mary'}",
                          color: AppColors.grey,
                          textAlign: .center,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 28.h),

                  _SettingsGroup(
                    title: 'Account',
                    children: [
                      _SettingsRow(
                        icon: Icons.person_outline,
                        label: 'Personal Information',
                        onTap: () => locator<NavigationService>().navigate(
                          RouterStrings.editProfile,
                        ),
                      ),
                      _SettingsRow(
                        icon: Icons.mail_outline,
                        label: 'Email Address',
                        trailingText: user?.email ?? 's.jenkins@hospital.org',
                        onTap: () {},
                        isLast: true,
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  _SettingsGroup(
                    title: 'Notifications',
                    children: [
                      _SettingsRow(
                        icon: Icons.notifications_none_outlined,
                        label: 'Push Notifications',
                        subtitle: 'Alerts for new events & messages',
                        toggleValue: _pushNotifications,
                        onToggle: (v) => setState(() => _pushNotifications = v),
                      ),
                      _SettingsRow(
                        icon: Icons.mail_outline,
                        label: 'Newsletter & Updates',
                        toggleValue: _newsletter,
                        onToggle: (v) => setState(() => _newsletter = v),
                        isLast: true,
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  _SettingsGroup(
                    title: 'Privacy & Security',
                    children: [
                      _SettingsRow(
                        icon: Icons.lock_outline,
                        label: 'Change Password',
                        onTap: () => locator<NavigationService>().navigate(
                          RouterStrings.changePassword,
                        ),
                      ),
                      _SettingsRow(
                        icon: Icons.fingerprint,
                        label: 'Biometric Login',
                        toggleValue: _biometricLogin,
                        onToggle: (v) => setState(() => _biometricLogin = v),
                        isLast: true,
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  // _SettingsGroup(
                  //   title: 'Appearance',
                  //   children: [
                  //     _SettingsRow(
                  //       icon: Icons.dark_mode_outlined,
                  //       label: 'Dark Mode',
                  //       toggleValue: _darkMode,
                  //       onToggle: (v) => setState(() => _darkMode = v),
                  //       isLast: true,
                  //     ),
                  //   ],
                  // ),

                  SizedBox(height: 16.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsGroup({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: AppText.small(
            label: title.toUpperCase(),
            color: AppColors.grey,
            fontWeight: FontWeight.w600,
            fontSize: 11.sp,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.fieldColor,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final String? trailingText;
  final bool? toggleValue;
  final ValueChanged<bool>? onToggle;
  final VoidCallback? onTap;
  final bool isLast;

  const _SettingsRow({
    required this.icon,
    required this.label,
    this.subtitle,
    this.trailingText,
    this.toggleValue,
    this.onToggle,
    this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final isToggle = toggleValue != null;

    return GestureDetector(
      onTap: isToggle ? null : onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(color: AppColors.white, width: 1.5.h),
                ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 20.sp),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.medium(
                    label: label,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 2.h),
                    AppText.small(
                      label: subtitle!,
                      color: AppColors.grey,
                      fontSize: 11.sp,
                    ),
                  ],
                ],
              ),
            ),
            if (trailingText != null) ...[
              AppText.small(
                label: trailingText!,
                color: AppColors.grey,
                fontSize: 11.sp,
              ),
              SizedBox(width: 6.w),
            ],
            if (isToggle)
              Transform.scale(
                scale: 0.75,
                child: Switch(
                  value: toggleValue!,
                  onChanged: onToggle,
                  activeThumbColor: AppColors.white,
                  activeTrackColor: AppColors.primary,
                ),
              )
            else
              Icon(Icons.chevron_right, color: AppColors.grey, size: 20.sp),
          ],
        ),
      ),
    );
  }
}
