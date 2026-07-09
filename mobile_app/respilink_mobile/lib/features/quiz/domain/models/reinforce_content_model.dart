enum ReinforceContentType { article, video }

class ReinforceContentModel {
  final ReinforceContentType type;
  final String title;
  final String image;

  const ReinforceContentModel({
    required this.type,
    required this.title,
    required this.image,
  });

  String get typeLabel =>
      type == ReinforceContentType.article ? 'Article' : 'Video';
}
