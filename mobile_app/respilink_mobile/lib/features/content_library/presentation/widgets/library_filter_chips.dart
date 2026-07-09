import 'package:respilink_mobile/features/content_library/domain/models/library_filter.dart';

import '../../../../exports.dart';

class LibraryFilterChips extends StatelessWidget {
  final LibraryFilter selected;
  final ValueChanged<LibraryFilter> onSelected;

  const LibraryFilterChips({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: LibraryFilter.values.length,
        separatorBuilder: (context, index) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final filter = LibraryFilter.values[index];
          final isActive = filter == selected;

          return GestureDetector(
            onTap: () => onSelected(filter),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.fieldColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: AppText.small(
                label: filter.label,
                color: isActive ? AppColors.white : AppColors.black,
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
              ),
            ),
          );
        },
      ),
    );
  }
}
