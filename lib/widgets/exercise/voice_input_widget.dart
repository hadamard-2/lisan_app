import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class VoiceInputWidget extends StatefulWidget {
  final Function(String audioFilePath) onRecordingComplete;

  const VoiceInputWidget({super.key, required this.onRecordingComplete});

  @override
  State<VoiceInputWidget> createState() => _VoiceInputWidgetState();
}

class _VoiceInputWidgetState extends State<VoiceInputWidget> {
  static const int maxRecordingDurationSeconds = 8;

  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  int _recordingDuration = 0;

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (_isRecording) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    // Check connectivity
    final connectivityResult = await Connectivity().checkConnectivity();
    if (!connectivityResult.contains(ConnectivityResult.mobile) &&
        !connectivityResult.contains(ConnectivityResult.wifi)) {
      _showOfflineDialog();
      return;
    }

    // Check and request permission
    if (await _audioRecorder.hasPermission()) {
      final tempDir = await getTemporaryDirectory();
      final audioPath =
          '${tempDir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.wav';

      await _audioRecorder.start(
        RecordConfig(
          encoder: AudioEncoder.wav,
          sampleRate: 44100,
          bitRate: 128000,
        ),
        path: audioPath,
      );

      setState(() {
        _isRecording = true;
        _recordingDuration = 0;
      });

      _startTimer();
    }
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_isRecording && mounted) {
        setState(() {
          _recordingDuration++;
        });

        if (_recordingDuration >= maxRecordingDurationSeconds) {
          _stopRecording();
        } else {
          _startTimer();
        }
      }
    });
  }

  Future<void> _stopRecording() async {
    final audioPath = await _audioRecorder.stop();

    setState(() {
      _isRecording = false;
      _recordingDuration = 0;
    });

    if (audioPath != null) {
      widget.onRecordingComplete(audioPath);
    }
  }

  void _showOfflineDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('No Internet Connection'),
        content: const Text(
          'You need an internet connection to complete speaking exercises.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: DesignSpacing.xl),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: _isRecording
                ? DesignColors.primary
                : DesignColors.backgroundBorder,
          ),
          borderRadius: BorderRadius.circular(8),
          color: _isRecording
              ? DesignColors.primary.withAlpha((0.1 * 255).toInt())
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: DesignSpacing.sm,
          children: [
            Icon(
              _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
              color: DesignColors.primary,
            ),
            Text(
              _isRecording
                  ? 'RECORDING... ${maxRecordingDurationSeconds - _recordingDuration}s'
                  : 'TAP TO SPEAK',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: DesignColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
