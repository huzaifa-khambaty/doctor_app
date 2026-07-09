import 'package:shimmer/shimmer.dart';
import 'package:respilink_mobile/exports.dart';

class AppSkeleton extends StatelessWidget {
  final double? width;
  final double? height;
  final double? borderRadius;
  final BoxShape shape;

  const AppSkeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
  });

  const AppSkeleton.circle({super.key, required double size})
    : width = size,
      height = size,
      borderRadius = null,
      shape = BoxShape.circle;

  const AppSkeleton.textBar({super.key, double? width, double height = 14})
    : width = width,
      height = height,
      borderRadius = 4,
      shape = BoxShape.rectangle;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: shape,
          borderRadius: shape == BoxShape.rectangle
              ? BorderRadius.circular(borderRadius ?? 8.r)
              : null,
        ),
      ),
    );
  }

  /// A generic list item skeleton
  static Widget listItem({int count = 6, double? height}) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      itemCount: count,
      separatorBuilder: (context, index) => 12.h.addHeight,
      itemBuilder: (context, index) => Row(
        children: [
          AppSkeleton.circle(size: 50.r),
          12.w.addWidth,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSkeleton.textBar(width: 150.w),
                8.h.addHeight,
                AppSkeleton.textBar(width: 100.w),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// A row of pills/chips skeleton
  static Widget pillRow({int count = 3}) {
    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children: List.generate(
        count,
        (index) => AppSkeleton(
          width: 80.w + (index * 10.w),
          height: 35.h,
          borderRadius: 999.r,
        ),
      ),
    );
  }

  /// A generic choice group skeleton (Label + Pills)
  static Widget choiceGroup({int count = 3}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSkeleton.textBar(width: 120.w, height: 16.h),
        12.h.addHeight,
        pillRow(count: count),
      ],
    );
  }

  /// A generic grid/card skeleton
  static Widget cardList({int count = 4}) {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      itemCount: count,
      separatorBuilder: (context, index) => 15.h.addHeight,
      itemBuilder: (context, index) => Container(
        height: 100.h,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            AppSkeleton(width: 80.w, height: 80.h, borderRadius: 12.r),
            15.w.addWidth,
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSkeleton.textBar(width: double.infinity),
                  10.h.addHeight,
                  AppSkeleton.textBar(width: 150.w),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Folder card skeleton that matches the document folder card layout.
  static Widget folderItem({int count = 4, double? height}) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      itemCount: count,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14.w,
        mainAxisSpacing: 14.h,
        childAspectRatio: 1.35,
      ),
      itemBuilder: (context, index) => const _FolderCardSkeleton(),
       //separatorBuilder: (context, index) => 7.h.addHeight,
    );
  }
}

class _FolderCardSkeleton extends StatelessWidget {
  const _FolderCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12.r),
        border: Border(
          left: BorderSide(color: Colors.grey.shade100, width: 4.w),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(6.r),
            decoration:  BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: AppSkeleton.circle(size: 20.r),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              5.h.addHeight,
              AppSkeleton.textBar(width: 90.w, height: 15.h),
              SizedBox(height: 4.h),
              AppSkeleton.textBar(width: 70.w, height: 11.h),
            ],
          ),
        ],
      ),
    );
  }
}
