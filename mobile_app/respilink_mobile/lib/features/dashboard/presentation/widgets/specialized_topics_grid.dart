import 'package:respilink_mobile/features/dashboard/domain/models/specialized_topic_model.dart';
import 'package:respilink_mobile/features/dashboard/presentation/widgets/specialized_topic_card.dart';

import '../../../../exports.dart';

class SpecializedTopicsGrid extends StatelessWidget {
  final List<SpecializedTopicModel> topics;

  const SpecializedTopicsGrid({super.key, required this.topics});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: topics.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.15,
      ),
      itemBuilder: (context, index) =>
          SpecializedTopicCard(topic: topics[index]),
    );
  }
}
