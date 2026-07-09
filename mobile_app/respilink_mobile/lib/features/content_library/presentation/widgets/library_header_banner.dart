import 'package:respilink_mobile/features/content_library/presentation/widgets/library_search_bar.dart';

import '../../../../exports.dart';

class LibraryHeaderBanner extends StatelessWidget {
  final ValueChanged<String>? onSearchChanged;

  const LibraryHeaderBanner({super.key, this.onSearchChanged});

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
          AppText.large(
            label: 'Medical Library',
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 19.sp,
          ),
          SizedBox(height: 6.h),
          AppText.small(
            label:
                'Access peer-reviewed pulmonary research and clinical guidelines updated daily.',
            color: AppColors.white.withValues(alpha: 0.9),
            fontSize: 12.sp,
          ),
          SizedBox(height: 14.h),
          LibrarySearchBar(onChanged: onSearchChanged),
        ],
      ),
    );
  }
}
