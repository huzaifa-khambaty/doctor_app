import '../../../../exports.dart';

/// Matches [QuizTabView]'s status card → daily challenge → topics grid →
/// peer leaderboard layout.
class QuizHomeSkeleton extends StatelessWidget {
  const QuizHomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSkeleton(width: double.infinity, height: 88.h, borderRadius: 20.r),

          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppSkeleton.textBar(width: 120.w, height: 15.h),
              AppSkeleton.textBar(width: 50.w, height: 15.h),
            ],
          ),
          SizedBox(height: 10.h),
          AppSkeleton(width: double.infinity, height: 170.h, borderRadius: 20.r),

          SizedBox(height: 24.h),
          AppSkeleton.textBar(width: 150.w, height: 15.h),
          SizedBox(height: 12.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 1.15,
            ),
            itemBuilder: (context, index) => Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.fieldColor, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSkeleton.circle(size: 36.r),
                  SizedBox(height: 10.h),
                  AppSkeleton.textBar(width: 70.w, height: 13.h),
                  SizedBox(height: 6.h),
                  AppSkeleton.textBar(width: 50.w, height: 10.h),
                ],
              ),
            ),
          ),

          SizedBox(height: 24.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.fieldColor,
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSkeleton.textBar(width: 130.w, height: 15.h),
                SizedBox(height: 12.h),
                for (var i = 0; i < 3; i++)
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: Row(
                      children: [
                        AppSkeleton.circle(size: 32.r),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: AppSkeleton.textBar(
                            width: double.infinity,
                            height: 12.h,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Matches [QuizPlayView]'s progress header → question card → answer
/// options → submit button layout.
class QuizPlaySkeleton extends StatelessWidget {
  const QuizPlaySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppSkeleton.textBar(width: 130.w, height: 11.h),
              AppSkeleton.textBar(width: 30.w, height: 11.h),
            ],
          ),
          SizedBox(height: 8.h),
          AppSkeleton(width: double.infinity, height: 6.h, borderRadius: 6.r),

          SizedBox(height: 20.h),
          AppSkeleton.textBar(width: double.infinity, height: 17.h),
          SizedBox(height: 8.h),
          AppSkeleton.textBar(width: 220.w, height: 17.h),

          SizedBox(height: 18.h),
          for (var i = 0; i < 4; i++)
            Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: AppSkeleton(
                width: double.infinity,
                height: 54.h,
                borderRadius: 14.r,
              ),
            ),

          SizedBox(height: 8.h),
          AppSkeleton(width: double.infinity, height: 50.h, borderRadius: 14.r),
        ],
      ),
    );
  }
}

/// Matches [QuizReviewView]'s stacked question-card list.
class QuizReviewSkeleton extends StatelessWidget {
  final int count;

  const QuizReviewSkeleton({super.key, this.count = 4});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      itemCount: count,
      separatorBuilder: (context, index) => SizedBox(height: 14.h),
      itemBuilder: (context, index) => Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: AppColors.fieldColor, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSkeleton.textBar(width: 90.w, height: 11.h),
            SizedBox(height: 10.h),
            AppSkeleton.textBar(width: double.infinity, height: 15.h),
            SizedBox(height: 6.h),
            AppSkeleton.textBar(width: 160.w, height: 15.h),
            SizedBox(height: 14.h),
            for (var i = 0; i < 3; i++)
              Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: AppSkeleton(
                  width: double.infinity,
                  height: 44.h,
                  borderRadius: 12.r,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Matches [QuizResultsView]'s title → score gauge → stat cards → streak
/// banner → CTA → reinforce section layout.
class QuizResultsSkeleton extends StatelessWidget {
  const QuizResultsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                AppSkeleton.textBar(width: 220.w, height: 22.h),
                SizedBox(height: 10.h),
                AppSkeleton.textBar(width: 260.w, height: 13.h),
              ],
            ),
          ),

          SizedBox(height: 24.h),
          Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 26.h),
              child: AppSkeleton.circle(size: 180.r),
            ),
          ),

          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: AppSkeleton(height: 62.h, borderRadius: 14.r),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: AppSkeleton(height: 62.h, borderRadius: 14.r),
              ),
            ],
          ),

          SizedBox(height: 16.h),
          AppSkeleton(width: double.infinity, height: 62.h, borderRadius: 14.r),

          SizedBox(height: 16.h),
          AppSkeleton(width: double.infinity, height: 50.h, borderRadius: 14.r),

          SizedBox(height: 24.h),
          AppSkeleton.textBar(width: 160.w, height: 15.h),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: AppSkeleton(height: 140.h, borderRadius: 16.r),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: AppSkeleton(height: 140.h, borderRadius: 16.r),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Matches [LeaderboardView]'s podium → rankings header → ranking rows
/// layout.
class QuizLeaderboardSkeleton extends StatelessWidget {
  final int rankingCount;

  const QuizLeaderboardSkeleton({super.key, this.rankingCount = 6});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _PodiumSkeleton(avatarSize: 72.r, barHeight: 100.h),
                SizedBox(width: 6.w),
                _PodiumSkeleton(avatarSize: 84.r, barHeight: 120.h),
                SizedBox(width: 6.w),
                _PodiumSkeleton(avatarSize: 72.r, barHeight: 80.h),
              ],
            ),
          ),

          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppSkeleton.textBar(width: 80.w, height: 15.h),
              AppSkeleton.textBar(width: 90.w, height: 13.h),
            ],
          ),

          SizedBox(height: 8.h),
          for (var i = 0; i < rankingCount; i++)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Row(
                children: [
                  SizedBox(width: 20.w, child: AppSkeleton.textBar(height: 13.h)),
                  SizedBox(width: 8.w),
                  AppSkeleton.circle(size: 40.r),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppSkeleton.textBar(width: 140.w, height: 13.h),
                        SizedBox(height: 6.h),
                        AppSkeleton.textBar(width: 90.w, height: 11.h),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  AppSkeleton.textBar(width: 30.w, height: 13.h),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _PodiumSkeleton extends StatelessWidget {
  final double avatarSize;
  final double barHeight;

  const _PodiumSkeleton({required this.avatarSize, required this.barHeight});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AppSkeleton.circle(size: avatarSize),
          SizedBox(height: 8.h),
          AppSkeleton(
            width: double.infinity,
            height: barHeight,
            borderRadius: 0,
          ),
          SizedBox(height: 8.h),
          AppSkeleton.textBar(width: avatarSize * 0.8, height: 12.h),
        ],
      ),
    );
  }
}
