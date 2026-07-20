import 'package:respilink_mobile/core/network/api_endpoints.dart';
import 'package:respilink_mobile/core/utils/global_notifiers.dart';
import 'package:respilink_mobile/features/auth/domain/models/user_model.dart';
import 'package:respilink_mobile/shared/widgets/app_notification_bell.dart';

import '../../../../exports.dart';

// TODO: replace with real data from the backend once the profile/stats API is wired up.
List<(int, String, Color)> _stats = [
  (GlobalNotifiers.userNotifier.value?.quizCount ?? 0, 'QUIZZES', AppColors.primary),
  (GlobalNotifiers.userNotifier.value?.rank ?? 0, 'RANK', AppColors.yellow),
  (GlobalNotifiers.userNotifier.value?.badgeCount ?? 0, 'BADGES', AppColors.purpleAccent),
];

/// Profile summary only has room for a handful — "View All" opens the full
/// Badges screen for the rest.
const _maxBadgesShown = 4;

class ProfileView extends StatelessWidget {
  final bool showBackButton;

  const ProfileView({super.key, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: showBackButton ? 0 : 20.w,
        automaticallyImplyLeading: false,
        leading: showBackButton
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 18.sp,
                  color: AppColors.black,
                ),
                onPressed: () => locator<NavigationService>().pop(),
              )
            : null,
        title: AppText.large(
          label: 'RespiLink',
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
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
                  _ProfileCard(user: user),

                  SizedBox(height: 16.h),

                  _StatsRow(stats: _stats),

                  SizedBox(height: 20.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText.medium(
                        label: 'Earned Badges',
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                      ),
                      GestureDetector(
                        onTap: () {
                          locator<NavigationService>().navigate(
                            RouterStrings.badges,
                          );
                        },
                        child: AppText.small(
                          label: 'View All',
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  _EarnedBadgesRow(badges: user?.earnedBadges ?? const []),

                  SizedBox(height: 24.h),

                  _ProfileMenu(
                    items: [
                      _ProfileMenuItem(
                        icon: Icons.settings_outlined,
                        label: 'Account Settings',
                        onTap: () => locator<NavigationService>().navigate(
                          RouterStrings.settings,
                        ),
                      ),
                      _ProfileMenuItem(
                        icon: Icons.shield_outlined,
                        label: 'Privacy & Security',
                        onTap: () {
                          // TODO: navigate to the privacy & security screen once it exists.
                        },
                      ),
                      _ProfileMenuItem(
                        icon: Icons.help_outline,
                        label: 'Support Center',
                        onTap: () {
                          // TODO: navigate to the support center once it exists.
                        },
                      ),
                      _ProfileMenuItem(
                        icon: Icons.question_mark_outlined,
                        label: 'Submit a Query',
                        onTap: () {
                          locator<NavigationService>().navigate(
                            RouterStrings.queryForm,
                          );
                        },
                        isLast: true,
                      ),
                    ],
                  ),

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

class _ProfileCard extends StatelessWidget {
  final Doctor? user;

  const _ProfileCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.tealGradientStart, AppColors.deeperTeal],
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(3.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.4),
                width: 2,
              ),
            ),
            child: user?.profilePhotoPath != null
                ? AppNetworkImage(
                    imageUrl:
                        "${ApiEndpoints.imageUrl}${user!.profilePhotoPath}",
                    width: 76.r,
                    height: 76.r,
                    isCircle: true,
                  )
                : CircleAvatar(
                    radius: 38.r,
                    backgroundColor: AppColors.white.withValues(alpha: 0.15),
                    child: Icon(
                      Icons.person,
                      color: AppColors.white,
                      size: 38.sp,
                    ),
                  ),
          ),
          SizedBox(height: 14.h),
          AppText.large(
            label: user?.fullName ?? 'Dr. Ayesha Khan',
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
          SizedBox(height: 4.h),
          AppText.small(
            label:
                user?.specialties
                    ?.map((e) => e.name)
                    .whereType<String>()
                    .join(", ") ??
                'General Physician',
            color: AppColors.white.withValues(alpha: 0.85),
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.local_hospital_outlined,
                color: AppColors.white.withValues(alpha: 0.85),
                size: 13.sp,
              ),
              SizedBox(width: 4.w),
              AppText.small(
                label:
                    user?.hospitalAffiliation ?? "St. Mary's General Hospital",
                color: AppColors.white.withValues(alpha: 0.85),
                fontSize: 11.sp,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final List<(int, String, Color)> stats;

  const _StatsRow({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.fieldColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: stats
            .map(
              (stat) => Expanded(
                child: Column(
                  children: [
                    AppText.large(
                      label: "${stat.$1}",
                      color: stat.$3,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                    ),
                    SizedBox(height: 2.h),
                    AppText.small(
                      label: stat.$2,
                      color: AppColors.grey,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _EarnedBadgesRow extends StatelessWidget {
  final List<EarnedBadges> badges;

  const _EarnedBadgesRow({required this.badges});

  @override
  Widget build(BuildContext context) {
    if (badges.isEmpty) {
      return AppText.small(
        label: 'No badges earned yet.',
        color: AppColors.grey,
      );
    }

    return Row(
      crossAxisAlignment: .start,
      children: badges
          .take(_maxBadgesShown)
          .map((badge) => _BadgeTile(badge: badge))
          .toList(),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  final EarnedBadges badge;

  const _BadgeTile({required this.badge});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48.r,
          height: 48.r,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: badge.icon != null
              ? ClipOval(
                  child: AppNetworkImage(
                    imageUrl: badge.icon!,
                    width: 48.r,
                    height: 48.r,
                    fit: BoxFit.cover,
                    errorWidget: Icon(
                      Icons.workspace_premium,
                      color: AppColors.primary,
                      size: 22.sp,
                    ),
                  ),
                )
              : Icon(
                  Icons.workspace_premium,
                  color: AppColors.primary,
                  size: 22.sp,
                ),
        ),
        SizedBox(height: 6.h),
        AppText.small(
          label: badge.name ?? '',
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.center,
          color: AppColors.black,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _ProfileMenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isLast;

  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isLast = false,
  });
}

class _ProfileMenu extends StatelessWidget {
  final List<_ProfileMenuItem> items;

  const _ProfileMenu({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.fieldColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: items
            .map(
              (item) => GestureDetector(
                onTap: item.onTap,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    border: item.isLast
                        ? null
                        : Border(
                            bottom: BorderSide(
                              color: AppColors.white,
                              width: 1.5.h,
                            ),
                          ),
                  ),
                  child: Row(
                    children: [
                      Icon(item.icon, color: AppColors.primary, size: 20.sp),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: AppText.medium(
                          label: item.label,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: AppColors.grey,
                        size: 20.sp,
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
