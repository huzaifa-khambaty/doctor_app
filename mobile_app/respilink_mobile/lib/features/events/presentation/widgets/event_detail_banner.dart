import '../../../../exports.dart';

class EventDetailBanner extends StatelessWidget {
  final String image;

  const EventDetailBanner({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return AppNetworkImage(
      imageUrl: image.startsWith('http')
          ? image
          : "${AppConstants.imagePath}$image",
      width: double.infinity,
      height: 190.h,
      fit: BoxFit.cover,
    );
  }
}
