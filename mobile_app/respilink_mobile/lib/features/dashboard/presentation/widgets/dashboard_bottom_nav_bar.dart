import 'package:respilink_mobile/features/dashboard/domain/models/dashboard_nav_item_model.dart';

import '../../../../exports.dart';

class DashboardBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const DashboardBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            dashboardNavItems.length,
            (index) => _NavBarItem(
              item: dashboardNavItems[index],
              isActive: index == currentIndex,
              onTap: () => onTap(index),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final DashboardNavItemModel item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.white : AppColors.grey;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            item.svgIcon != null
                ? AppNetworkImage(
                    imageUrl: "${AppConstants.svgPath}${item.svgIcon}",
                    width: 20.r,
                    height: 20.r,
                    color: color,
                  )
                : Icon(item.icon, size: 20.r, color: color),
            SizedBox(height: 4.h),
            AppText.small(label: item.label, color: color, fontSize: 10.sp),
          ],
        ),
      ),
    );
  }
}
