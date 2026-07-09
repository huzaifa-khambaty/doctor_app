import '../../../../exports.dart';

class ArticleShareFab extends StatelessWidget {
  final VoidCallback? onTap;

  const ArticleShareFab({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onTap,
      heroTag: 'article_share_fab',
      shape: CircleBorder(),
      backgroundColor: AppColors.white,
      elevation: 2,
      child: Icon(Icons.share, color: AppColors.primary, size: 20.sp),
    );
  }
}
