import 'package:flutter/widgets.dart';

class RelatedArticleModel {
  final int id;
  final String image;
  final String category;
  final Color categoryColor;
  final String title;

  const RelatedArticleModel({
    required this.id,
    required this.image,
    required this.category,
    required this.categoryColor,
    required this.title,
  });
}
