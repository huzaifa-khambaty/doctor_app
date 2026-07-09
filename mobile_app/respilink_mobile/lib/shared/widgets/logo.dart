import 'package:respilink_mobile/exports.dart';

class Logo extends StatelessWidget {
  const Logo({super.key, this.size});

  final double? size;

  @override
  Widget build(BuildContext context) {
    return AppNetworkImage(
      imageUrl: "${AppConstants.imagePath}/fh_logo.png",
      height: size ?? 75.h,
    );
  }
}
