import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart' as ml;
import 'package:lisan_app/design/theme.dart';

class TraceFidelExerciseContent extends StatefulWidget {
  const TraceFidelExerciseContent({super.key});

  @override
  State<TraceFidelExerciseContent> createState() =>
      _TraceFidelExerciseContentState();
}

class _TraceFidelExerciseContentState extends State<TraceFidelExerciseContent> {
  late ml.DigitalInkRecognizer _recognizer;
  ml.DigitalInkRecognizerModelManager? _modelManager;

  // Visual strokes for rendering
  final List<List<Offset>> _strokes = [];

  // ML Kit strokes - each stroke is a separate list of points
  final List<List<ml.StrokePoint>> _allStrokes = [];
  List<ml.StrokePoint> _currentStroke = [];

  final String _targetLetter = 'ቹ';
  bool? _isCorrect;
  bool _isProcessing = false;

  // Model download state
  bool _isModelDownloaded = false;
  bool _isDownloadingModel = false;
  String _modelStatus = 'Checking model...';

  @override
  void initState() {
    super.initState();
    _initializeRecognizer();
  }

  Future<void> _initializeRecognizer() async {
    try {
      // Initialize recognizer
      _recognizer = ml.DigitalInkRecognizer(languageCode: 'am');

      // Initialize model manager
      _modelManager = ml.DigitalInkRecognizerModelManager();

      // Check if model is already downloaded
      await _checkAndDownloadModel();
    } catch (e) {
      setState(() {
        _modelStatus = 'Error initializing: $e';
      });
    }
  }

  Future<void> _checkAndDownloadModel() async {
    if (_modelManager == null) return;

    try {
      // Check if the Amharic model is downloaded
      final isDownloaded = await _modelManager!.isModelDownloaded('am');

      if (isDownloaded) {
        setState(() {
          _isModelDownloaded = true;
          _modelStatus = 'Model ready!';
        });
      } else {
        // Model not downloaded, start download
        await _downloadModel();
      }
    } catch (e) {
      setState(() {
        _modelStatus = 'Error checking model: $e';
      });
    }
  }

  Future<void> _downloadModel() async {
    if (_modelManager == null) return;

    setState(() {
      _isDownloadingModel = true;
      _modelStatus = 'Downloading Amharic model...';
    });

    try {
      final success = await _modelManager!.downloadModel('am');

      setState(() {
        _isDownloadingModel = false;
        if (success) {
          _isModelDownloaded = true;
          _modelStatus = 'Model downloaded successfully!';
        } else {
          _modelStatus =
              'Failed to download model. Check your internet connection.';
        }
      });
    } catch (e) {
      setState(() {
        _isDownloadingModel = false;
        _modelStatus = 'Download error: $e';
      });
    }
  }

  @override
  void dispose() {
    _recognizer.close();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    if (!_isModelDownloaded) return;

    setState(() {
      // Start a new stroke for visual rendering
      _strokes.add([details.localPosition]);

      // Start a new stroke for ML Kit
      _currentStroke = [];
      final point = ml.StrokePoint(
        x: details.localPosition.dx,
        y: details.localPosition.dy,
        t: DateTime.now().millisecondsSinceEpoch,
      );
      _currentStroke.add(point);
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!_isModelDownloaded) return;

    setState(() {
      // Add point to the current visual stroke
      if (_strokes.isNotEmpty) {
        _strokes.last.add(details.localPosition);
      }

      // Add point to current ML Kit stroke
      final point = ml.StrokePoint(
        x: details.localPosition.dx,
        y: details.localPosition.dy,
        t: DateTime.now().millisecondsSinceEpoch,
      );
      _currentStroke.add(point);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (!_isModelDownloaded) return;

    // Finalize the current stroke and add it to the list of all strokes
    if (_currentStroke.isNotEmpty) {
      _allStrokes.add(List.from(_currentStroke));
      _currentStroke = [];
    }
  }

  Future<void> _recognizeHandwriting() async {
    if (_allStrokes.isEmpty || !_isModelDownloaded) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final ink = ml.Ink();

      // Create a separate Stroke object for each stroke sequence
      for (var strokePoints in _allStrokes) {
        final stroke = ml.Stroke();
        for (var point in strokePoints) {
          stroke.points.add(point);
        }
        ink.strokes.add(stroke);
      }

      final candidates = await _recognizer.recognize(ink);

      if (candidates.isNotEmpty) {
        // Debug: print top candidates
        print('Top candidates:');
        for (var i = 0; i < candidates.take(5).length; i++) {
          print(
            '${i + 1}. ${candidates[i].text} (score: ${candidates[i].score})',
          );
        }

        // Get top 5 candidates (or fewer if not available)
        final topCandidates = candidates.take(5).toList();

        // Check if any of the top 5 candidates match the target
        setState(() {
          _isCorrect = topCandidates.any(
            (candidate) => candidate.text == _targetLetter,
          );
        });
      } else {
        print('No candidates recognized');
        setState(() {
          _isCorrect = false;
        });
      }
    } catch (e) {
      print('Error recognizing handwriting: $e');
      setState(() {
        _modelStatus = 'Recognition error: $e';
      });
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _clearCanvas() {
    setState(() {
      _strokes.clear();
      _allStrokes.clear();
      _currentStroke = [];
      _isCorrect = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignColors.backgroundDark,
      appBar: AppBar(
        title: const Text(
          'Trace the character',
          style: TextStyle(
            color: DesignColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: DesignColors.backgroundDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: DesignColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Model Status Banner
            if (!_isModelDownloaded)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(DesignSpacing.md),
                color: DesignColors.attention.withValues(alpha: 0.2),
                child: Row(
                  children: [
                    if (_isDownloadingModel)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            DesignColors.primary,
                          ),
                        ),
                      )
                    else
                      Icon(Icons.warning, color: DesignColors.attention),
                    const SizedBox(width: DesignSpacing.sm),
                    Expanded(
                      child: Text(
                        _modelStatus,
                        style: const TextStyle(
                          fontSize: 14,
                          color: DesignColors.textPrimary,
                        ),
                      ),
                    ),
                    if (!_isDownloadingModel && !_isModelDownloaded)
                      TextButton(
                        onPressed: _downloadModel,
                        child: const Text(
                          'Retry',
                          style: TextStyle(color: DesignColors.primary),
                        ),
                      ),
                  ],
                ),
              ),

            const SizedBox(height: DesignSpacing.md),

            // Target Letter Display with Audio
            Center(
              child: Text(
                _targetLetter,
                style: const TextStyle(
                  fontFamily: 'Neteru',
                  fontSize: 40,
                  color: DesignColors.textPrimary,
                ),
              ),
            ),

            const SizedBox(height: DesignSpacing.lg),

            // Drawing Canvas
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignSpacing.lg,
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: DesignColors.backgroundCard,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: DesignColors.backgroundBorder,
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Stack(
                          children: [
                            // Background guide letter with dashed style
                            Center(
                              child: Text(
                                _targetLetter,
                                style: TextStyle(
                                  fontFamily: 'Geez Handwriting Dots',
                                  fontSize: 300,
                                  color: DesignColors.textSecondary.withValues(
                                    alpha: 0.2,
                                  ),
                                ),
                              ),
                            ),
                            // Drawing canvas
                            GestureDetector(
                              onPanStart: _onPanStart,
                              onPanUpdate: _onPanUpdate,
                              onPanEnd: _onPanEnd,
                              child: CustomPaint(
                                painter: _DrawingPainter(_strokes),
                                size: Size.infinite,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Overlay when model not ready
                    if (!_isModelDownloaded)
                      Container(
                        decoration: BoxDecoration(
                          color: DesignColors.backgroundDark.withValues(
                            alpha: 0.7,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: Text(
                            'Waiting for model...',
                            style: TextStyle(
                              fontSize: 18,
                              color: DesignColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: DesignSpacing.lg),

            // Feedback Display
            if (_isCorrect != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignSpacing.lg,
                ),
                child: Container(
                  padding: const EdgeInsets.all(DesignSpacing.md),
                  decoration: BoxDecoration(
                    color: _isCorrect == true
                        ? DesignColors.success.withValues(alpha: 0.2)
                        : DesignColors.error.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isCorrect == true
                          ? DesignColors.success
                          : DesignColors.error,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isCorrect == true ? Icons.check_circle : Icons.cancel,
                        color: _isCorrect == true
                            ? DesignColors.success
                            : DesignColors.error,
                        size: 32,
                      ),
                      const SizedBox(width: DesignSpacing.sm),
                      Text(
                        _isCorrect == true ? 'Correct!' : 'Try Again',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _isCorrect == true
                              ? DesignColors.success
                              : DesignColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: DesignSpacing.lg),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: DesignSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isModelDownloaded ? _clearCanvas : null,
                      icon: const Icon(
                        Icons.refresh_rounded,
                        color: DesignColors.textPrimary,
                      ),
                      label: const Text(
                        'CLEAR',
                        style: TextStyle(color: DesignColors.textPrimary),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: DesignSpacing.md,
                        ),
                        side: const BorderSide(
                          color: DesignColors.backgroundBorder,
                        ),
                        backgroundColor: DesignColors.backgroundCard,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: DesignSpacing.md),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: (_isProcessing || !_isModelDownloaded)
                          ? null
                          : _recognizeHandwriting,
                      icon: _isProcessing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  DesignColors.backgroundDark,
                                ),
                              ),
                            )
                          : const Icon(
                              Icons.check_rounded,
                              color: DesignColors.backgroundDark,
                            ),
                      label: Text(
                        _isProcessing ? 'CHECKING...' : 'CHECK',
                        style: const TextStyle(
                          color: DesignColors.backgroundDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: DesignSpacing.md,
                        ),
                        backgroundColor: DesignColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: DesignSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<List<Offset>> strokes;

  _DrawingPainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = DesignColors.primary
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 15.0;

    // Draw each stroke separately
    for (var stroke in strokes) {
      for (int i = 0; i < stroke.length - 1; i++) {
        if (stroke[i] != Offset.zero && stroke[i + 1] != Offset.zero) {
          canvas.drawLine(stroke[i], stroke[i + 1], paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(_DrawingPainter oldDelegate) => true;
}
