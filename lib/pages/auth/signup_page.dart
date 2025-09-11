import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';

import 'package:lisan_app/root_screen.dart';
import 'package:lisan_app/services/auth_service.dart';

import 'package:lisan_app/widgets/custom_text_field.dart';
import 'package:lisan_app/widgets/auth/auth_header.dart';
import 'package:lisan_app/widgets/custom_button.dart';
import 'package:lisan_app/widgets/auth/google_signin_button.dart';
import 'package:lisan_app/widgets/auth/auth_divider.dart';
import 'package:lisan_app/widgets/auth/base_auth_page.dart';

import 'package:lisan_app/pages/auth/login_page.dart';

class SignUpPage extends BaseAuthPage {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends BaseAuthPageState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _passwordsMatch = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Form validation
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    // Allow international characters, letters, spaces, hyphens, and apostrophes
    if (!RegExp(r"^[\p{L}\s\-']+$", unicode: true).hasMatch(value.trim())) {
      return 'Name can only contain letters, spaces, hyphens, and apostrophes';
    }
    return null;
  }

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

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _onPasswordChanged(String value) {
    setState(() {
      _passwordsMatch =
          _confirmPasswordController.text.isEmpty ||
          _confirmPasswordController.text == value;
    });
  }

  void _onConfirmPasswordChanged(String value) {
    setState(() {
      _passwordsMatch = value == _passwordController.text;
    });
  }

  Color _getConfirmPasswordBorderColor() {
    if (_confirmPasswordController.text.isEmpty) {
      return DesignColors.backgroundBorder;
    }
    return _passwordsMatch ? DesignColors.success : DesignColors.error;
  }

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final result = await AuthService.signUp(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
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
                title: const Text('Sign Up Error'),
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
              title: const Text('Sign Up Error'),
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

  Future<void> _handleGoogleSignUp() async {
    setState(() => _isGoogleLoading = true);

    // Simulate Google sign-up process
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
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // App Logo and Title
          const AuthHeader(),

          const SizedBox(height: 40),

          // Google Sign Up Button
          GoogleSignInButton(
            onPressed: _isLoading ? null : _handleGoogleSignUp,
            isLoading: _isGoogleLoading,
          ),

          const SizedBox(height: 32),

          // Divider
          const AuthDivider(),

          const SizedBox(height: 32),

          // Name Field
          CustomTextField(
            controller: _nameController,
            labelText: 'Full Name',
            prefixIcon: Icons.person_outline,
            keyboardType: TextInputType.name,
            validator: _validateName,
            enabled: !_isLoading,
          ),

          const SizedBox(height: 20),

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
            onChanged: _onPasswordChanged,
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

          const SizedBox(height: 20),

          // Confirm Password Field
          CustomTextField(
            controller: _confirmPasswordController,
            labelText: 'Confirm Password',
            prefixIcon: Icons.lock_outline,
            obscureText: !_isConfirmPasswordVisible,
            validator: _validateConfirmPassword,
            onChanged: _onConfirmPasswordChanged,
            borderColor: _getConfirmPasswordBorderColor(),
            enabled: !_isLoading,
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_confirmPasswordController.text.isNotEmpty)
                  Icon(
                    _passwordsMatch ? Icons.check_circle : Icons.error,
                    color: _passwordsMatch
                        ? DesignColors.success
                        : DesignColors.error,
                    size: 20,
                  ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    _isConfirmPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: _isLoading
                      ? null
                      : () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                          });
                        },
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Sign Up Button
          CustomButton(
            text: 'Create Account',
            onPressed: _handleSignUp,
            isLoading: _isLoading,
          ),

          const SizedBox(height: 32),

          // Login Link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Already have an account? ",
                style: TextStyle(
                  color: DesignColors.textTertiary,
                  fontSize: 14,
                ),
              ),
              TextButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: DesignColors.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
