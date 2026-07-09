import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/exports.dart';
import 'package:respilink_mobile/providers.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => child!,
      child: MultiBlocProvider(
        providers: Providers.getProviders(context),
        child: MaterialApp.router(
          title: AppConstants.appName,
          routerConfig: RouterConfiguration.router,
          theme: ThemeData(
            textSelectionTheme: TextSelectionThemeData(
              selectionHandleColor: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
