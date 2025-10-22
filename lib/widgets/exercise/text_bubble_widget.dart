import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lisan_app/design/theme.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lisan_app/utils/text_utils.dart';

class TextBubbleWidget extends StatefulWidget {
  final String text;
  final String? audioUrl;

  const TextBubbleWidget({super.key, required this.text, this.audioUrl});

  @override
  State<TextBubbleWidget> createState() => _TextBubbleWidgetState();
}

class _TextBubbleWidgetState extends State<TextBubbleWidget> {
  late AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    if (widget.audioUrl != null) _init();
  }

  Future<void> _init() async {
    try {
      // await _player.setUrl(widget.audioUrl!);
      await _player.setAsset(widget.audioUrl!);
      _player.play();
    } catch (e) {
      debugPrint("Error loading audio: $e");
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DesignSpacing.md),
      decoration: BoxDecoration(
        color: DesignColors.backgroundCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: DesignColors.backgroundBorder),
      ),
      child: Row(
        spacing: DesignSpacing.sm,
        children: [
          if (widget.audioUrl != null)
            IconButton(
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              onPressed: () async => await _init(),
              icon: Icon(
                Icons.volume_up_rounded,
                color: DesignColors.primary,
                size: 28,
              ),
            ),
          Expanded(
            child: Text(
              widget.text,
              style:
                  (TextUtils.isAmharic(widget.text)
                          ? GoogleFonts.notoSansEthiopic()
                          : GoogleFonts.rubik())
                      .copyWith(color: DesignColors.textPrimary, fontSize: 17),
            ),
          ),
        ],
      ),
    );
  }
}
