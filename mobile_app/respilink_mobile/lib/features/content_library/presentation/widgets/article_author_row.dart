import '../../../../exports.dart';

class ArticleAuthorRow extends StatelessWidget {
  final String authorName;
  final String? authorAvatarUrl;
  final String publishedLabel;

  const ArticleAuthorRow({
    super.key,
    required this.authorName,
    this.authorAvatarUrl,
    required this.publishedLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        authorAvatarUrl != null
            ? AppNetworkImage(
                imageUrl: authorAvatarUrl!,
                width: 34.r,
                height: 34.r,
                isCircle: true,
              )
            : CircleAvatar(
                radius: 17.r,
                backgroundColor: AppColors.fieldColor,
                child: Icon(Icons.person, color: AppColors.grey, size: 18.sp),
              ),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.medium(
              label: authorName,
              fontWeight: FontWeight.bold,
              fontSize: 13.sp,
            ),
            AppText.small(
              label: publishedLabel,
              color: AppColors.grey,
              fontSize: 11.sp,
            ),
          ],
        ),
      ],
    );
  }
}
