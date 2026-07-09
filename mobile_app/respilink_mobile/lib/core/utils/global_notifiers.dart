import 'package:respilink_mobile/exports.dart';
import 'package:respilink_mobile/features/auth/domain/models/user_model.dart';

class GlobalNotifiers {
  GlobalNotifiers._();

  static ValueNotifier<Doctor?> userNotifier = ValueNotifier(Doctor());
  static ValueNotifier<int> notificationCountNotifier = ValueNotifier(0);
}
