import '../../../../exports.dart';

class ArticleParagraphBlock extends StatelessWidget {
  final String text;
  final String? highlightPhrase;

  const ArticleParagraphBlock({
    super.key,
    required this.text,
    this.highlightPhrase,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = TextStyle(
      fontSize: 13.sp,
      color: AppColors.black,
      fontFamily: AppConstants.fontFamily,
      height: 1.6,
    );

    if (highlightPhrase == null || !text.contains(highlightPhrase!)) {
      return Text(text, style: baseStyle);
    }

    final parts = text.split(highlightPhrase!);
    return RichText(
      text: TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: parts.first),
          TextSpan(
            text: highlightPhrase,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              fontFamily: AppConstants.fontFamily,
            ),
          ),
          if (parts.length > 1) TextSpan(text: parts.sublist(1).join(highlightPhrase!)),
        ],
      ),
    );
  }
}
