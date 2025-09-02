import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';

enum PlaybackSpeed { slow, normal }

class VoiceBubbleWidget extends StatelessWidget {
  final String audioUrl;
  final PlaybackSpeed playbackSpeed;
  final void Function()? onPlaybackButtonPressed;
  final void Function()? onSpeedButtonPressed;

  const VoiceBubbleWidget({
    super.key,
    required this.audioUrl,
    required this.playbackSpeed,
    required this.onPlaybackButtonPressed,
    required this.onSpeedButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: Row(
        spacing: DesignSpacing.sm,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onPlaybackButtonPressed,
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: DesignColors.backgroundCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: DesignColors.backgroundBorder),
                ),
                child: Icon(
                  Icons.volume_up_rounded,
                  color: DesignColors.primary,
                  size: 36,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: onSpeedButtonPressed,
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                height: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: DesignColors.backgroundCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: DesignColors.backgroundBorder),
                ),
                child: Text(
                  playbackSpeed == PlaybackSpeed.normal ? '1x' : '0.75x',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
