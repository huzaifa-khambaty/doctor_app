import '../../../../exports.dart';

class LibrarySearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final String hintText;

  const LibrarySearchBar({
    super.key,
    this.onChanged,
    this.hintText = 'Search conditions, trials, or drugs...',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: AppColors.fieldColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: AppColors.grey, size: 20.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              style: TextStyle(
                fontSize: 13.sp,
                fontFamily: AppConstants.fontFamily,
                color: AppColors.black,
              ),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                hintText: hintText,
                hintStyle: TextStyle(
                  fontSize: 13.sp,
                  fontFamily: AppConstants.fontFamily,
                  color: AppColors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
