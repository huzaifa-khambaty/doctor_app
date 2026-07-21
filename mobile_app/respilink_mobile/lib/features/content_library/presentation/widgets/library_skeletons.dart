import '../../../../exports.dart';

/// Matches the mixed [MediaLibraryCard]/[DocumentLibraryCard] list in
/// [LibraryView] so the loading state doesn't jump when data arrives.
class LibraryResultsSkeleton extends StatelessWidget {
  const LibraryResultsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: 4,
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
      itemBuilder: (context, index) => index.isEven
          ? const _MediaCardSkeleton()
          : const _DocumentCardSkeleton(),
    );
  }
}

class _MediaCardSkeleton extends StatelessWidget {
  const _MediaCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.fieldColor, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSkeleton(width: double.infinity, height: 140.h, borderRadius: 0),
          Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSkeleton.textBar(width: 60.w, height: 10.h),
                SizedBox(height: 8.h),
                AppSkeleton.textBar(width: 180.w, height: 15.h),
                SizedBox(height: 10.h),
                AppSkeleton.textBar(width: 100.w, height: 11.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DocumentCardSkeleton extends StatelessWidget {
  const _DocumentCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.fieldColor, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSkeleton(width: 64.w, height: 64.w, borderRadius: 12.r),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSkeleton.textBar(width: 70.w, height: 10.h),
                SizedBox(height: 8.h),
                AppSkeleton.textBar(width: 60.w, height: 10.h),
                SizedBox(height: 6.h),
                AppSkeleton.textBar(width: double.infinity, height: 13.h),
                SizedBox(height: 8.h),
                AppSkeleton.textBar(width: 140.w, height: 11.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Matches [ArticleReaderView]'s header image → tag → title → author →
/// body → tags → engagement-bar layout.
class ArticleReaderSkeleton extends StatelessWidget {
  const ArticleReaderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSkeleton(width: double.infinity, height: 180.h, borderRadius: 16.r),
          SizedBox(height: 16.h),
          Row(
            children: [
              AppSkeleton(width: 90.w, height: 20.h, borderRadius: 6.r),
              SizedBox(width: 8.w),
              AppSkeleton.textBar(width: 70.w, height: 11.h),
            ],
          ),
          SizedBox(height: 10.h),
          AppSkeleton.textBar(width: double.infinity, height: 20.h),
          SizedBox(height: 8.h),
          AppSkeleton.textBar(width: 220.w, height: 20.h),
          SizedBox(height: 14.h),
          Row(
            children: [
              AppSkeleton.circle(size: 34.r),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSkeleton.textBar(width: 120.w, height: 13.h),
                  SizedBox(height: 6.h),
                  AppSkeleton.textBar(width: 90.w, height: 11.h),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.h),
          for (var i = 0; i < 5; i++)
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: AppSkeleton.textBar(width: double.infinity, height: 12.h),
            ),
          SizedBox(height: 8.h),
          Row(
            children: [
              for (var i = 0; i < 3; i++)
                Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: AppSkeleton(width: 60.w, height: 26.h, borderRadius: 999.r),
                ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              AppSkeleton.textBar(width: 40.w, height: 14.h),
              SizedBox(width: 18.w),
              AppSkeleton.textBar(width: 40.w, height: 14.h),
              const Spacer(),
              AppSkeleton.textBar(width: 100.w, height: 14.h),
            ],
          ),
        ],
      ),
    );
  }
}
