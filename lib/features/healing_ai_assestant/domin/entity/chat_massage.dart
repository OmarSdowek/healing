import 'assistent_massage.dart';

enum MessageRole { user, assistant }

class ChatMessage {
  final String id;
  final String content;
  final MessageRole role;
  final DateTime timestamp;
  final AssistantIntent? intent;

  ChatMessage({
    required this.id,
    required this.content,
    required this.role,
    this.intent,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}