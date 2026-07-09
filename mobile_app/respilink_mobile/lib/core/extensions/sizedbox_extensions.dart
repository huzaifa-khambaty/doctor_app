import 'package:flutter/widgets.dart';

extension SizedBoxExtension on num {
  SizedBox get addHeight => SizedBox(height: toDouble());
  SizedBox get addWidth => SizedBox(width: toDouble());
}