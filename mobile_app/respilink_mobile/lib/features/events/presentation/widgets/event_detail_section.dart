import '../../../../exports.dart';

class EventDetailSection extends StatefulWidget {
  final String title;
  final String description;

  /// When set, shows a "Read Full Syllabus" expand/collapse link that reveals
  /// this extra text below [description].
  final String? expandedContent;

  const EventDetailSection({
    super.key,
    required this.title,
    required this.description,
    this.expandedContent,
  });

  @override
  State<EventDetailSection> createState() => _EventDetailSectionState();
}

class _EventDetailSectionState extends State<EventDetailSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.medium(
          label: widget.title,
          fontWeight: FontWeight.bold,
          fontSize: 15.sp,
        ),
        SizedBox(height: 8.h),
        AppText.small(
          label: widget.description,
          color: AppColors.grey,
          fontSize: 13.sp,
          height: 1.5,
        ),
        if (widget.expandedContent != null) ...[
          if (_expanded) ...[
            SizedBox(height: 8.h),
            AppText.small(
              label: widget.expandedContent!,
              color: AppColors.grey,
              fontSize: 13.sp,
              height: 1.5,
            ),
          ],
          SizedBox(height: 6.h),
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: AppText.small(
                    label: _expanded ? 'Show Less' : 'Read Full Syllabus',
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.primary,
                  size: 18.sp,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
