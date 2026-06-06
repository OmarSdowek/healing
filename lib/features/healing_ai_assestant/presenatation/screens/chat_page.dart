import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/di/injection_container.dart';
import '../../domin/entity/assistent_massage.dart';
import '../cubit/assistant_cubit.dart';
import '../cubit/assistant_state.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
      appBar: AppBar(
        title: const Text('Healing AI Assistant'),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (_) => sl<AssistantCubit>(),
        child: BlocConsumer<AssistantCubit, AssistantState>(
          listener: (context, state) {
            _scrollToBottom();
          },
          builder: (context, state) {
            return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: state.messages.length +
                      (state.isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < state.messages.length) {
                      final message = state.messages[index];
                      return _buildMessage(message);
                    } else {
                      return _typingBubble();
                    }
                  },
                ),
              ),

              if (state.error != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.red.shade100,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(state.error!),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () {
                          // retry logic later
                        },
                      )
                    ],
                  ),
                ),

              _inputBar(context),
            ],
          );
        },
      ),
    ),
    );
  }

  Widget _inputBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _send(context),
              decoration: const InputDecoration(
                hintText: 'اكتب رسالتك هنا...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => _send(context),
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  void _send(BuildContext context) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    context.read<AssistantCubit>().sendMessage(
      text,
      AssistantIntent.medicalQuestions,
    );

    _controller.clear();
  }

  Widget _typingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 6,
          horizontal: 12,
        ),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Text('AI is typing...'),
      ),
    );
  }

  Widget _buildMessage(message) {
    final isUser = message.role == AssistantMessageRole.user;

    return Align(
      alignment:
      isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 6,
          horizontal: 12,
        ),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isUser
              ? Colors.deepPurple.shade100
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message.content,
          style: TextStyle(
            color: isUser
                ? Colors.deepPurple.shade900
                : Colors.black87,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}