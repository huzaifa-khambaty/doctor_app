import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/core/theme/theme_cubit.dart';
import 'package:respilink_mobile/exports.dart';
import 'package:respilink_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:respilink_mobile/features/auth/presentation/bloc/auth_state.dart';
import 'package:respilink_mobile/features/onboarding/data/onboarding_local_manager.dart';
import 'package:respilink_mobile/services/pusher_service.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  Future<void> _goToOnboardingOrLogin() async {
    final hasSeenOnboarding = await locator<OnboardingLocalManager>()
        .hasSeenOnboarding();
    locator<NavigationService>().navigateAndRemove(
      hasSeenOnboarding ? RouterStrings.login : RouterStrings.onboarding,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return BlocListener<AuthBloc, AuthState>(
          listener: (context, state) async {
            await Future.delayed(Duration(seconds: 2));
            if (state is Authenticated) {
              // AppConstants.apiToken and GlobalNotifiers.userNotifier are
              // already populated by AuthRepositoryImpl.isUserLoggedIn().
              await locator<PusherService>().initPusher();
              locator<NavigationService>().navigateAndRemove(
                RouterStrings.dashboard,
              );
            } else if (state is Unauthenticated) {
              await _goToOnboardingOrLogin();
            }
          },
          child: Scaffold(
            body: Container(
              width: double.infinity,
              height: double.infinity,
              color: AppColors.white,
              // decoration: BoxDecoration(
              //   gradient: LinearGradient(
              //     begin: Alignment.topLeft,
              //     end: Alignment.bottomRight,
              //     colors: [
              //       AppColors.tealGradientStart,
              //       AppColors.tealGradientStart,
              //     ],
              //   ),
              // ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppNetworkImage(
                      imageUrl: "${AppConstants.imagePath}launcher.png",
                      width: 100.r,
                      height: 100.r,
                    ),
                    SizedBox(height: 20.h),
                    AppText.large(
                      label: 'MedSynapse',
                      fontSize: 26.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
