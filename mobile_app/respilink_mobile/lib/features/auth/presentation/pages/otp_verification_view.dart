import 'dart:async';

import 'package:respilink_mobile/core/extensions/string_extensions.dart';
import 'package:respilink_mobile/core/utils/handlers.dart';
import 'package:respilink_mobile/features/auth/data/models/requests/otp_request.dart';
import 'package:respilink_mobile/features/auth/data/models/requests/resent_otp_request.dart';
import 'package:respilink_mobile/features/auth/domain/models/user_model.dart';
import 'package:respilink_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:respilink_mobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:respilink_mobile/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../exports.dart';
import '../../../../shared/widgets/app_loader.dart';

class OtpVerificationView extends StatefulWidget {
  final String email;
  final String purpose;

  const OtpVerificationView({
    super.key,
    required this.email,
    required this.purpose,
  });

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  Timer? _timer;
  int _start = 30;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    if(!mounted) return;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();

    if (!mounted) return;
    setState(() {
      _start = 30;
      _canResend = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_start == 0) {
        setState(() {
          _canResend = true;
          timer.cancel();
        });
      } else {
        setState(() => _start--);
      }
    });
  }

  String get _otpCode => _controllers.map((e) => e.text).join();

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is ResendOtpSuccess) {

          for (var controller in _controllers) {
            controller.clear();
          }
          _startTimer();
          if (_focusNodes.isNotEmpty) {
            _focusNodes[0].requestFocus();
          }
          _canResend = true;
          SnackbarUtil.showSnackbar(message: state.message);

        } else if (state is OptVerifiedSuccess) {
          _timer?.cancel();
          
          if(widget.purpose == "reset") {
            Handlers.onOtpVerifiedReset(widget.email, _otpCode);
          } else {
            Handlers.onOtpVerified(state.data as Doctor?);
          }

        } else if (state is ResendOtpFailure) {
          SnackbarUtil.showSnackbar(message: state.message, isError: true);
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
              label: 'Verification',
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
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
                            Icons.shield_outlined,
                            color: AppColors.primary,
                            size: 26.r,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        AppText.large(
                          label: 'Secure Entry',
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: 6.h),
                        AppText.small(
                          label: "We've sent a 6-digit verification code to",
                          color: AppColors.grey,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 2.h),
                        AppText.small(
                          label: widget.email.maskEmail(),
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  /// OTP card
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.fieldColor,
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            6,
                            (index) => Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.w),
                              child: _otpBox(index),
                            ),
                          ),
                        ),

                        SizedBox(height: 20.h),

                        /// Verify Button
                        state is AuthLoading
                            ? const AppLoader()
                            : AppButton.filled(
                                label: 'Verify Account',
                                onTap: () {
                                  if (_otpCode.length == 6) {
                                    final request = OtpRequest(
                                      email: widget.email,
                                      otp: _otpCode,
                                      purpose: widget.purpose,
                                    );
                                    BlocProvider.of<AuthBloc>(context).add(
                                      VerifyOtpRequested(request: request),
                                    );
                                  }
                                },
                              ),

                        SizedBox(height: 16.h),

                        /// Resend Timer
                        Center(
                          child: _canResend
                              ? GestureDetector(
                                  onTap: () {
                                    final request = ResendOtpRequest(
                                      email: widget.email,
                                      purpose: widget.purpose,
                                    );
                                    BlocProvider.of<AuthBloc>(context).add(
                                      ResendOtpRequested(request: request),
                                    );
                                  },
                                  child: RichText(
                                    text: TextSpan(
                                      text: "Didn't receive code? ",
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontFamily: AppConstants.fontFamily,
                                        color: AppColors.secondary,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'Resend Now',
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontFamily:
                                                AppConstants.fontFamily,
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : AppText.small(
                                  label:
                                      'Resend code in 00:${_start.toString().padLeft(2, '0')}',
                                  color: AppColors.secondary,
                                ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  /// Secure verification badge
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.fieldColor,
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.gpp_good_outlined,
                          color: AppColors.primary,
                          size: 22.r,
                        ),
                        SizedBox(height: 6.h),
                        AppText.small(
                          label: 'SECURE VERIFICATION BY RESPILINK',
                          color: AppColors.grey,
                          fontWeight: FontWeight.w600,
                          fontSize: 10.sp,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text:
                            'This verification step ensures your clinical data remains protected. Need help? ',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: AppConstants.fontFamily,
                          color: AppColors.tertiary,
                        ),
                        children: [
                          TextSpan(
                            text: 'Contact Support',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: AppConstants.fontFamily,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _otpBox(int index) {
    return SizedBox(
      // Reduced width from 68.w to ~45.w to fit 6 boxes on small screens
      width: 44.w,
      height: 55.w,
      child: TextFormField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        autofocus: true,
        onChanged: (value) {
          if (value.length == 1) {
            if (index < 5) {
              _focusNodes[index + 1].requestFocus();
            } else {
              // Last field (6th digit)
              _focusNodes[index].unfocus(); // removes focus
              FocusScope.of(context).unfocus(); // closes keyboard
            }
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
        // Center alignment as requested
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          fontFamily: AppConstants.fontFamily,
          // Ensure text color adapts to Theme
          color: Theme.of(context).colorScheme.onSurface,
        ),
        keyboardType: TextInputType.number,
        // Prevents the keyboard from showing "Done" on every box, use "Next" instead
        textInputAction: index < 5
            ? TextInputAction.next
            : TextInputAction.done,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          // Important for perfect vertical centering
          filled: true,
          // Adapts to Dark/Light theme via colorScheme
          fillColor: AppColors.primary.withValues(alpha: 0.08),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(
              color: AppColors.primary.withValues(alpha: 0.5),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(
              color: AppColors.primary,
              width: 2,
            ),
          ),
        ),
        cursorColor:AppColors.primary,
      ),
    );
  }
}
