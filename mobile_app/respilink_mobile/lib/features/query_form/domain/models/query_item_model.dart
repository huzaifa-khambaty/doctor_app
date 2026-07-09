import 'package:flutter/widgets.dart';

enum QueryStatus { pending, answered }

class QueryItemModel {
  final int id;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String submittedLabel;
  final QueryStatus status;

  const QueryItemModel({
    required this.id,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.submittedLabel,
    required this.status,
  });
}
