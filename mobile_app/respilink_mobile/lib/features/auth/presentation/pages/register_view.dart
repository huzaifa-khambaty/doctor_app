import 'package:respilink_mobile/core/utils/handlers.dart';
import 'package:respilink_mobile/core/validators/validators.dart';
import 'package:respilink_mobile/features/auth/data/models/requests/register_request.dart';
import 'package:respilink_mobile/features/auth/data/models/specialities_model.dart';
import 'package:respilink_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:respilink_mobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:respilink_mobile/features/auth/presentation/bloc/auth_state.dart';
import 'package:respilink_mobile/shared/widgets/app_loader.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../exports.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();

  final _itsCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _hospitalCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  List<SpecialitiesModel> _specialities = [];
  final List<int> _selectedSpecialtyIds = [];
  bool _obscure = true;
  bool _obscureConfirm = true;
  bool _termsAccepted = false;

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(SpecialitiesRequested());
  }

  @override
  void dispose() {
    _itsCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _hospitalCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Handlers.onRegister(state.model);
        }
        else if(state is AuthFailed) {
          SnackbarUtil.showSnackbar(message: state.message);
        }
        else if (state is SpecialitiesLoaded) {
          setState(() => _specialities = state.specialities);
        }
        else if (state is SpecialitiesFailed) {
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
                          onTap: () => context.pop(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.arrow_back_ios, size: 16.sp),
                              SizedBox(width: 4.w),
                              AppText.medium(
                                label: 'Sign Up',
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

                    SizedBox(height: 20.h),

                    /// Intro banner
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.tealGradientStart,
                            AppColors.deeperTeal,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.large(
                            label: 'Join our Clinical Network',
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: 6.h),
                          AppText.small(
                            label:
                                'Create your professional profile to start collaborating with global respiratory experts.',
                            color: AppColors.white.withValues(alpha: 0.9),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),

                    /// Fields
                    AppText.small(
                      label: 'Full Name',
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 6.h),
                    AppFormField.filled(
                      controller: _nameCtrl,
                      hint: 'e.g. Dr. Sarah Jenkins',
                      prefixIcon: Icon(Icons.person_outline, size: 20.sp),
                      validator: (v) => (v == null || v.isEmpty)
                          ? Validators.fullNameRequired
                          : null,
                    ),

                    SizedBox(height: 16.h),

                    AppText.small(
                      label: 'Work Email',
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 6.h),
                    AppFormField.filled(
                      controller: _emailCtrl,
                      hint: 'sarah.jenkins@hospital.org',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icon(Icons.mail_outline, size: 20.sp),
                      validator: (v) => (v == null || !v.contains('@'))
                          ? Validators.validEmailRequired
                          : null,
                    ),

                    SizedBox(height: 16.h),

                    AppText.small(
                      label: 'Phone Number',
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 6.h),
                    AppFormField.filled(
                      controller: _phoneCtrl,
                      hint: '+1 (555) 000-0000',
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icon(Icons.phone_outlined, size: 20.sp),
                      validator: (v) => (v == null || v.isEmpty)
                          ? Validators.phoneRequired
                          : null,
                    ),

                    SizedBox(height: 16.h),

                    AppText.small(
                      label: 'Specialties',
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 6.h),
                    if (state is SpecialitiesLoading && _specialities.isEmpty)
                      AppLoader()
                    else if (state is SpecialitiesFailed &&
                        _specialities.isEmpty)
                      GestureDetector(
                        onTap: () => context.read<AuthBloc>().add(
                          SpecialitiesRequested(),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.refresh,
                              size: 16.sp,
                              color: AppColors.error,
                            ),
                            SizedBox(width: 6.w),
                            AppText.small(
                              label: 'Failed to load specialties. Tap to retry.',
                              color: AppColors.error,
                            ),
                          ],
                        ),
                      )
                    else
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: _specialities.map((speciality) {
                          final selected = _selectedSpecialtyIds.contains(
                            speciality.id,
                          );
                          return FilterChip(
                            label: Text(speciality.name ?? ''),
                            selected: selected,
                            selectedColor: AppColors.primary.withValues(
                              alpha: 0.15,
                            ),
                            checkmarkColor: AppColors.primary,
                            onSelected: (isSelected) {
                              setState(() {
                                if (isSelected) {
                                  _selectedSpecialtyIds.add(speciality.id!);
                                } else {
                                  _selectedSpecialtyIds.remove(speciality.id);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),

                    SizedBox(height: 16.h),

                    AppText.small(
                      label: 'Primary Hospital/Clinic',
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 6.h),
                    AppFormField.filled(
                      controller: _hospitalCtrl,
                      hint: 'Mayo Clinic, Rochester',
                      prefixIcon: Icon(
                        Icons.medical_information_outlined,
                        size: 20.sp,
                      ),
                      validator: (v) => (v == null || v.isEmpty)
                          ? Validators.hospitalRequired
                          : null,
                    ),

                    SizedBox(height: 16.h),

                    /// Password
                    AppText.small(
                      label: 'Password',
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 6.h),
                    AppFormField.filled(
                      controller: _passCtrl,
                      hint: 'Create a password',
                      obscureText: _obscure,
                      prefixIcon: Icon(Icons.lock_outline, size: 20.sp),
                      suffixIcon: GestureDetector(
                        onTap: () => setState(() => _obscure = !_obscure),
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

                    SizedBox(height: 16.h),

                    /// Confirm Password
                    AppText.small(
                      label: 'Confirm Password',
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 6.h),
                    AppFormField.filled(
                      controller: _confirmPassCtrl,
                      hint: 'Re-enter your password',
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
                        if (v != _passCtrl.text) {
                          return Validators.passwordsDoNotMatch;
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 20.h),

                    /// Terms
                    GestureDetector(
                      onTap: () =>
                          setState(() => _termsAccepted = !_termsAccepted),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 24.h,
                            width: 24.w,
                            child: Checkbox(
                              value: _termsAccepted,
                              onChanged: (v) =>
                                  setState(() => _termsAccepted = v ?? false),
                              activeColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                          ),

                          SizedBox(width: 8.w),

                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(top: 4.h),
                              child: RichText(
                                text: TextSpan(
                                  text: 'I agree to the ',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.black,
                                    fontFamily: AppConstants.fontFamily,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Terms of Service',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontFamily: AppConstants.fontFamily,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' and ',
                                      style: TextStyle(
                                        color: AppColors.black,
                                        fontFamily: AppConstants.fontFamily,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Privacy Policy',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontFamily: AppConstants.fontFamily,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          ', including professional verification.',
                                      style: TextStyle(
                                        color: AppColors.black,
                                        fontFamily: AppConstants.fontFamily,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    /// Button
                    state is AuthLoading
                        ? AppLoader()
                        : AppButton.filled(
                            label: 'Continue  →',
                            onTap: _termsAccepted
                                ? () {
                                    if (_selectedSpecialtyIds.isEmpty) {
                                      SnackbarUtil.showSnackbar(
                                        message: Validators.specialtyRequired,
                                      );
                                      return;
                                    }
                                    if (_formKey.currentState!.validate()) {
                                      final request = RegisterRequest(
                                        itsNumber: _itsCtrl.text,
                                        name: _nameCtrl.text,
                                        email: _emailCtrl.text,
                                        phone: _phoneCtrl.text,
                                        specialtyIds: _selectedSpecialtyIds,
                                        hospitalAffiliation:
                                            _hospitalCtrl.text,
                                        password: _passCtrl.text,
                                        passwordConfirmation:
                                            _confirmPassCtrl.text,
                                        fcmToken: AppConstants.firebaseToken,
                                      );
                                      BlocProvider.of<AuthBloc>(context).add(
                                        RegisterRequested(request: request),
                                      );
                                    }
                                  }
                                : null,
                          ),

                    SizedBox(height: 20.h),

                    Center(
                      child: GestureDetector(
                        onTap: () => context.pop(),
                        child: RichText(
                          text: TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontFamily: AppConstants.fontFamily,
                              color: AppColors.black,
                            ),
                            children: [
                              TextSpan(
                                text: 'Log In',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.sp,
                                  fontFamily: AppConstants.fontFamily,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    /// Trust badges
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _TrustBadge(
                          icon: Icons.verified_user_outlined,
                          label: 'HIPAA Compliant',
                        ),
                        _TrustBadge(
                          icon: Icons.lock_outline,
                          label: 'Secure Data',
                        ),
                        _TrustBadge(
                          icon: Icons.fingerprint,
                          label: 'Validated Identity',
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),
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

/// Trust badge shown in the footer of the register screen
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
