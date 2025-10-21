import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart' as ml;

class AmharicHandwritingPage extends StatefulWidget {
  const AmharicHandwritingPage({super.key});

  @override
  State<AmharicHandwritingPage> createState() => _AmharicHandwritingPageState();
}

class _AmharicHandwritingPageState extends State<AmharicHandwritingPage> {
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('የአማርኛ ፊደል ልምምድ'),
        backgroundColor: Colors.indigo,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Model Status Banner
            if (!_isModelDownloaded)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: _isDownloadingModel
                    ? Colors.orange[100]
                    : Colors.red[100],
                child: Row(
                  children: [
                    if (_isDownloadingModel)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      const Icon(Icons.warning, color: Colors.orange),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _modelStatus,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    if (!_isDownloadingModel && !_isModelDownloaded)
                      TextButton(
                        onPressed: _downloadModel,
                        child: const Text('Retry'),
                      ),
                  ],
                ),
              ),

            // Target Letter Display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.indigo,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'ይህን ፊደል ይጻፉ',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _targetLetter,
                    style: const TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Drawing Canvas
            Expanded(
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          // Background guide letter
                          Center(
                            child: Text(
                              _targetLetter,
                              style: TextStyle(
                                fontFamily: 'Geez Handwriting Dots',
                                fontSize: 250,
                                color: Colors.indigo.withValues(alpha: 0.4),
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
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text(
                          'Waiting for model...',
                          style: TextStyle(fontSize: 18, color: Colors.black54),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Feedback Display
            if (_isCorrect != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _isCorrect == true ? Colors.green[50] : Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _isCorrect == true ? Colors.green : Colors.red,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isCorrect == true ? Icons.check_circle : Icons.cancel,
                      color: _isCorrect == true ? Colors.green : Colors.red,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _isCorrect == true ? 'ትክክል!' : 'እንደገና ይሞክሩ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _isCorrect == true
                            ? Colors.green[800]
                            : Colors.red[800],
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isModelDownloaded ? _clearCanvas : null,
                      icon: const Icon(Icons.clear),
                      label: const Text('አጥፋ'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.grey[400]!),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
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
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Icon(Icons.check),
                      label: Text(_isProcessing ? 'በማረጋገጥ...' : 'አረጋግጥ'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.indigo,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
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
      ..color = Colors.indigo
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
