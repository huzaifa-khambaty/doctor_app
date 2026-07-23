import '../../../../exports.dart';

/// Matches [HomeTabView]'s hero banner -> up-next events -> daily challenge
/// -> latest updates layout so the loading state doesn't jump when the
/// `/home` response arrives.
class HomeContentSkeleton extends StatelessWidget {
  const HomeContentSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSkeleton(width: double.infinity, height: 150.h, borderRadius: 20.r),

        SizedBox(height: 24.h),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppSkeleton.textBar(width: 80.w, height: 15.h),
            AppSkeleton.textBar(width: 50.w, height: 12.h),
          ],
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 130.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2,
            separatorBuilder: (context, index) => SizedBox(width: 12.w),
            itemBuilder: (context, index) => AppSkeleton(
              width: 220.w,
              height: 130.h,
              borderRadius: 16.r,
            ),
          ),
        ),

        SizedBox(height: 24.h),

        AppSkeleton(width: double.infinity, height: 130.h, borderRadius: 18.r),

        SizedBox(height: 24.h),

        AppSkeleton.textBar(width: 110.w, height: 15.h),
        SizedBox(height: 12.h),
        for (var i = 0; i < 3; i++)
          Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSkeleton(width: 56.r, height: 56.r, borderRadius: 12.r),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSkeleton.textBar(width: 60.w, height: 10.h),
                      SizedBox(height: 6.h),
                      AppSkeleton.textBar(width: double.infinity, height: 13.h),
                      SizedBox(height: 6.h),
                      AppSkeleton.textBar(width: 80.w, height: 11.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
