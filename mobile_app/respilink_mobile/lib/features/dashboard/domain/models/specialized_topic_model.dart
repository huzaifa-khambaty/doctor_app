import 'package:flutter/widgets.dart';

class SpecializedTopicModel {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;

  /// 0.0 - 1.0 completion progress shown as a thin bar under the card.
  final double progress;

  const SpecializedTopicModel({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.progress,
  });
}
