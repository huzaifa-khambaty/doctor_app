import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/core/network/api_endpoints.dart';
import 'package:respilink_mobile/features/auth/presentation/bloc/badges_bloc.dart';
import 'package:respilink_mobile/features/auth/presentation/bloc/badges_event.dart';
import 'package:respilink_mobile/features/auth/presentation/bloc/badges_state.dart';
import 'package:respilink_mobile/features/dashboard/data/model/badge_model.dart';
import 'package:respilink_mobile/shared/widgets/app_notification_bell.dart';
import 'package:respilink_mobile/shared/widgets/request_failed.dart';

import '../../../../exports.dart';

class BadgesView extends StatefulWidget {
  const BadgesView({super.key});

  @override
  State<BadgesView> createState() => _BadgesViewState();
}

class _BadgesViewState extends State<BadgesView> {
  @override
  void initState() {
    super.initState();
    context.read<BadgesBloc>().add(BadgesRequested());
  }

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
        child: BlocBuilder<BadgesBloc, BadgesState>(
          builder: (context, state) {
            if (state is BadgesFailed) {
              return RequestFailed(message: state.message);
            }

            if (state is! BadgesLoaded) {
              return AppSkeleton.cardList();
            }

            return _BadgesBody(badges: state.badges);
          },
        ),
      ),
    );
  }
}

class _BadgesBody extends StatelessWidget {
  final BadgeModel badges;

  const _BadgesBody({required this.badges});

  @override
  Widget build(BuildContext context) {
    final categories = badges.categories ?? [];
    final totalEarned = badges.earnedBadges ?? 0;
    final totalBadges = badges.totalAvailable ?? 0;

    // No explicit "next milestone" field from the API — the next unearned
    // badge (in category order) is the closest equivalent.
    final nextMilestone = categories
        .expand((c) => c.badges ?? const [])
        .firstWhere((b) => b.earned != true, orElse: () => Badges())
        .name;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MilestonesCard(
            totalEarned: totalEarned,
            totalBadges: totalBadges,
            nextMilestone: nextMilestone,
          ),
          SizedBox(height: 24.h),
          for (final category in categories) ...[
            _CategorySection(category: category),
            SizedBox(height: 22.h),
          ],
        ],
      ),
    );
  }
}

class _MilestonesCard extends StatelessWidget {
  final int totalEarned;
  final int totalBadges;
  final String? nextMilestone;

  const _MilestonesCard({
    required this.totalEarned,
    required this.totalBadges,
    this.nextMilestone,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalBadges == 0
        ? 0.0
        : (totalEarned / totalBadges).clamp(0.0, 1.0);

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
              if (nextMilestone != null && nextMilestone!.isNotEmpty)
                Expanded(
                  child: AppText.small(
                    label: 'Next: $nextMilestone',
                    color: AppColors.white.withValues(alpha: 0.85),
                    fontSize: 11.sp,
                    overflow: TextOverflow.ellipsis,
                  ),
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
  final Categories category;

  const _CategorySection({required this.category});

  @override
  Widget build(BuildContext context) {
    final items = category.badges ?? [];
    final earned =
        category.earned ?? items.where((b) => b.earned == true).length;
    final total = category.total ?? items.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText.medium(
              label: category.name ?? '',
              fontWeight: FontWeight.bold,
              fontSize: 15.sp,
            ),
            AppText.small(
              label: '$earned/$total Earned',
              color: AppColors.grey,
              fontSize: 11.sp,
            ),
          ],
        ),
        SizedBox(height: 12.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 1.4,
          ),
          itemBuilder: (context, index) {
            return _BadgeTile(badge: items[index]);
          },
        ),
      ],
    );
  }
}

class _BadgeTile extends StatelessWidget {
  final Badges badge;

  const _BadgeTile({required this.badge});

  @override
  Widget build(BuildContext context) {
    final earned = badge.earned ?? false;
    print("${ApiEndpoints.imageUrl}${badge.icon}");

    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: earned ? AppColors.white : AppColors.fieldColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: earned ? AppColors.fieldColor : Colors.transparent,
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
                  color: AppColors.grey.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Opacity(
                  opacity: earned ? 1 : 0.4,
                  child: ClipOval(
                    child: AppNetworkImage(
                      imageUrl: "${ApiEndpoints.imageUrl}${badge.icon}",
                      width: 44.r,
                      height: 44.r,
                      fit: BoxFit.cover,
                      errorWidget: Icon(
                        Icons.military_tech,
                        color: AppColors.grey,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ),
              ),
              if (!earned)
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
            label: badge.name ?? '',
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
            color: earned ? AppColors.black : AppColors.grey,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
