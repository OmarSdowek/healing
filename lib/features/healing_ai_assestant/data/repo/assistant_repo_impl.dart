import 'dart:io';

import '../../domin/entity/assistent_massage.dart';
import '../../domin/repo/assistant_repo.dart';
import '../data_source/assistant_remote_data_source.dart';

class AssistantRepositoryImpl implements AssistantRepository {
  final AssistantRemoteDataSource remoteDataSource;

  const AssistantRepositoryImpl(this.remoteDataSource);

  @override
  Future<AssistantMessage> requestAssistantResponse({
    required String prompt,
    required AssistantIntent intent,
    File? imageFile,
  }) async {
    final response = await remoteDataSource.requestAssistant(
      prompt: prompt,
      intent: intent,
      imageFile: imageFile,
    );

    return AssistantMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: response,
      role: AssistantMessageRole.assistant,
      intent: intent,
      timestamp: DateTime.now(),
    );
  }
}
