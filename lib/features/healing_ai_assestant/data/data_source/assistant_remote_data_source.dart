import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:healing/core/services/gemini_service.dart';
import '../../domin/entity/assistent_massage.dart';

abstract class AssistantRemoteDataSource {
  Future<String> requestAssistant({
    required String prompt,
    required AssistantIntent intent,
    File? imageFile,
  });
}

class AssistantException implements Exception {
  final String message;

  const AssistantException(this.message);

  @override
  String toString() => message;
}

class AssistantRemoteDataSourceImpl implements AssistantRemoteDataSource {
  final Dio dio;

  AssistantRemoteDataSourceImpl(this.dio);

  @override
  Future<String> requestAssistant({
    required String prompt,
    required AssistantIntent intent,
    File? imageFile,
  }) async {
    try {
      final List<Map<String, dynamic>> messages;

      if (imageFile != null) {
        // Vision request — encode image as base64
        final bytes = await imageFile.readAsBytes();
        final base64Image = base64Encode(bytes);
        final mimeType = _getMimeType(imageFile.path);

        messages = [
          {
            'role': 'user',
            'content': [
              {
                'type': 'image_url',
                'image_url': {
                  'url': 'data:$mimeType;base64,$base64Image',
                },
              },
              {
                'type': 'text',
                'text': _buildPrompt(intent, prompt),
              },
            ],
          }
        ];
      } else {
        // Text-only request
        messages = [
          {
            'role': 'user',
            'content': _buildPrompt(intent, prompt),
          }
        ];
      }

      final response = await dio.post(
        '/chat/completions',
        data: {
          'model': imageFile != null ? kGroqVisionModel : kGroqModel,
          'max_tokens': 1024,
          'messages': messages,
        },
      );

      final data = response.data as Map<String, dynamic>?;

      if (data == null) {
        throw const AssistantException('Empty response received');
      }

      final choices = data['choices'];

      if (choices == null || choices is! List || choices.isEmpty) {
        throw const AssistantException('No response received from assistant');
      }

      final content = choices.first?['message']?['content'];

      if (content == null) {
        throw const AssistantException('Invalid response format');
      }

      return content.toString().trim();
    } on DioException catch (e) {
      if (kDebugMode) {
        debugPrint('API Error: ${e.response?.statusCode}');
        debugPrint('API Response: ${e.response?.data}');
      }
      throw AssistantException(
        e.response?.data?['error']?['message'] ??
            'Unable to communicate with AI Assistant',
      );
    } catch (e) {
      throw AssistantException(e.toString());
    }
  }

  String _getMimeType(String path) {
    final ext = path.toLowerCase().split('.').last;
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }

  String _buildPrompt(AssistantIntent intent, String userMessage) {
    return 'You are a helpful medical assistant. '
        'Answer the following question clearly and in simple language. '
        'Provide general health information only — do not diagnose or prescribe. '
        'IMPORTANT: Respond in the same language the user writes in (Arabic or English).\n\n'
        '$userMessage';
  }
}
