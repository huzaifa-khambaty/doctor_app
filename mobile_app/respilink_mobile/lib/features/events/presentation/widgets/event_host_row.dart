import '../../../../exports.dart';

class EventHostRow extends StatelessWidget {
  final String name;
  final String title;
  final String? avatarUrl;

  const EventHostRow({
    super.key,
    required this.name,
    required this.title,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        avatarUrl != null
            ? AppNetworkImage(
                imageUrl: avatarUrl!,
                width: 40.r,
                height: 40.r,
                isCircle: true,
              )
            : CircleAvatar(
                radius: 20.r,
                backgroundColor: AppColors.fieldColor,
                child: Icon(Icons.person, color: AppColors.grey, size: 22.sp),
              ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.medium(
                label: name,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
              AppText.small(
                label: title,
                color: AppColors.grey,
                fontSize: 12.sp,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
