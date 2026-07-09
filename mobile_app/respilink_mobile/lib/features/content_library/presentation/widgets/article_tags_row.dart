import '../../../../exports.dart';

class ArticleTagsRow extends StatelessWidget {
  final List<String> tags;

  const ArticleTagsRow({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    return AppText.small(
      label: tags.map((tag) => '#$tag').join(' '),
      color: AppColors.primary,
      fontWeight: FontWeight.w600,
      fontSize: 12.sp,
    );
  }
}
