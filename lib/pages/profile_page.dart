import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';
import 'package:lisan_app/pages/auth/login_page.dart';
import 'package:lisan_app/services/auth_service.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full Name is required';
    }
    if (value.trim().length < 2) {
      return 'Full Name must be at least 2 characters';
    }
    if (!RegExp(r"^[\p{L}\s\-']+$", unicode: true).hasMatch(value.trim())) {
      return 'Full Name can only contain letters, spaces, hyphens, and apostrophes';
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

  Future<void> _handleSave() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated!'),
            backgroundColor: DesignColors.primary,
          ),
        );
      }
    }
  }

  Future<void> _handleLogout() async {
    // Show confirmation dialog
    bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: DesignColors.backgroundCard,
          title: const Text('Logout', style: TextStyle(color: Colors.white)),
          content: const Text(
            'Are you sure you want to log out?',
            style: TextStyle(color: DesignColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: DesignColors.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Log Out',
                style: TextStyle(color: DesignColors.primary),
              ),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      // Handle logout logic here
      AuthService.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('Logged out successfully'),
      //     backgroundColor: DesignColors.success,
      //   ),
      // );
    }
  }

  Future<void> _handleDeleteAccount() async {
    // Show confirmation dialog
    bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: DesignColors.backgroundCard,
          title: const Text(
            'Delete Account',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'This action cannot be undone. Are you sure you want to delete your account?',
            style: TextStyle(color: DesignColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: DesignColors.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Delete',
                style: TextStyle(color: DesignColors.error),
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      // Handle account deletion logic here
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => LoginPage()),
      // );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account deletion initiated'),
          backgroundColor: DesignColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // default = true
      backgroundColor: DesignColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_rounded, size: 32),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // push content up by the height of the keyboard
          padding: EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 16,
          ).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom + 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Name Field
                CustomTextField(
                  controller: _fullNameController,
                  labelText: 'Full Name',
                  prefixIcon: Icons.person_outline,
                  keyboardType: TextInputType.name,
                  validator: _validateName,
                ),
                const SizedBox(height: 12),

                // Email Field
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),
                const SizedBox(height: 12),

                // Password Field
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  prefixIcon: Icons.lock_outline,
                  obscureText: !_isPasswordVisible,
                  validator: _validatePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // Save Button
                CustomButton(
                  text: 'Save Changes',
                  onPressed: _handleSave,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 64),
                CustomButton(
                  text: 'Log Out',
                  onPressed: _handleLogout,
                  isPrimary: false,
                  backgroundColor: DesignColors.backgroundCard,
                  textColor: DesignColors.textPrimary,
                ),
                const SizedBox(height: 12),
                CustomButton(
                  text: 'Delete Account',
                  onPressed: _handleDeleteAccount,
                  isPrimary: false,
                  backgroundColor: DesignColors.error.withValues(alpha: 0.1),
                  borderColor: DesignColors.error.withValues(alpha: 0.2),
                  textColor: DesignColors.error,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
