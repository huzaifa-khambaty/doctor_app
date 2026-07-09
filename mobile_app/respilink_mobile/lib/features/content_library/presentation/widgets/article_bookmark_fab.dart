import '../../../../exports.dart';

class ArticleBookmarkFab extends StatelessWidget {
  final VoidCallback? onTap;

  const ArticleBookmarkFab({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onTap,
      heroTag: 'article_bookmark_fab',
      shape: CircleBorder(),
      backgroundColor: AppColors.primary,
      elevation: 2,
      child: Icon(Icons.bookmark_outline, color: AppColors.white, size: 20.sp),
    );
  }
}
