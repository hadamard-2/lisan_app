import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';

class FreeTextWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;

  const FreeTextWidget({
    super.key,
    required this.textEditingController,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: DesignColors.backgroundCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DesignColors.backgroundBorder),
      ),
      child: TextField(
        controller: textEditingController,
        maxLines: 10,
        style: const TextStyle(color: DesignColors.textPrimary, fontSize: 16),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: DesignColors.textTertiary, fontSize: 16),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(DesignSpacing.lg),
        ),
      ),
    );
  }
}
