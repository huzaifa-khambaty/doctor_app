import '../../../../exports.dart';

class ArticleHeadingBlock extends StatelessWidget {
  final String text;

  const ArticleHeadingBlock({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return AppText.medium(
      label: text,
      fontWeight: FontWeight.bold,
      fontSize: 16.sp,
    );
  }
}
