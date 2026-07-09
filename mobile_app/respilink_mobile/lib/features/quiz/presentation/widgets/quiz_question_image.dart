import '../../../../exports.dart';

class QuizQuestionImage extends StatelessWidget {
  final String image;

  const QuizQuestionImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: AppNetworkImage(
        imageUrl: "${AppConstants.imagePath}$image",
        width: double.infinity,
        height: 160.h,
        fit: BoxFit.cover,
      ),
    );
  }
}
