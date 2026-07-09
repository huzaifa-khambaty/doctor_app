import 'package:flutter/material.dart';

class MobileDashboardView extends StatelessWidget {
  final Widget contentBody;

  const MobileDashboardView({super.key, required this.contentBody});

  @override
  Widget build(BuildContext context) {
    // No inner Scaffold — MainDashboardScreen's Scaffold now owns
    // appBar/drawer. This just needs to provide one scroll boundary.
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: contentBody,
    );
  }
}