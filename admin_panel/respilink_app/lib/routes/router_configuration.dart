import 'package:go_router/go_router.dart';
import 'package:respilink_app/features/auth/presentation/pages/login_view.dart';
import 'package:respilink_app/features/dashboard/presentation/pages/dashboard_view.dart';
import 'package:respilink_app/routes/router_strings.dart';

class RouterConfiguration {
  RouterConfiguration._();

  static final GoRouter router = GoRouter(
    initialLocation: RouterStrings.initial,
    routes: [
      GoRoute(
        path: RouterStrings.initial,
        builder: (context, state) => LoginPage(),
      ),
      GoRoute(
        path: RouterStrings.dashboard,
        builder: (context, state) => MainDashboardScreen(),
      ),
    ],
  );
}
