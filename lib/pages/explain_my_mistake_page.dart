import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';

class ExplainMyMistake extends StatefulWidget {
  const ExplainMyMistake({super.key});

  @override
  State<ExplainMyMistake> createState() => _ExplainMyMistakeState();
}

class _ExplainMyMistakeState extends State<ExplainMyMistake> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _messages.add(
      ChatMessage(
        text: "Hello! I'm your AI assistant. How can I help you today?",
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: _controller.text,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
      _isTyping = true;
    });

    final userMessage = _controller.text;
    _controller.clear();

    _scrollToBottom();

    // Simulate AI response
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        _messages.add(
          ChatMessage(
            text: _generateResponse(userMessage),
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
        _isTyping = false;
      });
      _scrollToBottom();
    });
  }

  String _generateResponse(String input) {
    final responses = [
      "That's an interesting question! Let me think about that...",
      "I understand what you're asking. Here's what I think...",
      "Great question! Based on what you've shared...",
      "Thanks for asking! Here's my take on that...",
    ];
    return responses[DateTime.now().millisecond % responses.length];
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: DesignSpacing.lg),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(DesignSpacing.md),
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length && _isTyping) {
                    return const TypingIndicator();
                  }
                  return MessageBubble(message: _messages[index]);
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: DesignColors.backgroundCard,
                border: Border(
                  top: BorderSide(
                    color: DesignColors.backgroundBorder,
                    width: 1,
                  ),
                ),
              ),
              padding: const EdgeInsets.all(DesignSpacing.md),
              child: SafeArea(
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
                          style: const TextStyle(
                            color: DesignColors.textPrimary,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Type a message...',
                            hintStyle: TextStyle(
                              color: DesignColors.textTertiary,
                            ),
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
                      onTap: _sendMessage,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: DesignColors.primary,
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
              ),
            ),
          ],
        ),
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignSpacing.md),
      child: Row(
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignSpacing.md,
                vertical: DesignSpacing.sm + 4,
              ),
              decoration: BoxDecoration(
                color: message.isUser
                    ? DesignColors.primary
                    : DesignColors.backgroundCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: message.isUser
                      ? DesignColors.primary
                      : DesignColors.backgroundBorder,
                  width: 1,
                ),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser
                      ? DesignColors.backgroundDark
                      : DesignColors.textPrimary,
                  fontSize: 15,
                  height: 1.4,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignSpacing.md,
              vertical: DesignSpacing.sm + 4,
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
                  children: List.generate(3, (index) {
                    final delay = index * 0.2;
                    final value = (_controller.value - delay) % 1.0;
                    final opacity = value < 0.5 ? value * 2 : 2 - value * 2;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Opacity(
                        opacity: opacity.clamp(0.3, 1.0),
                        child: Container(
                          width: 8,
                          height: 8,
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
