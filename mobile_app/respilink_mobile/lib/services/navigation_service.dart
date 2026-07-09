import '../exports.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  Future<Object?>? navigate(String route, {Object? arguments}) =>
      navigationKey.currentContext?.push(route, extra: arguments);

  void navigateAndRemove(String route, {Object? arguments}) =>
      navigationKey.currentContext?.go(route, extra: arguments);

  void pop({Object? arg}) => navigationKey.currentContext?.pop(arg);
}
