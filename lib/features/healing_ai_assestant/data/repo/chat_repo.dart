
import '../../domin/entity/chat_massage.dart';

class ChatRepository {
  Future<ChatMessage> getResponse(String userMessage) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final normalized = userMessage.toLowerCase();

    // Greetings
    if (normalized.contains('hello') ||
        normalized.contains('hi') ||
        normalized.contains('hey')) {
      return ChatMessage(
        id: _generateId(),
        content: 'مرحبًا! كيف يمكنني مساعدتك اليوم؟',
        role: MessageRole.assistant,
      );
    }

    // Emotional support
    if (normalized.contains('sad') ||
        normalized.contains('depressed') ||
        normalized.contains('anxious') ||
        normalized.contains('حزين') ||
        normalized.contains('قلق')) {
      return ChatMessage(
        id: _generateId(),
        content:
        'أنا هنا من أجلك. خذ نفسًا عميقًا. هل تريد أن تخبرني أكثر عما تشعر به؟',
        role: MessageRole.assistant,
      );
    }

    // Thanks
    if (normalized.contains('thank') ||
        normalized.contains('thanks') ||
        normalized.contains('شكراً') ||
        normalized.contains('شكرا')) {
      return ChatMessage(
        id: _generateId(),
        content:
        'سعيد بمساعدتك! أنا هنا دائمًا إذا احتجت أي دعم.',
        role: MessageRole.assistant,
      );
    }

    // Default
    return ChatMessage(
      id: _generateId(),
      content:
      'أخبرني أكثر عن ما تشعر به أو ما تريد مساعدتي فيه، وسأحاول دعمك.',
      role: MessageRole.assistant,
    );
  }

  String _generateId() {
    return DateTime.now()
        .millisecondsSinceEpoch
        .toString();
  }
}