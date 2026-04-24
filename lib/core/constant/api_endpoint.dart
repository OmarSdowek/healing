class ApiEndpoints {
  static const String baseUrl = "https://mhhrwgxvxbkmxbsmxbfa.supabase.co";
  static const String supabaseKey =
      "sb_publishable_DT5mLTq-T8XeET-z6qC3TA_qvJNgZOf";

  // ── Auth ──────────────────────────────────────────────
  static const String login = "/api/auth/login";
  static const String register = "/api/auth/register";
  static const String verifyEmail = "/api/auth/verify-email";
  static const String forgotPassword = "/api/auth/forgot-password";
  static const String resetPassword = "/api/auth/reset-password";
  static const String refreshToken = "/api/auth/refresh";
  static const String logout = "/api/auth/logout";
  static const String me = "/api/auth/me";

  // ── Doctor ────────────────────────────────────────────
  static const String doctors = "/api/doctors";
  static String doctorDetails(int id) => "/api/doctors/$id/details";
  static String doctorSchedules(int id) => "/api/doctors/$id/schedules";

  // ── Appointments ──────────────────────────────────────
  static const String appointments = "/api/appointments";
  static const String availableSlots = "/api/appointments/available-slots";
  static String doctorAppointments(int doctorId) =>
      "/api/appointments/doctor/$doctorId";
  static String appointmentById(int id) => "/api/appointments/$id";
  static String confirmAppointment(int id) => "/api/appointments/$id/confirm";
  static String completeAppointment(int id) => "/api/appointments/$id/complete";
  static String cancelAppointment(int id) => "/api/appointments/$id/cancel";
  static String noShowAppointment(int id) => "/api/appointments/$id/no-show";

  // ── Medical Records ───────────────────────────────────
  static const String medicalRecords = "/api/medical-records";
  static String medicalRecordById(int id) => "/api/medical-records/$id";
  static String prescriptions(int recordId) =>
      "/api/medical-records/$recordId/prescriptions";
  static String cancelPrescription(int recordId, int prescriptionId) =>
      "/api/medical-records/$recordId/prescriptions/$prescriptionId";

  // ── Notifications ─────────────────────────────────────
  static const String notifications = "/api/notifications";
  static const String unreadNotifications = "/api/notifications/unread";
  static const String unreadCount = "/api/notifications/unread/count";
  static const String readAll = "/api/notifications/read-all";
  static String markRead(String id) => "/api/notifications/$id/read";
}
