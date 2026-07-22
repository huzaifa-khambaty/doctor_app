import 'package:respilink_mobile/core/network/api_endpoints.dart';
import 'package:respilink_mobile/core/utils/global_notifiers.dart';
import 'package:respilink_mobile/features/auth/domain/models/user_model.dart';
import 'package:respilink_mobile/shared/widgets/app_notification_bell.dart';

import '../../../../exports.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Doctor?>(
      valueListenable: GlobalNotifiers.userNotifier,
      builder: (context, user, child) {
        return Row(
          children: [
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(12.r),
                onTap: () =>
                    locator<NavigationService>().navigate(RouterStrings.profileView),
                child: Row(
                  children: [
                    user?.profilePhotoPath != null
                        ? AppNetworkImage(
                            imageUrl:
                                "${ApiEndpoints.imageUrl}/${user!.profilePhotoPath}",
                            width: 40.r,
                            height: 40.r,
                            isCircle: true,
                          )
                        : CircleAvatar(
                            radius: 20.r,
                            backgroundColor: AppColors.fieldColor,
                            child: Icon(
                              Icons.person,
                              color: AppColors.grey,
                              size: 22.sp,
                            ),
                          ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.small(
                            label: 'Welcome back,',
                            color: AppColors.grey,
                            fontSize: 11.sp,
                          ),
                          AppText.medium(
                            label: user?.fullName ?? 'Doctor',
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const AppNotificationBell(),
          ],
        );
      },
    );
  }
}
