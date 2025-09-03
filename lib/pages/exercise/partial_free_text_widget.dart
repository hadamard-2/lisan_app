import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lisan_app/design/theme.dart';

// NOTE - this widget currently only entertains text with a single blank
class PartialFreeTextWidget extends StatelessWidget {
  final String partialText;
  final TextEditingController textEditingController;

  const PartialFreeTextWidget({
    super.key,
    required this.partialText,
    required this.textEditingController,
  });

  List<Widget> _buildSentenceWithInlineBlank() {
    if (!partialText.contains('____')) {
      throw Exception('Could not find blanks when building sentence widgets');
    }

    final parts = partialText.split('____');
    final widgets = <Widget>[];

    for (int i = 0; i < parts.length; i++) {
      // Add text part before the blank
      if (parts[i].isNotEmpty) {
        widgets.add(
          Text(
            parts[i],
            style: GoogleFonts.notoSansEthiopic(
              color: DesignColors.textPrimary,
              fontSize: 16,
            ),
          ),
        );
      }

      // Add text field for the blank (except after the last part)
      if (i < parts.length - 1) {
        widgets.add(
          SizedBox(
            width: 80, // Adjustable width
            child: TextField(
              controller: textEditingController,
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSansEthiopic(
                color: DesignColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(top: 12, bottom: 10),
                isDense: true,
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: DesignColors.backgroundBorder),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: DesignColors.primary),
                ),
              ),
            ),
          ),
        );
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(DesignSpacing.md),
        decoration: BoxDecoration(
          color: DesignColors.backgroundCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: DesignColors.backgroundBorder),
        ),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          children: _buildSentenceWithInlineBlank(),
        ),
      ),
    );
  }
}
