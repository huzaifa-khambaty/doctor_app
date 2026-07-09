import '../../../../exports.dart';

class ArticleHeaderImage extends StatelessWidget {
  final String image;

  const ArticleHeaderImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: AppNetworkImage(
        imageUrl: "${AppConstants.imagePath}$image",
        width: double.infinity,
        height: 180.h,
        fit: BoxFit.cover,
      ),
    );
  }
}
