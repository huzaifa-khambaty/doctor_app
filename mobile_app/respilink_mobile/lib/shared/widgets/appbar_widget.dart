import 'package:respilink_mobile/exports.dart';

class AppbarWidget extends AppBar {
  AppbarWidget({super.key, String? label, BuildContext? context})
    : super(
        title: AppText.medium(label: label ?? "", color: AppColors.white, fontWeight: FontWeight.bold),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: AppColors.white, size: 24.sp),
      );
}
