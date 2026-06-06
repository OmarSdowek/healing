import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';

/// Reusable bottom sheet that shows a Gemini AI response.
class AiSummarySheet extends StatefulWidget {
  final String title;
  final Future<String> Function() generateFn;

  const AiSummarySheet({
    super.key,
    required this.title,
    required this.generateFn,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required Future<String> Function() generateFn,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AiSummarySheet(title: title, generateFn: generateFn),
    );
  }

  @override
  State<AiSummarySheet> createState() => _AiSummarySheetState();
}

class _AiSummarySheetState extends State<AiSummarySheet> {
  String? _result;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> _run() async {
    try {
      final result = await widget.generateFn();
      if (mounted) setState(() { _result = result; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // ── Handle ─────────────────────────────────────────────────
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 4),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // ── Header ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.auto_awesome,
                        color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(widget.title,
                        style: AppTextStyles.semiBold16Black
                            .copyWith(fontSize: 16)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // ── Content ────────────────────────────────────────────────
            Expanded(
              child: _loading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(
                              color: AppColors.primary),
                          const SizedBox(height: 16),
                          Text('Generating AI response...',
                              style: TextStyle(color: Colors.grey.shade600)),
                        ],
                      ),
                    )
                  : _error != null
                      ? Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline,
                                  color: Colors.red, size: 48),
                              const SizedBox(height: 12),
                              Text(
                                _error!.contains('Invalid Gemini API key')
                                    ? 'Please configure your Gemini API key in GeminiService.'
                                    : _error!,
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(color: Colors.red.shade700),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _loading = true;
                                    _error = null;
                                  });
                                  _run();
                                },
                                icon: const Icon(Icons.refresh),
                                label: const Text('Retry'),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white),
                              ),
                            ],
                          ),
                        )
                      : ListView(
                          controller: controller,
                          padding: const EdgeInsets.all(20),
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.04),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color:
                                        AppColors.primary.withOpacity(0.15)),
                              ),
                              child: Text(
                                _result ?? '',
                                style: AppTextStyles.semiBold16Black
                                    .copyWith(
                                        height: 1.6, fontSize: 14),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '✨ Generated by Gemini AI — Not a substitute for professional medical advice.',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                  fontStyle: FontStyle.italic),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
