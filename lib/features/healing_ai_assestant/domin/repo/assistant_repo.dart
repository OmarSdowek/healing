import 'dart:io';
import '../entity/assistent_massage.dart';

abstract class AssistantRepository {
  Future<AssistantMessage> requestAssistantResponse({
    required String prompt,
    required AssistantIntent intent,
    File? imageFile,
  });
}
