import 'package:dio/dio.dart';

// ─── Groq constants ───────────────────────────────────────────────────────────
const String kGroqBaseUrl = 'https://api.groq.com/openai/v1';
const String kGroqModel = 'llama-3.3-70b-versatile';
const String kGroqVisionModel = 'meta-llama/llama-4-scout-17b-16e-instruct';
const String kGroqApiKey =
    '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';

/// AI Service using Groq API (free) — Llama 3.3 for text, Llama 4 for vision.
class GeminiService {
  static final _dio = Dio(BaseOptions(
    baseUrl: kGroqBaseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 60),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $kGroqApiKey',
    },
  ));

  // ── Chat with AI Assistant (Patient) ─────────────────────────────────────
  static Future<String> chatWithAssistant({
    required String userMessage,
  }) async {
    return _generate(
      model: kGroqModel,
      systemMsg: '''You are "Healing AI Assistant", a friendly and knowledgeable medical assistant in the Healing hospital app.
You help patients with:
- Understanding symptoms and what they might indicate
- Explaining medications and prescriptions in simple terms
- General health advice and wellness tips
- When to seek immediate medical attention

Rules:
- Always be warm, clear, and supportive
- Never diagnose definitively — always say "may indicate" or "could be"
- Always recommend seeing a doctor for serious concerns
- Keep responses concise and easy to understand
- Use bullet points for lists
- Respond in the same language the user writes in (Arabic or English)''',
      userMsg: userMessage,
    );
  }

  // ── Analyze Symptoms (Patient) ────────────────────────────────────────────
  static Future<String> analyzeSymptoms({
    required List<String> symptoms,
  }) async {
    final symptomList = symptoms.map((s) => '- $s').join('\n');

    return _generate(
      model: kGroqModel,
      systemMsg:
          'You are a helpful medical assistant providing preliminary symptom analysis. '
          'Always remind users to consult a doctor. Be clear, concise, and supportive. '
          'IMPORTANT: Respond in the same language the user writes in (Arabic or English).',
      userMsg: '''A patient has the following symptoms:
$symptomList

Please provide:
1. Possible conditions these symptoms may indicate (list 2-3 most likely)
2. Severity assessment (mild / moderate / needs urgent attention)
3. General self-care advice
4. When to see a doctor immediately

Be clear, simple, and caring. This is for a general audience.''',
    );
  }

  // ── Generate Medical Record Summary (Doctor) ──────────────────────────────
  static Future<String> generateMedicalSummary({
    required String diagnosis,
    String? clinicalNotes,
    String? treatmentPlan,
    String? vitals,
    String? patientName,
  }) async {
    final parts = [
      'Generate a professional medical summary for this patient visit.',
      'Patient: ${patientName ?? 'Patient'}',
      'Diagnosis: $diagnosis',
      if (clinicalNotes != null && clinicalNotes.isNotEmpty)
        'Clinical Notes: $clinicalNotes',
      if (treatmentPlan != null && treatmentPlan.isNotEmpty)
        'Treatment Plan: $treatmentPlan',
      if (vitals != null && vitals.isNotEmpty) 'Vitals: $vitals',
      '',
      'Provide: 1) Brief summary 2) Key findings 3) Follow-up actions.',
    ];

    return _generate(
      model: kGroqModel,
      systemMsg:
          'You are an experienced medical assistant helping doctors. Be concise and professional. '
          'IMPORTANT: Respond in the same language used in the medical data (Arabic or English).',
      userMsg: parts.join('\n'),
    );
  }

  // ── Explain Prescription (Patient) ───────────────────────────────────────
  static Future<String> explainPrescription({
    required List<Map<String, String>> medications,
    String? doctorNotes,
  }) async {
    final medList = medications
        .map((m) =>
            '- ${m['name']} | Dosage: ${m['dosage']} | Frequency: ${m['frequency']} | Duration: ${m['duration']}')
        .join('\n');

    final parts = [
      'Please explain this prescription in simple terms a patient can understand:',
      '',
      'Medications:',
      medList,
      if (doctorNotes != null && doctorNotes.isNotEmpty)
        "\nDoctor's Notes: $doctorNotes",
      '',
      'Explain: 1) What each medication is for 2) How/when to take it 3) Important tips.',
    ];

    return _generate(
      model: kGroqModel,
      systemMsg:
          'You are a friendly medical assistant helping patients understand their prescriptions. '
          'Use simple, clear language. Be warm and reassuring. '
          'IMPORTANT: Respond in the same language the patient uses (Arabic or English).',
      userMsg: parts.join('\n'),
    );
  }

  // ── Core call ─────────────────────────────────────────────────────────────
  static Future<String> _generate({
    required String model,
    required String systemMsg,
    required String userMsg,
  }) async {
    try {
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': model,
          'messages': [
            {'role': 'system', 'content': systemMsg},
            {'role': 'user', 'content': userMsg},
          ],
          'max_tokens': 1024,
          'temperature': 0.7,
        },
      );

      final choices = response.data['choices'] as List?;
      if (choices == null || choices.isEmpty) return 'No response generated.';
      return choices[0]['message']['content'] as String? ??
          'No response generated.';
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final msg = e.response?.data?['error']?['message'] ??
          e.message ??
          'Unknown error';
      throw Exception('AI error ($status): $msg');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
