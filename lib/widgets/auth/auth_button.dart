import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isPrimary;
  final double height;

  const AuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isPrimary = true,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary
              ? DesignColors.primary
              : DesignColors.backgroundCard,
          foregroundColor: isPrimary
              ? DesignColors.backgroundDark
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isPrimary
                ? BorderSide.none
                : const BorderSide(
                    color: DesignColors.backgroundBorder,
                    width: 1,
                  ),
          ),
          elevation: isPrimary ? 8 : 0,
          shadowColor: isPrimary
              ? DesignColors.primary.withValues(alpha: 0.3)
              : Colors.transparent,
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isPrimary
                        ? DesignColors.backgroundDark
                        : DesignColors.primary,
                  ),
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: isPrimary ? DesignColors.backgroundDark : Colors.white,
                ),
              ),
      ),
    );
  }
}
