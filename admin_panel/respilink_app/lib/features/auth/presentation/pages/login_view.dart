import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:respilink_app/core/theme/app_colors.dart';
import 'package:respilink_app/core/utils/snackbar_util.dart';
import 'package:respilink_app/features/auth/data/models/requests/login_request.dart';
import 'package:respilink_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:respilink_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:respilink_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:respilink_app/routes/router_strings.dart';
import 'package:respilink_app/shared/widgets/app_loader.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isCompact = screenWidth < 850;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          context.go(RouterStrings.dashboard);
        }
        if (state is AuthSuccess) {
          context.go(RouterStrings.dashboard);
          SnackbarUtil.showSnackbar(context, message: "Success");
        }
        if (state is AuthFailed) {
          SnackbarUtil.showSnackbar(context, message: state.message, isError: true);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: Row(
            children: [
              // Left Side: Brand Accent Hero Panel (Hidden on narrow smartphone/tablet views)
              if (!isCompact)
                Expanded(
                  flex: 5,
                  child: Container(
                    color: AppColors.primary, // Core brand deep teal tone
                    padding: const EdgeInsets.all(48),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Brand Identity Label Header
                        Row(
                          children: const [
                            Icon(Icons.local_hospital_rounded, color: Colors.white, size: 24),
                            SizedBox(width: 10),
                            Text(
                              'RespiLink Admin',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5),
                            ),
                          ],
                        ),
                        
                        // Center Marketing / Value Title Statement block
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [

                            Icon(Icons.local_hospital_rounded, color: Colors.white, size: 150),
                            
                            Text(
                              'Clinical Communication\n& Analytics Platform',
                              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, height: 1.3),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Secure access terminal for medical administration, credential verification matrix systems, and live broadcast delivery channels.',
                              style: TextStyle(fontSize: 14, color: Color(0xFFB3D1D1), height: 1.5),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        
              // Right Side: Minimalist Focus Sign-In Action Workspace Card View
              Expanded(
                flex: 4,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: isCompact ? 32 : 64, vertical: 48),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Responsive Layout Logo Header Token fallback identifier 
                            if (isCompact) ...[
                              Row(
                                children: const [
                                  Icon(Icons.local_hospital_rounded, color: AppColors.primary, size: 22),
                                  SizedBox(width: 8),
                                  Text('RespiLink Admin', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                                ],
                              ),
                              const SizedBox(height: 32),
                            ],
        
                            const Text('Sign In', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                            const SizedBox(height: 6),
                            const Text('Enter your enterprise management credentials.', style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
                            const SizedBox(height: 32),
        
                            // Username/Email Field Layout Block
                            const Text('Email Address', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(fontSize: 13, color: AppColors.textDark, fontWeight: FontWeight.w500),
                              decoration: _buildInputDecoration(hintText: 'name@respilink.org', prefixIcon: Icons.email_outlined),
                              validator: (value) {
                                if (value == null || value.isEmpty || !value.contains('@')) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
        
                            // Confidential Password Entry Field Layout Block
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Password', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                                // GestureDetector(
                                //   onTap: () {}, // Handled directly without extra physical buttons cluttering row vectors
                                //   child: const Text('Forgot password?', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary)),
                                // )
                              ],
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: const TextStyle(fontSize: 13, color: AppColors.textDark, fontWeight: FontWeight.w500),
                              decoration: _buildInputDecoration(
                                hintText: '••••••••••••', 
                                prefixIcon: Icons.lock_outline_rounded,
                                suffixIcon: IconButton(
                                  icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 16, color: AppColors.textMuted),
                                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                )
                              ),
                              validator: (value) {
                                if (value == null || value.length < 6) {
                                  return 'Password must contain atleast 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 32),
        
                            // Direct Execution Confirmation Action Trigger Button Frame
                            SizedBox(
                              width: double.infinity,
                              height: 46,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    // Trigger the login event in the AuthBloc
                                    context.read<AuthBloc>().add(LoginRequested(
                                      request: LoginRequest(
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text,
                                      ),
                                    ));
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  elevation: 0,
                                ),
                                child: state is AuthLoading ? AppLoader() : const Text(
                                  'Sign In', 
                                  style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }
    );
  }

  // Consistent Theme System Input Field Blueprint Layout Generator
  InputDecoration _buildInputDecoration({required String hintText, required IconData prefixIcon, Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.normal),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      prefixIcon: Icon(prefixIcon, size: 16, color: AppColors.textMuted),
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.borderLight, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }
}