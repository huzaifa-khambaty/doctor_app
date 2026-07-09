import 'package:respilink_mobile/features/quiz/domain/models/reinforce_content_model.dart';
import 'package:respilink_mobile/features/quiz/presentation/widgets/reinforce_knowledge_card.dart';

import '../../../../exports.dart';

class ReinforceKnowledgeSection extends StatelessWidget {
  final List<ReinforceContentModel> items;

  const ReinforceKnowledgeSection({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.medium(
          label: 'Reinforce Knowledge',
          fontWeight: FontWeight.bold,
          fontSize: 15.sp,
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 160.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (context, index) => SizedBox(width: 12.w),
            itemBuilder: (context, index) =>
                ReinforceKnowledgeCard(content: items[index]),
          ),
        ),
      ],
    );
  }
}
