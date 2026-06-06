import 'dart:io';

import 'package:dash_chat_2/dash_chat_2.dart' as dash;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:healing/core/di/injection_container.dart';
import '../../domin/entity/assistent_massage.dart';
import '../cubit/assistant_cubit.dart';
import '../cubit/assistant_state.dart';

class AssistantChatScreen extends StatefulWidget {
  const AssistantChatScreen({super.key});

  @override
  State<AssistantChatScreen> createState() => _AssistantChatScreenState();
}

class _AssistantChatScreenState extends State<AssistantChatScreen> {
  static final dash.ChatUser _currentUser =
  dash.ChatUser(id: 'patient', firstName: 'Patient');

  static final dash.ChatUser _assistantUser =
  dash.ChatUser(id: 'assistant', firstName: 'Healing AI');

  final ImagePicker _picker = ImagePicker();
  File? _pendingImage;

  List<dash.ChatMessage> _mapMessages(List<AssistantMessage> messages) {
    final mapped = messages.map((message) {
      final user = message.role == AssistantMessageRole.user
          ? _currentUser
          : _assistantUser;

      return dash.ChatMessage(
        user: user,
        createdAt: message.timestamp,
        text: _cleanMarkdown(message.content),
      );
    }).toList();

    return mapped.reversed.toList();
  }

  String _cleanMarkdown(String text) {
    return text
        .replaceAll(RegExp(r'\*\*(.+?)\*\*'), r'$1')
        .replaceAll(RegExp(r'\*(.+?)\*'), r'$1')
        .replaceAll(RegExp(r'#{1,6}\s*'), '')
        .replaceAll(RegExp(r'`{1,3}[^`]*`{1,3}'), '')
        .replaceAll(RegExp(r'^\s*[-*]\s+', multiLine: true), '• ')
        .replaceAll(RegExp(r'^\s*\d+\.\s+', multiLine: true), '')
        .trim();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 1024,
    );
    if (picked != null) {
      setState(() => _pendingImage = File(picked.path));
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Attach Image',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0D3B66),
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE0F1FF),
                  child: Icon(Icons.photo_library, color: Color(0xFF0D6FA3)),
                ),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE0F1FF),
                  child: Icon(Icons.camera_alt, color: Color(0xFF0D6FA3)),
                ),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AssistantCubit>(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F9FF),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0D6FA3),
          foregroundColor: Colors.white,
          title: const Text('Healing AI Assistant'),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Clear chat',
              onPressed: () {
                context.read<AssistantCubit>().clearChat();
                setState(() => _pendingImage = null);
              },
            ),
          ],
        ),
        body: BlocBuilder<AssistantCubit, AssistantState>(
          builder: (context, state) {
            if (state.error != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error!),
                    backgroundColor: Colors.red.shade700,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              });
            }

            return Column(
              children: [
                // Image preview banner
                if (_pendingImage != null)
                  Container(
                    color: const Color(0xFFE0F1FF),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _pendingImage!,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'Image ready — type a message or send as-is',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF0D3B66),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close,
                              color: Color(0xFF0D6FA3)),
                          onPressed: () =>
                              setState(() => _pendingImage = null),
                        ),
                      ],
                    ),
                  ),

                // Chat
                Expanded(
                  child: dash.DashChat(
                    currentUser: _currentUser,
                    messages: _mapMessages(state.messages),
                    typingUsers:
                    state.isTyping ? [_assistantUser] : const [],
                    onSend: (dash.ChatMessage msg) {
                      final image = _pendingImage;
                      setState(() => _pendingImage = null);
                      context.read<AssistantCubit>().sendMessage(
                        msg.text,
                        AssistantIntent.medicalQuestions,
                        imageFile: image,
                      );
                    },
                    messageOptions: const dash.MessageOptions(
                      showTime: true,
                    ),
                    inputOptions: dash.InputOptions(
                      sendOnEnter: true,
                      alwaysShowSend: true,
                      leading: [
                        IconButton(
                          icon: const Icon(
                            Icons.attach_file,
                            color: Color(0xFF0D6FA3),
                          ),
                          tooltip: 'Attach prescription or image',
                          onPressed: _showImageSourceSheet,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
