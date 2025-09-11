import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';

import 'package:lisan_app/root_screen.dart';
import 'package:lisan_app/services/auth_service.dart';

import 'package:lisan_app/widgets/custom_text_field.dart';
import 'package:lisan_app/widgets/auth/auth_header.dart';
import 'package:lisan_app/widgets/auth/auth_button.dart';
import 'package:lisan_app/widgets/auth/google_signin_button.dart';
import 'package:lisan_app/widgets/auth/auth_divider.dart';
import 'package:lisan_app/widgets/auth/base_auth_page.dart';

import 'Package:lisan_app/pages/auth/signup_page.dart';

class LoginPage extends BaseAuthPage {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends BaseAuthPageState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Form validation
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // Login handlers
  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final result = await AuthService.signIn(
          _emailController.text.trim(),
          _passwordController.text,
        );

        if (mounted) {
          setState(() => _isLoading = false);

          if (result.success) {
            // Navigate to home screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => RootScreen()),
            );
          } else {
            // Show error dialog
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Login Error'),
                content: Text(result.errorMessage ?? 'An error occurred'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          // Show error dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Login Error'),
              content: const Text(
                'An unexpected error occurred. Please try again.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isGoogleLoading = true);

    // Simulate Google sign-in process
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isGoogleLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Google sign-up not available yet!',
            style: TextStyle(color: DesignColors.textPrimary),
          ),
          backgroundColor: DesignColors.backgroundCard,
        ),
      );
    }

    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => RootScreen()),
    // );
  }

  @override
  Widget buildContent(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // App Logo and Title
              const AuthHeader(),
        
              const SizedBox(height: 40),
        
              // Google Sign In Button
              GoogleSignInButton(
                onPressed: _handleGoogleSignIn,
                isLoading: _isGoogleLoading,
              ),
        
              const SizedBox(height: 32),
        
              // Divider
              const AuthDivider(),
        
              const SizedBox(height: 32),
        
              // Email Field
              CustomTextField(
                controller: _emailController,
                labelText: 'Email',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
                enabled: !_isLoading,
              ),
        
              const SizedBox(height: 20),
        
              // Password Field
              CustomTextField(
                controller: _passwordController,
                labelText: 'Password',
                prefixIcon: Icons.lock_outline,
                obscureText: !_isPasswordVisible,
                validator: _validatePassword,
                enabled: !_isLoading,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: _isLoading
                      ? null
                      : () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                ),
              ),
        
              const SizedBox(height: 8),
        
              // Forgot Password Link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          // Navigate to forgot password page
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Forgot password feature coming soon!'),
                            ),
                          );
                        },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: DesignColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
        
              const SizedBox(height: 8),
        
              // Login Button
              AuthButton(
                text: 'Login',
                onPressed: _handleLogin,
                isLoading: _isLoading,
              ),
        
              const SizedBox(height: 32),
        
              // Sign Up Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      color: DesignColors.textTertiary,
                      fontSize: 14,
                    ),
                  ),
                  TextButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpPage(),
                              ),
                            );
                          },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: DesignColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
