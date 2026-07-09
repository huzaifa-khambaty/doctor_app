import 'package:flutter/material.dart';
import 'package:respilink_app/core/theme/app_colors.dart';

class SnackbarUtil {
  SnackbarUtil._();

  static void showSnackbar(BuildContext context, {required String message, bool isError = false}) {
    ScaffoldMessenger.of(
      context,
    ).hideCurrentSnackBar(); // Remove existing ones first
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError
            ? AppColors.errorRed
            : AppColors.primary, // Use primary color for success, errorRed for errors
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
