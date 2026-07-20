import '../../../../exports.dart';

/// Skeleton for a single [EventCard] — mirrors its banner + type/title +
/// meta-row layout so the loading state doesn't jump when data arrives.
class EventCardSkeleton extends StatelessWidget {
  const EventCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.fieldColor, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSkeleton(width: double.infinity, height: 130.h, borderRadius: 0),
          Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSkeleton.textBar(width: 60.w, height: 10.h),
                SizedBox(height: 8.h),
                AppSkeleton.textBar(width: 180.w, height: 15.h),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    AppSkeleton.textBar(width: 80.w, height: 11.h),
                    SizedBox(width: 12.w),
                    AppSkeleton.textBar(width: 60.w, height: 11.h),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Matches [EventsListView]'s "Upcoming Events" header + card list.
class EventsListSkeleton extends StatelessWidget {
  final int count;

  const EventsListSkeleton({super.key, this.count = 4});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: count + 1,
      separatorBuilder: (context, index) => SizedBox(height: 14.h),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: AppSkeleton.textBar(width: 140.w, height: 15.h),
          );
        }
        return const EventCardSkeleton();
      },
    );
  }
}

/// Matches the shared banner → title → host row → info grid → description
/// layout used by [WorkshopDetailView]/[WebinarDetailView].
class EventDetailSkeleton extends StatelessWidget {
  final bool showHostRow;
  final bool showChecklist;

  const EventDetailSkeleton({
    super.key,
    this.showHostRow = true,
    this.showChecklist = true,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSkeleton(width: double.infinity, height: 190.h, borderRadius: 0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSkeleton.textBar(width: 220.w, height: 19.h),
                if (showHostRow) ...[
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      AppSkeleton.circle(size: 40.r),
                      SizedBox(width: 10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppSkeleton.textBar(width: 120.w, height: 14.h),
                          SizedBox(height: 6.h),
                          AppSkeleton.textBar(width: 90.w, height: 12.h),
                        ],
                      ),
                    ],
                  ),
                ],
                SizedBox(height: 18.h),
                const _InfoGridSkeleton(),
                SizedBox(height: 22.h),
                AppSkeleton.textBar(width: 100.w, height: 15.h),
                SizedBox(height: 10.h),
                AppSkeleton.textBar(width: double.infinity, height: 12.h),
                SizedBox(height: 8.h),
                AppSkeleton.textBar(width: double.infinity, height: 12.h),
                SizedBox(height: 8.h),
                AppSkeleton.textBar(width: 220.w, height: 12.h),
                if (showChecklist) ...[
                  SizedBox(height: 22.h),
                  AppSkeleton.textBar(width: 130.w, height: 15.h),
                  SizedBox(height: 12.h),
                  for (var i = 0; i < 3; i++)
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: Row(
                        children: [
                          AppSkeleton.circle(size: 16.r),
                          SizedBox(width: 8.w),
                          AppSkeleton.textBar(width: 200.w, height: 12.h),
                        ],
                      ),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Matches [ConferenceDetailView]'s banner+badge → title → info grid →
/// speakers row → agenda list layout.
class ConferenceDetailSkeleton extends StatelessWidget {
  const ConferenceDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AppSkeleton(
                width: double.infinity,
                height: 190.h,
                borderRadius: 0,
              ),
              Positioned(
                left: 14.w,
                bottom: 14.h,
                child: AppSkeleton(width: 70.w, height: 22.h, borderRadius: 8.r),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSkeleton.textBar(width: 220.w, height: 19.h),
                SizedBox(height: 16.h),
                const _InfoGridSkeleton(),
                SizedBox(height: 24.h),
                AppSkeleton.textBar(width: 150.w, height: 15.h),
                SizedBox(height: 14.h),
                Row(
                  children: List.generate(
                    4,
                    (i) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: i == 3 ? 0 : 10.w),
                        child: Column(
                          children: [
                            AppSkeleton.circle(size: 48.r),
                            SizedBox(height: 6.h),
                            AppSkeleton.textBar(width: 40.w, height: 10.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                AppSkeleton.textBar(width: 120.w, height: 15.h),
                SizedBox(height: 12.h),
                for (var i = 0; i < 3; i++)
                  Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: AppSkeleton(
                      width: double.infinity,
                      height: 56.h,
                      borderRadius: 12.r,
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

class _InfoGridSkeleton extends StatelessWidget {
  const _InfoGridSkeleton();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 2,
      ),
      itemBuilder: (context, index) => Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: AppColors.fieldColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSkeleton.textBar(width: 60.w, height: 9.h),
            SizedBox(height: 6.h),
            AppSkeleton.textBar(width: 80.w, height: 12.h),
          ],
        ),
      ),
    );
  }
}
