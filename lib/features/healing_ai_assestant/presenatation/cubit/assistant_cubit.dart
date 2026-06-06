import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domin/entity/assistent_massage.dart';
import '../../domin/use_case/get_ai_response_usecase.dart';
import 'assistant_state.dart';

class AssistantCubit extends Cubit<AssistantState> {
  final GetAIResponseUseCase getAIResponseUseCase;

  AssistantCubit(this.getAIResponseUseCase)
      : super(const AssistantState.initial()) {
    _sendWelcomeMessage();
  }

  void _sendWelcomeMessage() {
    final welcome = AssistantMessage(
      id: 'welcome',
      content: 'مرحباً بك 👋\n\nمعك Healing AI Assistant، مساعدك الطبي الذكي.\n\nما هو استفساركم؟ يسعدني مساعدتك في أي سؤال طبي.',
      role: AssistantMessageRole.assistant,
      intent: AssistantIntent.medicalQuestions,
      timestamp: DateTime.now(),
    );
    emit(AssistantState(
      messages: [welcome],
      isTyping: false,
    ));
  }

  Future<void> sendMessage(
      String text,
      AssistantIntent intent, {
        File? imageFile,
      }) async {
    if (text.trim().isEmpty && imageFile == null) return;

    final displayText = text.trim().isEmpty
        ? '📎 Image attached'
        : text.trim();

    final userMessage = AssistantMessage(
      id: _generateId(),
      content: displayText,
      role: AssistantMessageRole.user,
      intent: intent,
    );

    final updatedMessages = List<AssistantMessage>.from(state.messages)
      ..add(userMessage);

    emit(state.copyWith(
      messages: updatedMessages,
      isTyping: true,
      error: null,
    ));

    try {
      final response = await getAIResponseUseCase.execute(
        prompt: text.trim().isEmpty
            ? 'Please analyze this medical image and explain what you see in simple language.'
            : text.trim(),
        intent: AssistantIntent.medicalQuestions,
        imageFile: imageFile,
      );

      final finalMessages = List<AssistantMessage>.from(updatedMessages)
        ..add(response);

      emit(state.copyWith(
        messages: finalMessages,
        isTyping: false,
      ));
    } catch (error) {
      emit(state.copyWith(
        isTyping: false,
        error: error.toString(),
      ));
    }
  }

  void clearChat() {
    _sendWelcomeMessage();
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
