import 'package:respilink_mobile/features/events/domain/models/conference_detail_model.dart';
import 'package:respilink_mobile/features/events/presentation/widgets/agenda_item_tile.dart';
import 'package:respilink_mobile/features/events/presentation/widgets/day_tab_selector.dart';

import '../../../../exports.dart';

class ConferenceAgendaSection extends StatefulWidget {
  final Map<String, List<AgendaItemModel>> agendaByDay;

  const ConferenceAgendaSection({super.key, required this.agendaByDay});

  @override
  State<ConferenceAgendaSection> createState() =>
      _ConferenceAgendaSectionState();
}

class _ConferenceAgendaSectionState extends State<ConferenceAgendaSection>
    with SingleTickerProviderStateMixin {
  late final List<String> _days = widget.agendaByDay.keys.toList();
  late final TabController _tabController = TabController(
    length: _days.length,
    vsync: this,
  )..addListener(() {
    if (!_tabController.indexIsChanging) setState(() {});
  });

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedDay = _days[_tabController.index];
    final items = widget.agendaByDay[selectedDay] ?? const [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.medium(
          label: 'Conference Agenda',
          fontWeight: FontWeight.bold,
          fontSize: 15.sp,
        ),
        SizedBox(height: 12.h),
        DayTabSelector(controller: _tabController, days: _days),
        SizedBox(height: 16.h),
        ...items.map(
          (item) => Padding(
            padding: EdgeInsets.only(bottom: 18.h),
            child: AgendaItemTile(item: item),
          ),
        ),
      ],
    );
  }
}
