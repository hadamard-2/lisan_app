import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: DesignColors.backgroundCard,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(
              color: DesignColors.backgroundBorder,
              width: 1,
            ),
          ),
          elevation: 0,
        ),
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    DesignColors.primary,
                  ),
                ),
              )
            : Image.asset(
                'assets/images/google_logo.png',
                width: 20,
                height: 20,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.g_mobiledata, color: Colors.white),
              ),
        label: Text(
          isLoading ? 'Signing in...' : 'Continue with Google',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
