import '../../../../exports.dart';

class DayTabSelector extends StatelessWidget {
  final TabController controller;
  final List<String> days;

  const DayTabSelector({
    super.key,
    required this.controller,
    required this.days,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      isScrollable: false,
      tabAlignment: TabAlignment.fill,
      dividerColor: Colors.transparent,
      indicatorColor: AppColors.primary,
      indicatorWeight: 2,
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.grey,
      labelPadding: EdgeInsets.only(right: 24.w),
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
      tabs: days.map((day) => Tab(text: day)).toList(),
    );
  }
}
