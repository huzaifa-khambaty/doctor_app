import 'package:flutter/widgets.dart' show IconData;
import 'package:flutter/material.dart' show Icons;

class DashboardNavItemModel {
  final String label;

  /// Asset name under [AppConstants.svgPath]. Null falls back to [icon].
  final String? svgIcon;

  /// Used when there is no dedicated svg asset for this tab.
  final IconData? icon;

  const DashboardNavItemModel({required this.label, this.svgIcon, this.icon})
      : assert(svgIcon != null || icon != null);
}

const List<DashboardNavItemModel> dashboardNavItems = [
  DashboardNavItemModel(label: 'Home', svgIcon: 'home.svg'),
  DashboardNavItemModel(label: 'Events', svgIcon: 'events.svg'),
  DashboardNavItemModel(label: 'Quiz', svgIcon: 'quiz.svg'),
  DashboardNavItemModel(label: 'Library', svgIcon: 'library.svg'),
  DashboardNavItemModel(label: 'Query', icon: Icons.chat_bubble_outline_rounded),
];
