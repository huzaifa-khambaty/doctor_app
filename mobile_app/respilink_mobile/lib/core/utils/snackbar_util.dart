import '../../../exports.dart';

class SnackbarUtil {
  SnackbarUtil._();

  static void showSnackbar({required String message, bool isError = false}) {
    final context = locator<NavigationService>().navigationKey.currentContext;

    if (context == null) return;

    ScaffoldMessenger.of(
      context,
    ).hideCurrentSnackBar(); // Remove existing ones first
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError
            ? AppColors.primary
            : AppColors.redBA1A1A,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        content: AppText.small(
          label: message,
          color: AppColors.white,
          fontWeight: FontWeight.w600,
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
