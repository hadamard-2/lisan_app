import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';
import 'package:just_audio/just_audio.dart';

class VoiceChoicesWidget extends StatefulWidget {
  final List<Map<String, dynamic>> options;
  final int selectedOptionIndex;
  final Function(int) onOptionSelect;

  const VoiceChoicesWidget({
    super.key,
    required this.options,
    required this.selectedOptionIndex,
    required this.onOptionSelect,
  });

  @override
  State<VoiceChoicesWidget> createState() => _VoiceChoicesWidgetState();
}

class _VoiceChoicesWidgetState extends State<VoiceChoicesWidget> {
  late final List<int> waveformIds;
  late final AudioPlayer _audioPlayer;
  int? _currentlyPlayingIndex;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    waveformIds = widget.options.map((option) {
      final hash = option['id'].toString().hashCode.abs();
      return (hash % 7) + 1; // Ensures values 1-7
    }).toList();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAudio(int index) async {
    try {
      setState(() {
        _currentlyPlayingIndex = index;
      });

      final option = widget.options[index];
      final audioUrl = option['option_audio_url'];

      // await _audioPlayer.setUrl(audioUrl);
      await _audioPlayer.setAsset(audioUrl);

      await _audioPlayer.play();

      // Listen for completion
      _audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          if (mounted) {
            setState(() {
              _currentlyPlayingIndex = null;
            });
          }
        }
      });
    } catch (e) {
      debugPrint("Error playing audio: $e");
      if (mounted) {
        setState(() {
          _currentlyPlayingIndex = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.options.length,
      itemBuilder: (context, index) {
        final isPlaying = _currentlyPlayingIndex == index;

        return GestureDetector(
          onTap: () {
            widget.onOptionSelect(index);
            _playAudio(index);
          },
          child: Container(
            width: double.infinity,
            height: 60,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(DesignSpacing.md),
            margin: const EdgeInsets.only(bottom: DesignSpacing.sm),
            decoration: BoxDecoration(
              color: widget.selectedOptionIndex == index
                  ? DesignColors.primary.withAlpha((0.05 * 255).toInt())
                  : Colors.transparent,
              border: Border.all(
                color: widget.selectedOptionIndex == index
                    ? DesignColors.primary
                    : DesignColors.backgroundBorder,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8,
              children: [
                Icon(
                  Icons.volume_up_rounded,
                  color: DesignColors.primary,
                  size: 24,
                ),
                Image.asset(
                  'assets/images/waveform (${waveformIds[index]}).png',
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
