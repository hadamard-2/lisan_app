import 'package:flutter/material.dart';

class ChatBubbleButton extends StatefulWidget {
  final String buttonText;
  final String bubbleContent;
  final Color? buttonColor;
  final Color? bubbleColor;
  final IconData? icon;

  const ChatBubbleButton({
    super.key,
    required this.buttonText,
    required this.bubbleContent,
    this.buttonColor,
    this.bubbleColor,
    this.icon,
  });

  @override
  State<ChatBubbleButton> createState() => _ChatBubbleButtonState();
}

class _ChatBubbleButtonState extends State<ChatBubbleButton>
    with SingleTickerProviderStateMixin {
  bool _isActive = false;
  final GlobalKey _buttonKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _removeBubble();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleBubble() {
    if (_isActive) {
      _removeBubble();
    } else {
      _showBubble();
    }
  }

  void _showBubble() {
    final RenderBox? renderBox =
        _buttonKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => _BubbleOverlay(
        buttonPosition: position,
        buttonSize: size,
        bubbleContent: widget.bubbleContent,
        buttonText: widget.buttonText,
        icon: widget.icon,
        bubbleColor: widget.bubbleColor ?? Colors.white,
        scaleAnimation: _scaleAnimation,
        fadeAnimation: _fadeAnimation,
        onDismiss: _removeBubble,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _animationController.forward(from: 0);

    setState(() {
      _isActive = true;
    });
  }

  void _removeBubble() {
    if (_overlayEntry != null) {
      _animationController.reverse().then((_) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      });

      setState(() {
        _isActive = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: _buttonKey,
      child: ElevatedButton(
        onPressed: _toggleBubble,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isActive
              ? (widget.buttonColor ?? Colors.blue).withOpacity(0.8)
              : (widget.buttonColor ?? Colors.blue),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: _isActive ? 8 : 2,
        ),
        child: Text(
          widget.buttonText,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _BubbleOverlay extends StatelessWidget {
  final Offset buttonPosition;
  final Size buttonSize;
  final String bubbleContent;
  final String buttonText;
  final IconData? icon;
  final Color bubbleColor;
  final Animation<double> scaleAnimation;
  final Animation<double> fadeAnimation;
  final VoidCallback onDismiss;

  const _BubbleOverlay({
    required this.buttonPosition,
    required this.buttonSize,
    required this.bubbleContent,
    required this.buttonText,
    required this.icon,
    required this.bubbleColor,
    required this.scaleAnimation,
    required this.fadeAnimation,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bubbleWidth = 280.0;
    final bubbleHeight = 120.0;
    final triangleSize = 10.0;
    final spacing = 16.0;

    // Position bubble below the button, centered
    double left =
        buttonPosition.dx + (buttonSize.width / 2) - (bubbleWidth / 2);
    double top = buttonPosition.dy + buttonSize.height + spacing;

    // Ensure horizontal bounds
    final minLeft = 16.0;
    final maxLeft = screenWidth - bubbleWidth - 16.0;
    left = left.clamp(minLeft, maxLeft);

    // Calculate triangle position - centered on button, pointing up from top of bubble
    double triangleLeft =
        buttonPosition.dx + (buttonSize.width / 2) - (triangleSize / 2);
    double triangleTop = top - triangleSize;

    return GestureDetector(
      onTap: onDismiss,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          // Chat bubble
          Positioned(
            left: left,
            top: top,
            child: GestureDetector(
              onTap: () {}, // Prevent dismissal when tapping bubble
              child: FadeTransition(
                opacity: fadeAnimation,
                child: ScaleTransition(
                  scale: scaleAnimation,
                  alignment: Alignment.topCenter,
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: bubbleWidth,
                      constraints: BoxConstraints(minHeight: bubbleHeight),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: bubbleColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (icon != null)
                            Row(
                              children: [
                                Icon(icon, color: Colors.blue, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    buttonText,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          if (icon != null) const SizedBox(height: 8),
                          Text(
                            bubbleContent,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Triangle pointer
          Positioned(
            left: triangleLeft,
            top: triangleTop,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: ScaleTransition(
                scale: scaleAnimation,
                alignment: Alignment.topCenter,
                child: CustomPaint(
                  size: Size(triangleSize, triangleSize),
                  painter: _TrianglePainter(color: bubbleColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    // Triangle pointing up
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Example usage:
class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      // appBar: AppBar(
      //   title: const Text('Chat Bubble Button Demo'),
      //   centerTitle: true,
      // ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChatBubbleButton(
                buttonText: 'Profile',
                bubbleContent:
                    'View and edit your profile information, change avatar, and update bio.',
                icon: Icons.person,
              ),
              const SizedBox(height: 16),
              ChatBubbleButton(
                buttonText: 'Settings',
                bubbleContent:
                    'Manage app preferences, privacy settings, and account options.',
                icon: Icons.settings,
                buttonColor: Colors.green,
              ),
              const SizedBox(height: 16),
              ChatBubbleButton(
                buttonText: 'Help',
                bubbleContent:
                    'Get help, view tutorials, or contact support team.',
                icon: Icons.help,
                buttonColor: Colors.orange,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
