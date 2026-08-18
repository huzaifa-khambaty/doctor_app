import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/core/theme/theme_cubit.dart';
import 'package:respilink_mobile/core/utils/date_time_utils.dart';
import 'package:respilink_mobile/features/query_form/data/model/queries_model.dart';
import 'package:respilink_mobile/features/query_form/data/model/query_category_model.dart';
import 'package:respilink_mobile/features/query_form/domain/models/query_item_model.dart';
import 'package:respilink_mobile/features/query_form/presentation/bloc/query_categories_bloc.dart';
import 'package:respilink_mobile/features/query_form/presentation/bloc/query_categories_event.dart';
import 'package:respilink_mobile/features/query_form/presentation/bloc/query_categories_state.dart';
import 'package:respilink_mobile/features/query_form/presentation/bloc/recent_queries_bloc.dart';
import 'package:respilink_mobile/features/query_form/presentation/bloc/recent_queries_event.dart';
import 'package:respilink_mobile/features/query_form/presentation/bloc/recent_queries_state.dart';
import 'package:respilink_mobile/features/query_form/presentation/bloc/submit_query_bloc.dart';
import 'package:respilink_mobile/features/query_form/presentation/bloc/submit_query_event.dart';
import 'package:respilink_mobile/features/query_form/presentation/bloc/submit_query_state.dart';
import 'package:respilink_mobile/features/query_form/presentation/widgets/query_form_card.dart';
import 'package:respilink_mobile/features/query_form/presentation/widgets/query_form_header.dart';
import 'package:respilink_mobile/features/query_form/presentation/widgets/recent_queries_section.dart';
import 'package:respilink_mobile/shared/widgets/respilink_app_bar.dart';

import '../../../../exports.dart';

class QueryFormView extends StatefulWidget {
  final bool showBackButton;

  const QueryFormView({super.key, this.showBackButton = true});

  @override
  State<QueryFormView> createState() => _QueryFormViewState();
}

class _QueryFormViewState extends State<QueryFormView> {
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  QueryCategoryModel? _category;

  @override
  void initState() {
    super.initState();
    context.read<QueryCategoriesBloc>().add(QueryCategoriesRequested());
    context.read<RecentQueriesBloc>().add(RecentQueriesRequested());
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submit() {
    final subject = _subjectController.text.trim();
    final message = _messageController.text.trim();

    if (subject.isEmpty || message.isEmpty) {
      SnackbarUtil.showSnackbar(
        message: 'Please fill in the subject and message.',
      );
      return;
    }

    final categoryId = _category?.id;
    if (categoryId == null) {
      SnackbarUtil.showSnackbar(message: 'Please select a category.');
      return;
    }

    context.read<SubmitQueryBloc>().add(
      SubmitQueryRequested(
        categoryId: categoryId,
        subject: subject,
        message: message,
      ),
    );
  }

  (IconData, Color) _iconFor(String? slug) => switch (slug?.toLowerCase()) {
    'clinical' => (Icons.medication_outlined, AppColors.primary),
    'technical' => (Icons.bug_report_outlined, AppColors.indigoAccent),
    'billing' => (Icons.receipt_long_outlined, AppColors.yellow),
    'other' => (Icons.lightbulb_outline, AppColors.purpleAccent),
    _ => (Icons.help_outline, AppColors.primary),
  };

  QueryStatus _statusFor(String? status) => switch (status?.toLowerCase()) {
    'answered' || 'resolved' || 'closed' => QueryStatus.answered,
    _ => QueryStatus.pending,
  };

  QueryItemModel _mapQuery(Data query) {
    final (icon, iconColor) = _iconFor(query.category?.slug);

    return QueryItemModel(
      id: query.id ?? 0,
      icon: icon,
      iconColor: iconColor,
      title: query.subject ?? '',
      submittedLabel: DateTimeUtils.formatTimeShortDays(query.createdAt),
      status: _statusFor(query.status),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return Scaffold(
          backgroundColor: AppColors.background,
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

                  BlocConsumer<SubmitQueryBloc, SubmitQueryState>(
                    listener: (context, submitState) {
                      if (submitState is SubmitQuerySuccess) {
                        SnackbarUtil.showSnackbar(message: submitState.message);
                        _subjectController.clear();
                        _messageController.clear();
                        // The new ticket should show up in the recent list.
                        context.read<RecentQueriesBloc>().add(
                          RecentQueriesRequested(),
                        );
                      } else if (submitState is SubmitQueryFailed) {
                        SnackbarUtil.showSnackbar(
                          message: submitState.message,
                          isError: true,
                        );
                      }
                    },
                    builder: (context, submitState) {
                      final isSubmitting = submitState is SubmitQueryLoading;

                      return BlocConsumer<
                        QueryCategoriesBloc,
                        QueryCategoriesState
                      >(
                        listener: (context, state) {
                          if (state is QueryCategoriesFailed) {
                            SnackbarUtil.showSnackbar(
                              message: state.message,
                              isError: true,
                            );
                          } else if (state is QueryCategoriesLoaded &&
                              _category == null &&
                              state.categories.isNotEmpty) {
                            // Pick a sensible default once categories arrive, same
                            // as the previous hardcoded QueryCategory.clinical default.
                            setState(() => _category = state.categories.first);
                          }
                        },
                        builder: (context, state) {
                          final categories = state is QueryCategoriesLoaded
                              ? state.categories
                              : const <QueryCategoryModel>[];

                          return QueryFormCard(
                            categories: categories,
                            category: _category,
                            categoriesLoading: state is QueryCategoriesLoading,
                            onCategoryChanged: (category) =>
                                setState(() => _category = category),
                            subjectController: _subjectController,
                            messageController: _messageController,
                            onSubmit: _submit,
                            isSubmitting: isSubmitting,
                          );
                        },
                      );
                    },
                  ),

                  SizedBox(height: 24.h),

                  BlocConsumer<RecentQueriesBloc, RecentQueriesState>(
                    listener: (context, state) {
                      if (state is RecentQueriesFailed) {
                        SnackbarUtil.showSnackbar(
                          message: state.message,
                          isError: true,
                        );
                      }
                    },
                    builder: (context, state) {
                      final queries = state is RecentQueriesLoaded
                          ? [
                              for (final query in state.queries)
                                _mapQuery(query),
                            ]
                          : const <QueryItemModel>[];

                      return RecentQueriesSection(
                        queries: queries,
                        isLoading: state is RecentQueriesLoading,
                        hasError: state is RecentQueriesFailed,
                        onViewAll: () {
                          // TODO: navigate to the full query history screen once it exists.
                        },
                        onQueryTap: (query) {
                          locator<NavigationService>().navigate(
                            RouterStrings.queryChat,
                            arguments: query,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
