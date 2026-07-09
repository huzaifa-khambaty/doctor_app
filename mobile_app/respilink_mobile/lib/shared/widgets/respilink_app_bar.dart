import 'app_notification_bell.dart';
import '../../exports.dart';

/// Shared white app bar (back + brand/title + notification bell) reused by
/// feature screens that sit under the dashboard shell (Quiz, Events, ...).
class RespiLinkAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showSearchAction;
  final VoidCallback? onSearchTap;

  const RespiLinkAppBar({
    super.key,
    this.title = 'RespiLink',
    this.showBackButton = true,
    this.showSearchAction = false,
    this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: 18.sp,
                color: AppColors.black,
              ),
              onPressed: () => locator<NavigationService>().pop(),
            )
          : null,
      title: AppText.large(
        label: title,
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
      actions: [
        if (showSearchAction)
          IconButton(
            icon: Icon(Icons.search, size: 22.sp, color: AppColors.black),
            onPressed: onSearchTap,
          ),
        Padding(
          padding: EdgeInsets.only(right: 16.w),
          child: AppNotificationBell(color: AppColors.black),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
