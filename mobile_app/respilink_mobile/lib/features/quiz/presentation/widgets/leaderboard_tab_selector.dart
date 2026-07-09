import 'package:respilink_mobile/features/quiz/domain/models/leaderboard_scope.dart';

import '../../../../exports.dart';

class LeaderboardTabSelector extends StatelessWidget {
  final TabController controller;

  const LeaderboardTabSelector({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      isScrollable: false,
      tabAlignment: .fill,
      dividerColor: Colors.transparent,
      indicatorColor: AppColors.primary,
      indicatorWeight: 2,
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.grey,
      labelStyle: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.bold,
        fontFamily: AppConstants.fontFamily,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
        fontFamily: AppConstants.fontFamily,
      ),
      tabs: LeaderboardScope.values
          .map((scope) => Tab(text: scope.label))
          .toList(),
    );
  }
}
