enum AssistantMessageRole { user, assistant, system }

enum AssistantIntent {
  explainPrescription,
  summarizeRecord,
  medicalQuestions,
}

class AssistantMessage {
  final String id;
  final String content;
  final AssistantMessageRole role;
  final DateTime timestamp;
  final AssistantIntent intent;

  AssistantMessage({
    required this.id,
    required this.content,
    required this.role,
    required this.intent,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  AssistantMessage copyWith({
    String? id,
    String? content,
    AssistantMessageRole? role,
    DateTime? timestamp,
    AssistantIntent? intent,
  }) {
    return AssistantMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      role: role ?? this.role,
      intent: intent ?? this.intent,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}