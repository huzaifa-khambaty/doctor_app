import 'package:flutter/widgets.dart';

class RelatedArticleModel {
  final String image;
  final String category;
  final Color categoryColor;
  final String title;

  const RelatedArticleModel({
    required this.image,
    required this.category,
    required this.categoryColor,
    required this.title,
  });
}
