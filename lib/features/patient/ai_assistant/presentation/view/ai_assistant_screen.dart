import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/services/gemini_service.dart';

// ─── Message model ────────────────────────────────────────────────────────────
class _ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;

  _ChatMessage({
    required this.text,
    required this.isUser,
  }) : time = DateTime.now();
}

// ─── Screen ───────────────────────────────────────────────────────────────────
class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final _inputCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  final List<_ChatMessage> _messages = [];
  bool _isTyping = false;

  // ── Quick suggestion prompts ──────────────────────────────────────────────
  static const _suggestions = [
    'I have a headache and fever',
    'What does my prescription mean?',
    'I feel chest pain',
    'Tips for better sleep',
    'I have a sore throat',
  ];

  @override
  void initState() {
    super.initState();
    // Welcome message
    _messages.add(_ChatMessage(
      text:
          "Hello! I'm **Healing AI Assistant** 👋\n\nI'm here to help you with:\n• Understanding your symptoms\n• Explaining medications\n• General health advice\n\nHow can I help you today?",
      isUser: false,
    ));
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(text: trimmed, isUser: true));
      _isTyping = true;
    });
    _inputCtrl.clear();
    _scrollToBottom();

    try {
      final reply = await GeminiService.chatWithAssistant(userMessage: trimmed);
      if (mounted) {
        setState(() {
          _messages.add(_ChatMessage(text: reply, isUser: false));
          _isTyping = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(_ChatMessage(
            text: 'Sorry, I couldn\'t process that. Please try again.',
            isUser: false,
          ));
          _isTyping = false;
        });
        _scrollToBottom();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ───────────────────────────────────────────────────
            _Header(),

            // ── Messages ─────────────────────────────────────────────────
            Expanded(
              child: ListView.builder(
                controller: _scrollCtrl,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, i) {
                  if (_isTyping && i == _messages.length) {
                    return _TypingIndicator();
                  }
                  return _MessageBubble(msg: _messages[i]);
                },
              ),
            ),

            // ── Quick suggestions (only when no messages sent yet) ────────
            if (_messages.length == 1) _SuggestionsBar(
              suggestions: _suggestions,
              onTap: _send,
            ),

            // ── Input bar ────────────────────────────────────────────────
            _InputBar(
              controller: _inputCtrl,
              isLoading: _isTyping,
              onSend: _send,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios,
                color: Color(0xFF1F2937), size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.auto_awesome,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Healing AI Assistant',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Online',
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Message Bubble ───────────────────────────────────────────────────────────
class _MessageBubble extends StatelessWidget {
  final _ChatMessage msg;
  const _MessageBubble({required this.msg});

  @override
  Widget build(BuildContext context) {
    final isUser = msg.isUser;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.7)
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.auto_awesome,
                  color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                // render **bold** markers simply
                msg.text.replaceAll('**', ''),
                style: TextStyle(
                  color: isUser ? Colors.white : const Color(0xFF1F2937),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }
}

// ─── Typing Indicator ─────────────────────────────────────────────────────────
class _TypingIndicator extends StatefulWidget {
  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.7)
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.auto_awesome,
                color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: AnimatedBuilder(
              animation: _ctrl,
              builder: (_, __) => Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (i) {
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 200 + i * 100),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(
                          0.4 + 0.6 * (_ctrl.value + i * 0.3).clamp(0.0, 1.0)),
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Suggestions Bar ──────────────────────────────────────────────────────────
class _SuggestionsBar extends StatelessWidget {
  final List<String> suggestions;
  final void Function(String) onTap;

  const _SuggestionsBar(
      {required this.suggestions, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: suggestions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) => GestureDetector(
          onTap: () => onTap(suggestions[i]),
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: AppColors.primary.withOpacity(0.2)),
            ),
            child: Text(
              suggestions[i],
              style: TextStyle(
                  fontSize: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Input Bar ────────────────────────────────────────────────────────────────
class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final void Function(String) onSend;

  const _InputBar({
    required this.controller,
    required this.isLoading,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.send,
              onSubmitted: isLoading ? null : onSend,
              decoration: InputDecoration(
                hintText: 'Ask me anything health related...',
                hintStyle:
                    TextStyle(color: Colors.grey.shade400, fontSize: 14),
                filled: true,
                fillColor: const Color(0xFFF4F6FB),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: isLoading ? null : () => onSend(controller.text),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color:
                    isLoading ? Colors.grey.shade300 : AppColors.primary,
                borderRadius: BorderRadius.circular(22),
              ),
              child: isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : const Icon(Icons.send_rounded,
                      color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
