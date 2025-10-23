import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:lisan_app/design/theme.dart';

class ExplainMyMistake extends StatefulWidget {
  final String? initialMessage;

  const ExplainMyMistake({super.key, this.initialMessage});

  @override
  State<ExplainMyMistake> createState() => _ExplainMyMistakeState();
}

class _ExplainMyMistakeState extends State<ExplainMyMistake> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  final Gemini _gemini = Gemini.instance;
  bool _isTyping = false;

  // Constants
  static const _scrollDelay = Duration(milliseconds: 100);
  static const _scrollDuration = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();

    // Add initial welcome message
    _messages.add(
      ChatMessage(
        text:
            "Hello! I'm your AI assistant. I can help explain mistakes, answer questions, and have conversations with you. How can I help you today?",
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );

    // If there's an initial message, send it automatically
    if (widget.initialMessage != null && widget.initialMessage!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.text = widget.initialMessage!;
        _sendMessage();
      });
    }
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    final userMessage = _controller.text.trim();

    setState(() {
      _messages.add(
        ChatMessage(text: userMessage, isUser: true, timestamp: DateTime.now()),
      );
      _isTyping = true;
    });

    _controller.clear();
    _scrollToBottom();

    // Send message to Gemini AI using non-streaming for complete response
    _gemini
        .prompt(parts: [Part.text(userMessage)])
        .then((response) {
          if (!mounted) return;

          setState(() {
            _messages.add(
              ChatMessage(
                text:
                    response?.output ??
                    'Sorry, I could not generate a response.',
                isUser: false,
                timestamp: DateTime.now(),
              ),
            );
            _isTyping = false;
          });
          _scrollToBottom();
        })
        .catchError((error) {
          if (!mounted) return;

          setState(() {
            _messages.add(
              ChatMessage(
                text:
                    "Sorry, I encountered an error: ${error.toString()}. Please try again.",
                isUser: false,
                timestamp: DateTime.now(),
              ),
            );
            _isTyping = false;
          });
          _scrollToBottom();
        });
  }

  void _scrollToBottom() {
    Future.delayed(_scrollDelay, () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: _scrollDuration,
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: DesignSpacing.lg),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(DesignSpacing.md),
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length) {
                    return const TypingIndicator();
                  }
                  return MessageBubble(message: _messages[index]);
                },
              ),
            ),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      decoration: BoxDecoration(
        color: DesignColors.backgroundCard,
        border: Border(
          top: BorderSide(color: DesignColors.backgroundBorder, width: 1),
        ),
      ),
      padding: const EdgeInsets.all(DesignSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: DesignColors.backgroundDark,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: DesignColors.backgroundBorder,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _controller,
                enabled: !_isTyping,
                style: const TextStyle(color: DesignColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(color: DesignColors.textTertiary),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: DesignSpacing.md,
                    vertical: DesignSpacing.sm,
                  ),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: DesignSpacing.sm),
          GestureDetector(
            onTap: _isTyping ? null : _sendMessage,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _isTyping
                    ? DesignColors.textTertiary
                    : DesignColors.primary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.arrow_upward_rounded,
                color: DesignColors.backgroundDark,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  static const _messagePadding = DesignSpacing.sm + 4.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignSpacing.md),
      child: Row(
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignSpacing.md,
                vertical: _messagePadding,
              ),
              decoration: BoxDecoration(
                color: message.isUser
                    ? DesignColors.primary
                    : DesignColors.backgroundCard,
                borderRadius: BorderRadius.circular(16),
                border: message.isUser
                    ? null
                    : Border.all(
                        color: DesignColors.backgroundBorder,
                        width: 1,
                      ),
              ),
              child: message.isUser
                  ? Text(
                      message.text,
                      style: const TextStyle(
                        color: DesignColors.backgroundDark,
                        fontSize: 15,
                        height: 1.4,
                      ),
                    )
                  : SelectionArea(
                      child: GptMarkdown(
                        message.text,
                        style: const TextStyle(
                          color: DesignColors.textPrimary,
                          fontSize: 15,
                          height: 1.4,
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

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  static const _messagePadding = DesignSpacing.sm + 4.0;
  static const _dotCount = 3;
  static const _dotSize = 8.0;
  static const _dotSpacing = 2.0;
  static const _animationDelay = 0.2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignSpacing.md),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignSpacing.md,
              vertical: _messagePadding,
            ),
            decoration: BoxDecoration(
              color: DesignColors.backgroundCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: DesignColors.backgroundBorder,
                width: 1,
              ),
            ),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(_dotCount, (index) {
                    final delay = index * _animationDelay;
                    final value = (_controller.value - delay) % 1.0;
                    final opacity = value < 0.5 ? value * 2 : 2 - value * 2;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: _dotSpacing,
                      ),
                      child: Opacity(
                        opacity: opacity.clamp(0.3, 1.0),
                        child: Container(
                          width: _dotSize,
                          height: _dotSize,
                          decoration: const BoxDecoration(
                            color: DesignColors.textSecondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
