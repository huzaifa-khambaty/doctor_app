import 'package:respilink_mobile/core/utils/handlers.dart';
import 'package:respilink_mobile/core/validators/validators.dart';
import 'package:respilink_mobile/features/auth/data/models/requests/forget_password_request.dart';
import 'package:respilink_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:respilink_mobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:respilink_mobile/features/auth/presentation/bloc/auth_state.dart';
import 'package:respilink_mobile/shared/widgets/app_loader.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../exports.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();

  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is ForgetPasswordSuccess) {
          Handlers.onForgetPassword(_emailCtrl.text);
        } else if (state is AuthFailed) {
          SnackbarUtil.showSnackbar(message: state.message, isError: true);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: AppColors.black),
            title: AppText.medium(
              label: 'Forgot Password',
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: _FormView(
                formKey: _formKey,
                emailCtrl: _emailCtrl,
                onSubmit: () {
                  final request = ForgetPasswordRequest(email: _emailCtrl.text);
                  BlocProvider.of<AuthBloc>(
                    context,
                  ).add(ForgetPasswordRequested(request: request));
                },
                state: state,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// ================= FORM VIEW =================
class _FormView extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final VoidCallback onSubmit;
  final TextEditingController emailCtrl;
  final AuthState state;

  const _FormView({
    required this.formKey,
    required this.onSubmit,
    required this.emailCtrl,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// Icon + intro copy
            Center(
              child: Column(
                children: [
                  Container(
                    width: 56.r,
                    height: 56.r,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Icon(
                      Icons.lock_outline,
                      color: AppColors.primary,
                      size: 28.r,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  AppText.large(
                    label: 'Forgot Password?',
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 6.h),
                  AppText.small(
                    label:
                        "No worries, enter your professional email and we'll send you a reset code.",
                    color: AppColors.grey,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            /// Field card
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.fieldColor,
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.small(
                    label: 'PROFESSIONAL EMAIL',
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 6.h),
                  AppFormField.filled(
                    controller: emailCtrl,
                    hint: 'smith@hospital.org',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icon(Icons.mail_outline, size: 20.sp),
                    validator: (v) => (v == null || !v.contains('@'))
                        ? Validators.validEmailRequired
                        : null,
                  ),

                  SizedBox(height: 8.h),

                  state is AuthLoading
                      ? AppLoader()
                      : AppButton.filled(
                          label: 'Send Reset Code  →',
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              onSubmit();
                            }
                          },
                        ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            Center(
              child: GestureDetector(
                onTap: () => context.pop(),
                child: AppText.small(
                  label: 'Back to Login',
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}