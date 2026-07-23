import 'package:flutter/widgets.dart' show Color;

class ArticleUpdateModel {
  final int id;
  final String typeSlug;
  final String typeLabel;
  final Color typeColor;
  final String title;
  final String meta;
  final String? thumbnailUrl;

  const ArticleUpdateModel({
    required this.id,
    required this.typeSlug,
    required this.typeLabel,
    required this.typeColor,
    required this.title,
    required this.meta,
    this.thumbnailUrl,
  });
}
