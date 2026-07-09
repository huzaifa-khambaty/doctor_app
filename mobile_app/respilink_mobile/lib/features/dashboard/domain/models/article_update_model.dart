enum ArticleCategory { research, pharma, tech }

class ArticleUpdateModel {
  final ArticleCategory category;
  final String title;
  final String meta;
  final String image;

  const ArticleUpdateModel({
    required this.category,
    required this.title,
    required this.meta,
    required this.image,
  });
}
