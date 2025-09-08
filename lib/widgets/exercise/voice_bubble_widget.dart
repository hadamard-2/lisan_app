import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lisan_app/design/theme.dart';

enum PlaybackSpeed { slow, normal }

class VoiceBubbleWidget extends StatefulWidget {
  final String audioUrl;
  final PlaybackSpeed playbackSpeed;
  final void Function()? onSpeedButtonPressed;

  const VoiceBubbleWidget({
    super.key,
    required this.audioUrl,
    required this.playbackSpeed,
    required this.onSpeedButtonPressed,
  });

  @override
  State<VoiceBubbleWidget> createState() => _VoiceBubbleWidgetState();
}

class _VoiceBubbleWidgetState extends State<VoiceBubbleWidget> {
  late AudioPlayer _player;
  bool _isLoading = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _playAudio();

    // Listen to player state changes
    _player.playerStateStream.listen((playerState) {
      setState(() {
        _isPlaying = playerState.playing;
        _isLoading =
            playerState.processingState == ProcessingState.loading ||
            playerState.processingState == ProcessingState.buffering;
      });
    });

    // Listen for completion to reset state
    _player.positionStream.listen((position) {
      if (_player.duration != null && position >= _player.duration!) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _playAudio() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await _player.setAsset(widget.audioUrl);
      await _player.play();
    } catch (e) {
      debugPrint("Error loading audio: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildPlaybackButton() {
    if (_isLoading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(DesignColors.primary),
        ),
      );
    }

    return Icon(
      _isPlaying ? Icons.volume_up_rounded : Icons.play_arrow_rounded,
      color: DesignColors.primary,
      size: 42,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        spacing: DesignSpacing.sm,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _isLoading || _isPlaying ? null : _playAudio,
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: DesignColors.backgroundCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: DesignColors.backgroundBorder),
                ),
                child: _buildPlaybackButton(),
              ),
            ),
          ),
          GestureDetector(
            // Disable speed button during playback
            onTap: _isLoading || _isPlaying
                ? null
                : widget.onSpeedButtonPressed,
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                height: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _isLoading || _isPlaying
                      ? DesignColors.backgroundCard.withValues(alpha: 0.5)
                      : DesignColors.backgroundCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: DesignColors.backgroundBorder),
                ),
                child: Text(
                  widget.playbackSpeed == PlaybackSpeed.normal ? '1x' : '0.75x',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: _isLoading || _isPlaying
                        ? DesignColors.textPrimary.withValues(alpha: 0.5)
                        : DesignColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
