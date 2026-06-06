import 'dart:io';

import '../entity/assistent_massage.dart';
import '../repo/assistant_repo.dart';

class GetAIResponseUseCase {
  final AssistantRepository repository;

  GetAIResponseUseCase(this.repository);

  Future<AssistantMessage> execute({
    required String prompt,
    required AssistantIntent intent,
    File? imageFile,
  }) async {
    return repository.requestAssistantResponse(
      prompt: prompt,
      intent: intent,
      imageFile: imageFile,
    );
  }
}
