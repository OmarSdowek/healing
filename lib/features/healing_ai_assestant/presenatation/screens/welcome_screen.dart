import 'package:flutter/material.dart';

import '../../../../core/constant/app_text_style.dart';
import 'assestant_chat_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFB7E6FF), Color(0xFFD7F8F0), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Color(0xFF1D6FA3),
                      child: Icon(Icons.medical_services, size: 32, color: Colors.white),
                    ),
                    SizedBox(width: 14),
                    Text(
                      'Healing AI Assistant',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0D3B66),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Your smart medical companion',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF08415C),
                  ),
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      _FeatureCard(
                        icon: Icons.receipt_long,
                        title: 'Explain Prescription',
                        description: 'Understand medicines, dosage, and timing clearly.',
                      ),
                      SizedBox(height: 18),
                      _FeatureCard(
                        icon: Icons.folder_shared,
                        title: 'Summarize Medical Record',
                        description: 'Get a concise summary of your reports and history.',
                      ),
                      SizedBox(height: 18),
                      _FeatureCard(
                        icon: Icons.question_answer,
                        title: 'Ask Medical Questions',
                        description: 'Receive helpful guidance without diagnosis.',
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      backgroundColor: const Color(0xFF0D6FA3),
                      shadowColor: const Color(0x801D6FA3),
                      elevation: 8,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AssistantChatScreen()),
                      );
                    },
                    child:  Text(
                      'Start Chat',
                      style: AppTextStyles.reg20black.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFE0F1FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 28, color: const Color(0xFF0D6FA3)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0D3B66),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
