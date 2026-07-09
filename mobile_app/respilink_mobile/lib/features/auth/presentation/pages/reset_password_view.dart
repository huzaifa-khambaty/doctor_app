import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/core/validators/validators.dart';
import 'package:respilink_mobile/features/auth/data/models/requests/reset_password_request.dart';
import 'package:respilink_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:respilink_mobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:respilink_mobile/features/auth/presentation/bloc/auth_state.dart';
import 'package:respilink_mobile/shared/widgets/app_loader.dart';
import '../../../../core/utils/handlers.dart';
import '../../../../exports.dart';

class ResetPasswordView extends StatefulWidget {
  final String email;
  final String code;

  const ResetPasswordView({
    super.key,
    required this.email,
    required this.code,
  });

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final _formKey = GlobalKey<FormState>();

  final _passwordCtrl = TextEditingController();
  final _cnfPasswordCtrl = TextEditingController();

  @override
  void dispose() {
    _passwordCtrl.dispose();
    _cnfPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Handlers.onPasswordReset();
        } else if (state is AuthFailed) {
          SnackbarUtil.showSnackbar(message: state.message);
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
              label: 'Reset Password',
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: _FormView(
                formKey: _formKey,
                passwordCtrl: _passwordCtrl,
                cnfPasswordCtrl: _cnfPasswordCtrl,
                state: state,
                onSubmit: () {
                  final request = ResetPasswordRequest(
                    email: widget.email,
                    confirmPassword: _cnfPasswordCtrl.text,
                    otp: widget.code,
                    password: _passwordCtrl.text,
                  );
                  BlocProvider.of<AuthBloc>(
                    context,
                  ).add(ResetPasswordRequested(request: request));
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

/// ================= FORM VIEW =================
class _FormView extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final VoidCallback onSubmit;
  final TextEditingController passwordCtrl;
  final TextEditingController cnfPasswordCtrl;
  final AuthState state;

  const _FormView({
    required this.formKey,
    required this.onSubmit,
    required this.passwordCtrl,
    required this.cnfPasswordCtrl,
    required this.state,
  });

  @override
  State<_FormView> createState() => _FormViewState();
}

class _FormViewState extends State<_FormView> {
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: widget.formKey,
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
                      Icons.lock_reset_rounded,
                      color: AppColors.primary,
                      size: 28.r,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  AppText.large(
                    label: 'Reset Password',
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 6.h),
                  AppText.small(
                    label: 'Update your account password to keep it secure.',
                    color: AppColors.grey,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            /// Fields card
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
                    label: 'NEW PASSWORD',
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 6.h),
                  AppFormField.filled(
                    controller: widget.passwordCtrl,
                    hint: 'Enter your new password',
                    obscureText: _obscureNew,
                    prefixIcon: Icon(Icons.lock_outline, size: 20.sp),
                    suffixIcon: GestureDetector(
                      onTap: () => setState(() => _obscureNew = !_obscureNew),
                      child: Icon(
                        _obscureNew
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 20.sp,
                      ),
                    ),
                    validator: (v) => (v == null || v.isEmpty)
                        ? Validators.passwordRequired
                        : v.length < 6
                        ? Validators.passwordLength
                        : null,
                  ),

                  SizedBox(height: 16.h),

                  AppText.small(
                    label: 'CONFIRM PASSWORD',
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 6.h),
                  AppFormField.filled(
                    controller: widget.cnfPasswordCtrl,
                    hint: 'Re-enter your new password',
                    obscureText: _obscureConfirm,
                    prefixIcon: Icon(Icons.lock_outline, size: 20.sp),
                    suffixIcon: GestureDetector(
                      onTap: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                      child: Icon(
                        _obscureConfirm
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 20.sp,
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return Validators.confirmPasswordRequired;
                      }
                      if (v != widget.passwordCtrl.text) {
                        return Validators.passwordsDoNotMatch;
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 8.h),

                  widget.state is AuthLoading
                      ? AppLoader()
                      : AppButton.filled(
                          label: 'Update Password  →',
                          onTap: () {
                            if (widget.formKey.currentState!.validate()) {
                              widget.onSubmit();
                            }
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
