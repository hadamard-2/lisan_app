import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';

class PictureChoicesWidget extends StatelessWidget {
  final List<Map<String, dynamic>> options;
  final int selectedOptionIndex;
  final Function(int) onOptionSelect;

  const PictureChoicesWidget({
    super.key,
    required this.options,
    required this.selectedOptionIndex,
    required this.onOptionSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: DesignSpacing.md,
        mainAxisSpacing: DesignSpacing.md,
        childAspectRatio: 0.8,
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final option = options[index];
        final isSelected = selectedOptionIndex == index;

        return GestureDetector(
          onTap: () => onOptionSelect(index),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? DesignColors.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
              border: Border.all(
                color: isSelected
                    ? DesignColors.primary
                    : DesignColors.backgroundBorder,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: DesignSpacing.sm,
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(DesignSpacing.md),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        // child: Image.network(
                        child: Image.asset(
                          option['image_url'] ?? '',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: double.infinity,
                              color: DesignColors.backgroundBorder.withValues(
                                alpha: 0.3,
                              ),
                              child: Icon(
                                Icons.image_not_supported,
                                color: DesignColors.textSecondary,
                                size: 40,
                              ),
                            );
                          },
                          // loadingBuilder: (context, child, loadingProgress) {
                          //   if (loadingProgress == null) return child;
                          //   return Container(
                          //     width: double.infinity,
                          //     color: DesignColors.backgroundBorder.withValues(
                          //       alpha: 0.3,
                          //     ),
                          //     child: Center(
                          //       child: CircularProgressIndicator(
                          //         color: DesignColors.primary,
                          //         strokeWidth: 2,
                          //       ),
                          //     ),
                          //   );
                          // },
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignSpacing.sm,
                      vertical: DesignSpacing.xs,
                    ),
                    child: Text(
                      option['label'] ?? '',
                      style: TextStyle(
                        color: DesignColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
