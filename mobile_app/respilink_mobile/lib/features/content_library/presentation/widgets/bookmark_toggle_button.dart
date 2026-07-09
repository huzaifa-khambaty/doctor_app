import '../../../../exports.dart';

class BookmarkToggleButton extends StatelessWidget {
  final bool isBookmarked;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? iconColor;

  const BookmarkToggleButton({
    super.key,
    required this.isBookmarked,
    this.onTap,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(6.r),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
          color: iconColor ?? AppColors.primary,
          size: 16.sp,
        ),
      ),
    );
  }
}
