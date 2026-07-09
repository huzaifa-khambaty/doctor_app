import '../../../../exports.dart';

class ArticleEngagementBar extends StatelessWidget {
  final String likeCount;
  final String commentCount;
  final bool isLiked;
  final VoidCallback? onLikeTap;
  final VoidCallback? onCommentTap;
  final VoidCallback? onSaveTap;

  const ArticleEngagementBar({
    super.key,
    required this.likeCount,
    required this.commentCount,
    this.isLiked = false,
    this.onLikeTap,
    this.onCommentTap,
    this.onSaveTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onLikeTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                color: AppColors.primary,
                size: 16.sp,
              ),
              SizedBox(width: 4.w),
              AppText.small(
                label: likeCount,
                color: AppColors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
              ),
            ],
          ),
        ),
        SizedBox(width: 18.w),
        GestureDetector(
          onTap: onCommentTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.mode_comment_outlined, color: AppColors.grey, size: 16.sp),
              SizedBox(width: 4.w),
              AppText.small(
                label: commentCount,
                color: AppColors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
              ),
            ],
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onSaveTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_circle_outline, color: AppColors.primary, size: 16.sp),
              SizedBox(width: 4.w),
              AppText.small(
                label: 'Save to Collection',
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
