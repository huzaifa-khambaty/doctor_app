import 'package:respilink_mobile/core/utils/global_notifiers.dart';
import 'package:respilink_mobile/core/utils/handlers.dart';
import 'package:respilink_mobile/core/validators/validators.dart';
import 'package:respilink_mobile/features/auth/data/models/requests/login_request.dart';
import 'package:respilink_mobile/features/auth/data/sources/auth_local_manager.dart';
import 'package:respilink_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:respilink_mobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:respilink_mobile/features/auth/presentation/bloc/auth_state.dart';
import 'package:respilink_mobile/services/biometric_auth_service.dart';
import 'package:respilink_mobile/shared/widgets/app_loader.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../exports.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _rememberDevice = false;

  // Checked once and cached instead of re-querying the platform channel on every build.
  bool _biometricAvailable = false;

  @override
  void initState() {
    super.initState();
    locator<BiometricAuthService>().isAvailable.then((available) {
      if (mounted) setState(() => _biometricAvailable = available);
    });
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleBiometricLogin() async {
    final authenticated = await locator<BiometricAuthService>().authenticate();
    if (!authenticated) return;

    final authLocalManager = locator<AuthLocalManager>();
    final token = await authLocalManager.getCachedToken();
    final user = await authLocalManager.getCachedUser();

    if (token != null && user != null) {
      AppConstants.apiToken = token;
      GlobalNotifiers.userNotifier.value = user;
      Handlers.onLogin(user);
    } else {
      SnackbarUtil.showSnackbar(
        message: 'No saved session on this device. Please log in with your credentials once.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthSuccess) {
          Handlers.onLogin(state.model);
        }
        else if(state is AuthFailed) {
          SnackbarUtil.showSnackbar(message: state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Header row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => locator<NavigationService>().pop(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.arrow_back_ios, size: 16.sp),
                              SizedBox(width: 4.w),
                              AppText.medium(
                                label: 'Log In',
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ),
                        AppText.large(
                          label: 'RespiLink',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ],
                    ),

                    SizedBox(height: 32.h),

                    /// Icon + welcome copy
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 64.r,
                            height: 64.r,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(18.r),
                            ),
                            child: Icon(
                              Icons.medical_services_rounded,
                              color: AppColors.white,
                              size: 30.r,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          AppText.large(
                            label: 'Welcome Back',
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: 6.h),
                          AppText.small(
                            label:
                                'Enter your clinical credentials to access your dashboard.',
                            textAlign: TextAlign.center,
                            color: AppColors.grey,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 28.h),

                    /// Credentials card
                    Container(
                      width: double.infinity,
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
                            controller: _emailCtrl,
                            hint: 'smith@hospital.org',
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icon(
                              Icons.mail_outline,
                              size: 20.sp,
                            ),
                            validator: (v) => (v == null || !v.contains('@'))
                                ? Validators.validEmailRequired
                                : null,
                          ),

                          SizedBox(height: 16.h),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText.small(
                                label: 'PASSWORD',
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                              GestureDetector(
                                onTap: () =>
                                    locator<NavigationService>().navigate(
                                      RouterStrings.forgetPassword,
                                    ),
                                child: AppText.small(
                                  label: 'Forgot password?',
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          AppFormField.filled(
                            controller: _passCtrl,
                            hint: 'Enter your password',
                            obscureText: _obscure,
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              size: 20.sp,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () =>
                                  setState(() => _obscure = !_obscure),
                              child: Icon(
                                _obscure
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 20.sp,
                              ),
                            ),
                            validator: (v) => (v == null || v.length < 6)
                                ? Validators.passwordLength
                                : null,
                          ),

                          SizedBox(height: 12.h),

                          GestureDetector(
                            onTap: () => setState(
                              () => _rememberDevice = !_rememberDevice,
                            ),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: _rememberDevice,
                                  activeColor: AppColors.primary,
                                  onChanged: (v) => setState(
                                    () => _rememberDevice = v ?? false,
                                  ),
                                ),
                                AppText.small(
                                  label: 'Remember this device',
                                  color: AppColors.secondary,
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 8.h),

                          state is AuthLoading
                              ? AppLoader()
                              : AppButton.filled(
                                  label: 'Log In  →',
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      final request = LoginRequest(
                                        itsNumber: _emailCtrl.text,
                                        password: _passCtrl.text,
                                        fcmToken: AppConstants.firebaseToken,
                                      );
                                      BlocProvider.of<AuthBloc>(context).add(
                                        LoginRequested(request: request),
                                      );
                                    }
                                  },
                                ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),

                    Center(
                      child: GestureDetector(
                        onTap: () => locator<NavigationService>().navigate(
                          RouterStrings.register,
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have a clinician account? ",
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontFamily: AppConstants.fontFamily,
                              color: AppColors.black,
                            ),
                            children: [
                              TextSpan(
                                text: 'Request Access',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: AppConstants.fontFamily,
                                  fontSize: 13.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    /// Trust badges
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _TrustBadge(icon: Icons.verified_user_outlined, label: 'HIPAA COMPLIANT'),
                        _TrustBadge(icon: Icons.security, label: 'SECURE SERVER'),
                        _TrustBadge(icon: Icons.lock_outline, label: 'SSL ENCRYPTED'),
                      ],
                    ),

                    if (_biometricAvailable) ...[
                      SizedBox(height: 24.h),
                      Center(
                        child: GestureDetector(
                          onTap: _handleBiometricLogin,
                          child: Column(
                            children: [
                              Container(
                                width: 52.r,
                                height: 52.r,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.fingerprint,
                                  color: AppColors.primary,
                                  size: 28.r,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              AppText.small(
                                label: 'Unlock with biometrics',
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Trust badge shown in the footer of the login screen
class _TrustBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TrustBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 16.sp, color: AppColors.grey),
        SizedBox(height: 4.h),
        AppText.small(
          label: label,
          fontSize: 9.sp,
          color: AppColors.grey,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
