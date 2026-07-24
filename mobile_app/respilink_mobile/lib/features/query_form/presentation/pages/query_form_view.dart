import 'package:respilink_mobile/features/query_form/domain/models/query_category.dart';
import 'package:respilink_mobile/features/query_form/domain/models/query_item_model.dart';
import 'package:respilink_mobile/features/query_form/presentation/widgets/query_form_card.dart';
import 'package:respilink_mobile/features/query_form/presentation/widgets/query_form_header.dart';
import 'package:respilink_mobile/features/query_form/presentation/widgets/recent_queries_section.dart';
import 'package:respilink_mobile/shared/widgets/respilink_app_bar.dart';

import '../../../../exports.dart';

// TODO: replace with real data from the backend once the query inbox API is wired up.
const _recentQueries = [
  QueryItemModel(
    id: 1,
    icon: Icons.medication_outlined,
    iconColor: AppColors.primary,
    title: 'Dosage adjustment for COPD Patient #442',
    submittedLabel: 'Today, 10:45 AM',
    status: QueryStatus.pending,
  ),
  QueryItemModel(
    id: 2,
    icon: Icons.bug_report_outlined,
    iconColor: AppColors.indigoAccent,
    title: 'API timeout on patient dashboard',
    submittedLabel: 'Yesterday',
    status: QueryStatus.answered,
  ),
  QueryItemModel(
    id: 3,
    icon: Icons.lightbulb_outline,
    iconColor: AppColors.purpleAccent,
    title: 'Feature Request: Dark Mode Toggle',
    submittedLabel: 'Oct 24, 2023',
    status: QueryStatus.answered,
  ),
];

class QueryFormView extends StatefulWidget {
  final bool showBackButton;

  const QueryFormView({super.key, this.showBackButton = true});

  @override
  State<QueryFormView> createState() => _QueryFormViewState();
}

class _QueryFormViewState extends State<QueryFormView> {
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  QueryCategory _category = QueryCategory.clinical;

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_subjectController.text.isEmpty || _messageController.text.isEmpty) {
      SnackbarUtil.showSnackbar(
        message: 'Please fill in the subject and message.',
      );
      return;
    }
    // TODO: submit the query to the backend once the API is wired up.
    SnackbarUtil.showSnackbar(message: 'Query submitted successfully.');
    _subjectController.clear();
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: RespiLinkAppBar(showBackButton: widget.showBackButton),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const QueryFormHeader(),

              SizedBox(height: 20.h),

              QueryFormCard(
                category: _category,
                onCategoryChanged: (category) =>
                    setState(() => _category = category ?? _category),
                subjectController: _subjectController,
                messageController: _messageController,
                onSubmit: _submit,
              ),

              SizedBox(height: 24.h),

              RecentQueriesSection(
                queries: _recentQueries,
                onViewAll: () {
                  // TODO: navigate to the full query history screen once it exists.
                },
                onQueryTap: (query) {
                  locator<NavigationService>().navigate(
                    RouterStrings.queryChat,
                    arguments: query,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
