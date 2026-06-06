import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/services/gemini_service.dart';
import 'package:healing/core/widgets/custom_header.dart';

class SymptomCheckerScreen extends StatefulWidget {
  const SymptomCheckerScreen({super.key});

  @override
  State<SymptomCheckerScreen> createState() => _SymptomCheckerScreenState();
}

class _SymptomCheckerScreenState extends State<SymptomCheckerScreen> {
  final _inputCtrl = TextEditingController();
  final List<String> _symptoms = [];
  String? _result;
  bool _loading = false;

  // ── Common symptom quick chips ────────────────────────────────────────────
  static const _quickSymptoms = [
    'Fever', 'Cough', 'Headache', 'Fatigue', 'Sore Throat',
    'Shortness of Breath', 'Nausea', 'Dizziness', 'Chest Pain',
    'Back Pain', 'Joint Pain', 'Runny Nose',
  ];

  void _addSymptom(String s) {
    final trimmed = s.trim();
    if (trimmed.isEmpty) return;
    if (_symptoms.contains(trimmed)) return;
    setState(() {
      _symptoms.add(trimmed);
      _inputCtrl.clear();
      _result = null; // reset result when symptoms change
    });
  }

  void _removeSymptom(String s) {
    setState(() {
      _symptoms.remove(s);
      _result = null;
    });
  }

  Future<void> _analyze() async {
    if (_symptoms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one symptom.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _loading = true;
      _result = null;
    });

    try {
      final result = await GeminiService.analyzeSymptoms(
        symptoms: _symptoms,
      );
      if (mounted) setState(() => _result = result);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(title: 'AI Symptom Checker'),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Disclaimer ───────────────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.amber.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline,
                              color: Colors.amber.shade700, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'This is for informational purposes only. Always consult a doctor.',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.amber.shade800),
                            ),
                          ),
                        ],
                      ),
                    ),

                    context.verticalSpace(20),

                    // ── Input ────────────────────────────────────────────
                    Text('Enter your symptoms',
                        style: AppTextStyles.semiBold16Black),
                    context.verticalSpace(8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _inputCtrl,
                            decoration: InputDecoration(
                              hintText: 'e.g. Headache',
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onSubmitted: _addSymptom,
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () => _addSymptom(_inputCtrl.text),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.add,
                                color: Colors.white, size: 24),
                          ),
                        ),
                      ],
                    ),

                    context.verticalSpace(16),

                    // ── Quick chips ──────────────────────────────────────
                    Text('Quick add:',
                        style: AppTextStyles.semiBold16Black.copyWith(
                            fontSize: 13, color: Colors.grey)),
                    context.verticalSpace(8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: _quickSymptoms.map((s) {
                        final added = _symptoms.contains(s);
                        return GestureDetector(
                          onTap: () =>
                              added ? _removeSymptom(s) : _addSymptom(s),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: added
                                  ? AppColors.primary
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: added
                                    ? AppColors.primary
                                    : Colors.grey.shade300,
                              ),
                            ),
                            child: Text(
                              s,
                              style: TextStyle(
                                fontSize: 12,
                                color: added
                                    ? Colors.white
                                    : Colors.grey.shade700,
                                fontWeight: added
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    context.verticalSpace(20),

                    // ── Selected symptoms ────────────────────────────────
                    if (_symptoms.isNotEmpty) ...[
                      Text('Selected symptoms (${_symptoms.length}):',
                          style: AppTextStyles.semiBold16Black
                              .copyWith(fontSize: 13)),
                      context.verticalSpace(8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: _symptoms
                            .map((s) => Chip(
                                  label: Text(s,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.white)),
                                  backgroundColor: AppColors.primary,
                                  deleteIconColor: Colors.white70,
                                  onDeleted: () => _removeSymptom(s),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4),
                                ))
                            .toList(),
                      ),
                      context.verticalSpace(20),
                    ],

                    // ── Analyze button ───────────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        icon: _loading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                              )
                            : const Icon(Icons.auto_awesome,
                                color: Colors.white, size: 20),
                        label: Text(
                          _loading ? 'Analyzing...' : 'Analyze Symptoms',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        onPressed: _loading ? null : _analyze,
                      ),
                    ),

                    // ── Result ───────────────────────────────────────────
                    if (_result != null) ...[
                      context.verticalSpace(24),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: AppColors.primary.withOpacity(0.2)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.auto_awesome,
                                      color: AppColors.primary, size: 18),
                                ),
                                const SizedBox(width: 8),
                                Text('AI Analysis',
                                    style: AppTextStyles.semiBold16Black
                                        .copyWith(
                                            color: AppColors.primary)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Divider(height: 1),
                            const SizedBox(height: 12),
                            Text(
                              _result!,
                              style: AppTextStyles.semiBold16Black
                                  .copyWith(
                                      height: 1.6, fontSize: 14),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '⚠️ This is not a medical diagnosis. Please consult a healthcare professional.',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                  fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ),
                    ],

                    context.verticalSpace(30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
