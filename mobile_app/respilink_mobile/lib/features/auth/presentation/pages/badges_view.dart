import 'package:respilink_mobile/shared/widgets/app_notification_bell.dart';

import '../../../../exports.dart';

class _BadgeItem {
  final IconData icon;
  final String label;
  final Color color;
  final bool earned;

  const _BadgeItem({
    required this.icon,
    required this.label,
    required this.color,
    this.earned = true,
  });
}

class _BadgeCategory {
  final String title;
  final List<_BadgeItem> badges;

  const _BadgeCategory({required this.title, required this.badges});

  int get earnedCount => badges.where((b) => b.earned).length;
  int get totalCount => badges.length;
}

// TODO: replace with real data from the backend once the badges API is wired up.
const _totalEarned = 8;
const _totalBadges = 20;
const _nextMilestone = 'Master Clinician';
const _nextMilestoneProgress = 0.4;

final _categories = [
  _BadgeCategory(
    title: 'Engagement',
    badges: [
      const _BadgeItem(icon: Icons.workspace_premium, label: 'Top Contributor', color: AppColors.yellow),
      const _BadgeItem(icon: Icons.local_fire_department, label: 'Daily Streak', color: AppColors.primary),
      _BadgeItem(icon: Icons.groups, label: 'Community Leader', color: AppColors.grey, earned: false),
    ],
  ),
  _BadgeCategory(
    title: 'Learning',
    badges: [
      const _BadgeItem(icon: Icons.menu_book, label: 'Librarian', color: AppColors.primary),
      _BadgeItem(icon: Icons.psychology, label: 'Research Guru', color: AppColors.grey, earned: false),
    ],
  ),
  _BadgeCategory(
    title: 'Quiz Mastery',
    badges: [
      const _BadgeItem(icon: Icons.star, label: 'Perfect Score', color: AppColors.purpleAccent),
      const _BadgeItem(icon: Icons.bolt, label: 'Fast Learner', color: AppColors.purpleAccent),
      _BadgeItem(icon: Icons.emoji_events, label: 'Expert', color: AppColors.grey, earned: false),
    ],
  ),
];

class BadgesView extends StatelessWidget {
  const BadgesView({super.key});

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 18.sp, color: AppColors.black),
          onPressed: () => locator<NavigationService>().pop(),
        ),
        title: AppText.medium(
          label: 'Badges',
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
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _MilestonesCard(
                totalEarned: _totalEarned,
                totalBadges: _totalBadges,
                nextMilestone: _nextMilestone,
                progress: _nextMilestoneProgress,
              ),
              SizedBox(height: 24.h),
              for (final category in _categories) ...[
                _CategorySection(category: category),
                SizedBox(height: 22.h),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MilestonesCard extends StatelessWidget {
  final int totalEarned;
  final int totalBadges;
  final String nextMilestone;
  final double progress;

  const _MilestonesCard({
    required this.totalEarned,
    required this.totalBadges,
    required this.nextMilestone,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.tealGradientStart, AppColors.deeperTeal],
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.small(
            label: 'PROFILE MILESTONES',
            color: AppColors.white.withValues(alpha: 0.8),
            fontWeight: FontWeight.w600,
            fontSize: 10.sp,
          ),
          SizedBox(height: 8.h),
          AppText.large(
            label: 'Total Badges: $totalEarned/$totalBadges',
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
          SizedBox(height: 16.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8.h,
              backgroundColor: AppColors.white.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation(AppColors.yellow),
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.small(
                label: 'Next: $nextMilestone',
                color: AppColors.white.withValues(alpha: 0.85),
                fontSize: 11.sp,
              ),
              AppText.small(
                label: '${(progress * 100).round()}% Complete',
                color: AppColors.white.withValues(alpha: 0.85),
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  final _BadgeCategory category;

  const _CategorySection({required this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText.medium(
              label: category.title,
              fontWeight: FontWeight.bold,
              fontSize: 15.sp,
            ),
            AppText.small(
              label: '${category.earnedCount}/${category.totalCount} Earned',
              color: AppColors.grey,
              fontSize: 11.sp,
            ),
          ],
        ),
        SizedBox(height: 12.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: category.badges.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 1.4,
          ),
          itemBuilder: (context, index) =>
              _BadgeTile(badge: category.badges[index]),
        ),
      ],
    );
  }
}

class _BadgeTile extends StatelessWidget {
  final _BadgeItem badge;

  const _BadgeTile({required this.badge});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: badge.earned ? AppColors.white : AppColors.fieldColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: badge.earned ? AppColors.fieldColor : Colors.transparent,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: badge.earned
                      ? badge.color.withValues(alpha: 0.12)
                      : AppColors.grey.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  badge.icon,
                  color: badge.earned ? badge.color : AppColors.grey,
                  size: 20.sp,
                ),
              ),
              if (!badge.earned)
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    padding: EdgeInsets.all(3.r),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.fieldColor, width: 1),
                    ),
                    child: Icon(
                      Icons.lock_outline,
                      color: AppColors.grey,
                      size: 10.sp,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8.h),
          AppText.small(
            label: badge.label,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
            color: badge.earned ? AppColors.black : AppColors.grey,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
