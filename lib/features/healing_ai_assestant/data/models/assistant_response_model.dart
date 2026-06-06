import '../../domin/entity/assistent_massage.dart';

class AssistantResponseModel extends AssistantMessage {
  AssistantResponseModel({
    required super.id,
    required super.content,
    required super.intent,
    DateTime? timestamp,
  }) : super(
    role: AssistantMessageRole.assistant,
    timestamp: timestamp,
  );

  factory AssistantResponseModel.fromMap(
      Map<String, dynamic> map,
      AssistantIntent intent,
      ) {
    // Anthropic response format: content[0].text
    final contentList = map['content'] as List<dynamic>?;

    if (contentList == null || contentList.isEmpty) {
      throw Exception('No content returned from assistant');
    }

    final firstBlock =
    contentList.first as Map<String, dynamic>;

    final text = firstBlock['text']?.toString() ?? '';

    return AssistantResponseModel(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(),
      content: text,
      intent: intent,
      timestamp: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'intent': intent.name,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}