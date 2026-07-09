import 'package:respilink_mobile/features/content_library/domain/models/article_block.dart';

class ArticleModel {
  final String title;
  final String tag;
  final String readTime;
  final String bannerImage;
  final String authorName;
  final String? authorAvatarUrl;
  final String publishedLabel;
  final List<ArticleBlock> blocks;

  const ArticleModel({
    required this.title,
    required this.tag,
    required this.readTime,
    required this.bannerImage,
    required this.authorName,
    this.authorAvatarUrl,
    required this.publishedLabel,
    required this.blocks,
  });
}
