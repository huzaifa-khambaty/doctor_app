import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:respilink_mobile/core/constants/app_constants.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/podium_widget.dart';

class MedicalLeaderboardWidget extends StatelessWidget {
  const MedicalLeaderboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 2nd Place - Left
          PodiumItemWidget(
            rank: 2,
            name: 'Dr. Aris V.',
            points: '9.4k',
            imageUrl: "${AppConstants.imagePath}doctor.jpg",
            podiumHeight: 100,
            gradientColors: [Color(0xFFB0BCC6), Color(0xFFE2E8F0)],
          ),
          SizedBox(width: 6.w),

          // 1st Place - Center (Taller and featured)
          PodiumItemWidget(
            rank: 1,
            name: 'Dr. Elena K.',
            points: '12.2k',
            imageUrl: "${AppConstants.imagePath}doctor.jpg",
            podiumHeight: 120,
            gradientColors: [Color(0xFFFFAE34), Color(0xFFFFF4DF)],
            isFirstPlace: true,
          ),
          SizedBox(width: 6.w),

          // 3rd Place - Right
          PodiumItemWidget(
            rank: 3,
            name: 'Dr. Marcus L.',
            points: '8.9k',
            imageUrl: "${AppConstants.imagePath}doctor.jpg",
            podiumHeight: 80,
            gradientColors: [Color(0xFFC6926F), Color(0xFFF5EBE6)],
          ),
        ],
      ),
    );
  }
}
