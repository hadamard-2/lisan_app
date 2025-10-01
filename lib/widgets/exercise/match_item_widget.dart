import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lisan_app/design/theme.dart';
import 'package:lisan_app/models/match_pairs_exercise_data.dart';
import 'package:lisan_app/utils/text_utils.dart';

enum MatchItemState { normal, selected, matched, error }

class MatchItemWidget extends StatefulWidget {
  final MatchItem item;
  final MatchItemState state;
  final VoidCallback onTap;
  final bool isAudioType;

  const MatchItemWidget({
    super.key,
    required this.item,
    required this.state,
    required this.onTap,
    this.isAudioType = false,
  });

  @override
  State<MatchItemWidget> createState() => _MatchItemWidgetState();
}

class _MatchItemWidgetState extends State<MatchItemWidget>
    with TickerProviderStateMixin {
  late AnimationController _errorController;
  late AnimationController _fadeController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _fadeAnimation;

  AudioPlayer? _audioPlayer;
  bool _isPlaying = false;
  late final int waveformId;

  @override
  void initState() {
    super.initState();

    _errorController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
      value: 1.0,
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _errorController, curve: Curves.elasticIn),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    if (widget.isAudioType) {
      _audioPlayer = AudioPlayer();
      // Generate waveform ID based on item ID or audio URL
      final hash = (widget.item.id).hashCode.abs();
      waveformId = (hash % 7) + 1; // Ensures values 1-7
    }
  }

  @override
  void dispose() {
    _errorController.dispose();
    _fadeController.dispose();
    _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(MatchItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.state == MatchItemState.error &&
        oldWidget.state != MatchItemState.error) {
      _errorController.forward().then((_) => _errorController.reverse());
    }

    if (widget.state == MatchItemState.matched &&
        oldWidget.state != MatchItemState.matched) {
      _fadeController.reverse();
    }
  }

  Future<void> _playAudio() async {
    if (!widget.isAudioType ||
        widget.item.audioUrl == null ||
        _audioPlayer == null) {
      return;
    }

    try {
      setState(() {
        _isPlaying = true;
      });

      await _audioPlayer!.setAsset(widget.item.audioUrl!);
      await _audioPlayer!.play();

      _audioPlayer!.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          if (mounted) {
            setState(() {
              _isPlaying = false;
            });
          }
        }
      });
    } catch (e) {
      debugPrint("Error playing audio: $e");
      setState(() {
        _isPlaying = false;
      });
    }
  }

  Color _getBorderColor() {
    switch (widget.state) {
      case MatchItemState.selected:
        return DesignColors.primary;
      case MatchItemState.error:
        return DesignColors.error;
      case MatchItemState.matched:
      case MatchItemState.normal:
        return DesignColors.backgroundBorder;
    }
  }

  Color _getBackgroundColor() {
    switch (widget.state) {
      case MatchItemState.selected:
        return DesignColors.primary.withValues(alpha: 0.1);
      case MatchItemState.error:
        return DesignColors.error.withValues(alpha: 0.1);
      case MatchItemState.matched:
      case MatchItemState.normal:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: AnimatedBuilder(
        animation: _shakeAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_shakeAnimation.value, 0),
            child: GestureDetector(
              onTap: () {
                if (widget.isAudioType) {
                  _playAudio();
                }
                widget.onTap();
              },
              child: Container(
                width: double.infinity,
                height: 60,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(DesignSpacing.md),
                margin: const EdgeInsets.only(bottom: DesignSpacing.sm),
                decoration: BoxDecoration(
                  color: _getBackgroundColor(),
                  border: Border.all(color: _getBorderColor(), width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: widget.isAudioType
                    ? _buildAudioContent()
                    : _buildTextContent(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextContent() {
    return Text(
      widget.item.text!,
      style:
          (TextUtils.isAmharic(widget.item.text!)
                  ? GoogleFonts.notoSansEthiopic()
                  : GoogleFonts.rubik())
              .copyWith(color: DesignColors.textPrimary, fontSize: 16),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildAudioContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 8,
      children: [
        Icon(Icons.volume_up_rounded, color: DesignColors.primary, size: 24),
        Image.asset(
          'assets/images/waveform ($waveformId).png',
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}
