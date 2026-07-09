import '../../../../exports.dart';

class ArticleTitle extends StatelessWidget {
  final String title;

  const ArticleTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppText.large(
      label: title,
      fontWeight: FontWeight.bold,
      fontSize: 20.sp,
    );
  }
}
