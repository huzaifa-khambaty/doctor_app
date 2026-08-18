import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:respilink_mobile/core/theme/theme_cubit.dart';
import 'package:respilink_mobile/core/utils/date_time_utils.dart';
import 'package:respilink_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:respilink_mobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:respilink_mobile/features/auth/presentation/bloc/auth_state.dart';
import 'package:respilink_mobile/features/auth/presentation/widgets/privacy_policy_skeleton.dart';
import 'package:respilink_mobile/shared/widgets/app_html_text.dart';
import 'package:respilink_mobile/shared/widgets/request_failed.dart';

import '../../../../exports.dart';

class PrivacyPolicyView extends StatefulWidget {
  const PrivacyPolicyView({super.key});

  @override
  State<PrivacyPolicyView> createState() => _PrivacyPolicyViewState();
}

class _PrivacyPolicyViewState extends State<PrivacyPolicyView> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(PrivacyPolicyRequested());
  }

  String? _formatUpdatedAt(String? updatedAt) {
    final date = DateTimeUtils.parseBackendDate(updatedAt);
    if (date == null) return null;
    return DateFormat('MMM d, yyyy').format(date.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: false,
            titleSpacing: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: 18.sp,
                color: AppColors.black,
              ),
              onPressed: () => locator<NavigationService>().pop(),
            ),
            title: AppText.medium(
              label: 'Privacy & Security',
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          body: SafeArea(
            top: false,
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is PrivacyPolicyFailed) {
                  SnackbarUtil.showSnackbar(
                    message: state.message,
                    isError: true,
                  );
                }
              },
              builder: (context, state) {
                if (state is PrivacyPolicyFailed) {
                  return RequestFailed(message: state.message);
                }

                if (state is! PrivacyPolicyLoaded) {
                  return const PrivacyPolicySkeleton();
                }

                final policy = state.policy;
                final updatedLabel = _formatUpdatedAt(policy.updatedAt);

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.large(
                        label: policy.title ?? 'Privacy & Security',
                        fontWeight: FontWeight.bold,
                        fontSize: 19.sp,
                      ),
                      if (updatedLabel != null) ...[
                        SizedBox(height: 6.h),
                        AppText.small(
                          label: 'Last updated $updatedLabel',
                          color: AppColors.grey,
                          fontSize: 11.sp,
                        ),
                      ],
                      SizedBox(height: 20.h),
                      AppHtmlText(html: policy.content ?? ''),
                      SizedBox(height: 16.h),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
