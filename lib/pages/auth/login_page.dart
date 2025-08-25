import 'package:flutter/material.dart';
import 'package:lisan_app/root_screen.dart';
import '../../widgets/auth/auth_header.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/auth/auth_button.dart';
import '../../widgets/auth/google_signin_button.dart';
import '../../widgets/auth/auth_divider.dart';
import '../../widgets/auth/base_auth_page.dart';
import 'signup_page.dart';

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
      setState(() => _isLoading = true);

      // Simulate login process
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() => _isLoading = false);
        // Navigate to home or show success
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Text('Login successful!'),
        //     backgroundColor: Color(0xFFF1CC06),
        //   ),
        // );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RootScreen()),
        );
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    // setState(() => _isGoogleLoading = true);

    // // Simulate Google sign-in process
    // await Future.delayed(const Duration(seconds: 2));

    // if (mounted) {
    //   setState(() => _isGoogleLoading = false);
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Google sign-in successful!'),
    //       backgroundColor: Color(0xFFF1CC06),
    //     ),
    //   );
    // }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => RootScreen()),
    );
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
            hintText: 'Enter your email',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
          ),

          const SizedBox(height: 20),

          // Password Field
          CustomTextField(
            controller: _passwordController,
            labelText: 'Password',
            hintText: 'Enter your password',
            prefixIcon: Icons.lock_outline,
            obscureText: !_isPasswordVisible,
            validator: _validatePassword,
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

          const SizedBox(height: 8),

          // Forgot Password Link
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
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
                  color: Color(0xFFF1CC06),
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
                style: TextStyle(color: Color(0xFF888888), fontSize: 14),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpPage()),
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
