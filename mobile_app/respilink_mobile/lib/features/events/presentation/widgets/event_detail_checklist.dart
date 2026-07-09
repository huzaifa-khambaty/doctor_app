import '../../../../exports.dart';

class EventDetailChecklist extends StatelessWidget {
  final String title;
  final List<String> items;

  const EventDetailChecklist({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.medium(
          label: title,
          fontWeight: FontWeight.bold,
          fontSize: 15.sp,
        ),
        SizedBox(height: 10.h),
        ...items.map(
          (item) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                  size: 16.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: AppText.small(
                    label: item,
                    color: AppColors.black,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
