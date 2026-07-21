import '../../../../exports.dart';

class ArticleBookmarkFab extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isBookmarked;

  const ArticleBookmarkFab({
    super.key,
    this.onTap,
    this.isBookmarked = false,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onTap,
      heroTag: 'article_bookmark_fab',
      shape: CircleBorder(),
      backgroundColor: AppColors.primary,
      elevation: 2,
      child: Icon(
        isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
        color: AppColors.white,
        size: 20.sp,
      ),
    );
  }
}
