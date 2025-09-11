import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isPrimary;
  final double height;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isPrimary = true,
    this.height = 56,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              backgroundColor ??
              (isPrimary ? DesignColors.primary : DesignColors.backgroundCard),
          foregroundColor:
              textColor ??
              (isPrimary ? DesignColors.backgroundDark : Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isPrimary && backgroundColor == null
                ? BorderSide.none
                : BorderSide(
                    color: borderColor ?? DesignColors.backgroundBorder,
                    width: 1,
                  ),
          ),
          elevation: isPrimary && backgroundColor == null ? 8 : 0,
          shadowColor: isPrimary && backgroundColor == null
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
                    textColor ??
                        (isPrimary
                            ? DesignColors.backgroundDark
                            : DesignColors.primary),
                  ),
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color:
                      textColor ??
                      (isPrimary ? DesignColors.backgroundDark : Colors.white),
                ),
              ),
      ),
    );
  }
}
