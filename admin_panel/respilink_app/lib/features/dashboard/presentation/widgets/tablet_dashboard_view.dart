import 'package:flutter/material.dart';
import 'package:respilink_app/core/theme/app_colors.dart';

class TabletDashboardView extends StatelessWidget {
  final Widget sidebar;
  final Widget contentBody;

  const TabletDashboardView({super.key, required this.sidebar, required this.contentBody});

  @override
  Widget build(BuildContext context) {
    // No inner Scaffold — MainDashboardScreen's Scaffold now owns
    // the chrome (appBar/drawer). This just lays out sidebar + content.
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Collapsed icon-only sidebar
        SizedBox(
          width: 72,
          child: sidebar,
        ),
        const VerticalDivider(width: 1, thickness: 1, color: AppColors.borderLight),

        // 2. Main scrollable dashboard content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: contentBody,
          ),
        ),
      ],
    );
  }
}