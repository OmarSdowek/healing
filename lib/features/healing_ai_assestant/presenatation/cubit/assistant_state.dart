import '../../domin/entity/assistent_massage.dart';

class AssistantState {
  final List<AssistantMessage> messages;
  final bool isTyping;
  final String? error;

  const AssistantState({
    required this.messages,
    required this.isTyping,
    this.error,
  });

  const AssistantState.initial()
      : messages = const [],
        isTyping = false,
        error = null;

  AssistantState copyWith({
    List<AssistantMessage>? messages,
    bool? isTyping,
    String? error,
  }) {
    return AssistantState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      error: error,
    );
  }
}