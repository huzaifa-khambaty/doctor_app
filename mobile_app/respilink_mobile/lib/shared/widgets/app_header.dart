import '../../exports.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget? subtitleAction;
  final VoidCallback? onBack; // Simplified for the "Account" back style

  final String? page;
  const AppHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.subtitleAction,
    this.onBack,
    this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16.h,
        bottom: 18.h, // Increased bottom padding for the look in image_3a49f8.png
        left: 20.w,
        right: 20.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Top Row: Back button + Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onBack ?? () => locator<NavigationService>().pop(),
                child: Row(
                  children: [
                    Icon(Icons.chevron_left, color: Colors.white, size: 24.r),
                    AppText.medium(
                      label: page ?? "Account",
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
              if (actions != null) Row(children: actions!),
            ],
          ),

          SizedBox(height: 12.h),

          // 2. Title Section
          AppText.large(
            label: title,
            fontSize: 17.sp, // Slightly larger to match image_3a49f8.png
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),

          // 3. Subtitle Section
          if (subtitle != null) ...[
            SizedBox(height: 8.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: AppText.small(
                    label: subtitle!,
                    fontSize: 14.sp,
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                20.h.addHeight,
                ?subtitleAction,
              ],
            ),
          ],
        ],
      ),
    );
  }
}
