import 'package:flutter/material.dart';
import 'package:respilink_app/shared/model/admin_mode.dart';

class GlobalNotifiers {
  GlobalNotifiers._();

  static ValueNotifier<Admin?> adminNotifier = ValueNotifier(Admin());
  static ValueNotifier<String?> appNameNotifier = ValueNotifier(null);
  static ValueNotifier<String?> appLogoNotifier = ValueNotifier(null);
}
