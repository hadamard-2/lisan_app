import 'package:flutter/material.dart';
import 'package:lisan_app/pages/home_page.dart';
import '../../widgets/auth/auth_header.dart';
import '../../widgets/auth/auth_text_field.dart';
import '../../widgets/auth/auth_button.dart';
import '../../widgets/auth/google_signin_button.dart';
import '../../widgets/auth/auth_divider.dart';
import '../../widgets/auth/base_auth_page.dart';

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
      return const Color(0xFF2A2D33);
    }
    return _passwordsMatch ? Colors.green : Colors.red;
  }

  // Sign up handlers
  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulate sign up process
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() => _isLoading = false);
        // Navigate to home or show success
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Text('Account created successfully!'),
        //     backgroundColor: Color(0xFFF1CC06),
        //   ),
        // );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
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
          content: Text('Google sign-up successful!'),
          backgroundColor: Color(0xFFF1CC06),
        ),
      );
    }
  }

  @override
  Widget buildContent(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10),

          // App Logo and Title
          const AuthHeader(),

          const SizedBox(height: 40),

          // Google Sign Up Button
          GoogleSignInButton(
            onPressed: _handleGoogleSignUp,
            isLoading: _isGoogleLoading,
          ),

          const SizedBox(height: 32),

          // Divider
          const AuthDivider(),

          const SizedBox(height: 32),

          // Name Field
          AuthTextField(
            controller: _nameController,
            labelText: 'Full Name',
            hintText: 'Enter your full name',
            prefixIcon: Icons.person_outline,
            keyboardType: TextInputType.name,
            validator: _validateName,
          ),

          const SizedBox(height: 20),

          // Email Field
          AuthTextField(
            controller: _emailController,
            labelText: 'Email',
            hintText: 'Enter your email',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
          ),

          const SizedBox(height: 20),

          // Password Field
          AuthTextField(
            controller: _passwordController,
            labelText: 'Password',
            hintText: 'Enter your password',
            prefixIcon: Icons.lock_outline,
            obscureText: !_isPasswordVisible,
            validator: _validatePassword,
            onChanged: _onPasswordChanged,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),

          const SizedBox(height: 20),

          // Confirm Password Field
          AuthTextField(
            controller: _confirmPasswordController,
            labelText: 'Confirm Password',
            hintText: 'Confirm your password',
            prefixIcon: Icons.lock_outline,
            obscureText: !_isConfirmPasswordVisible,
            validator: _validateConfirmPassword,
            onChanged: _onConfirmPasswordChanged,
            borderColor: _getConfirmPasswordBorderColor(),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_confirmPasswordController.text.isNotEmpty)
                  Icon(
                    _passwordsMatch ? Icons.check_circle : Icons.error,
                    color: _passwordsMatch ? Colors.green : Colors.red,
                    size: 20,
                  ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    _isConfirmPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Sign Up Button
          AuthButton(
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
                style: TextStyle(color: Color(0xFF888888), fontSize: 14),
              ),
              TextButton(
                onPressed: () {
                  // Navigate back to login page
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: Color(0xFFF1CC06),
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
