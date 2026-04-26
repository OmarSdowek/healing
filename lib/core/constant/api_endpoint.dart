class ApiEndpoints {
  static const String baseUrl = "https://crane-violate-dude.ngrok-free.dev";
  static const String supabaseKey =
      "sb_publishable_DT5mLTq-T8XeET-z6qC3TA_qvJNgZOf";

  // ── Auth ──────────────────────────────────────────────
  static const String login = "/api/Auth/login";
  static const String register = "/api/Auth/register";
  static const String verifyEmail = "/api/Auth/verify-email";
  static const String forgotPassword = "/api/Auth/forgot-password";
  static const String resetPassword = "/api/Auth/reset-password";
  static const String refreshToken = "/api/Auth/refresh";
  static const String logout = "/api/Auth/logout";
  static const String me = "/api/Auth/me";

  // ── Doctor ────────────────────────────────────────────
  static const String doctors = "/api/Doctors";
  static String doctorDetails(int id) => "/api/Doctors/$id/details";
  static String doctorSchedules(int id) => "/api/Doctors/$id/schedules";
  static String doctorQualifications(int id) =>
      "/api/Doctors/$id/qualifications";
  static const String doctorDashboard = "/api/Doctors/dashboard";
  static String doctorAppointments(int doctorId) =>
      "/api/Appointments/doctor/$doctorId";

  // ── Appointments ──────────────────────────────────────
  static const String appointments = "/api/Appointments";
  static const String availableSlots = "/api/Appointments/available-slots";
  static String appointmentById(int id) => "/api/Appointments/$id";
  static String confirmAppointment(int id) => "/api/Appointments/$id/confirm";
  static String completeAppointment(int id) => "/api/Appointments/$id/complete";
  static String cancelAppointment(int id) => "/api/Appointments/$id/cancel";
  static String noShowAppointment(int id) => "/api/Appointments/$id/no-show";

  // ── Medical Records ───────────────────────────────────
  static const String medicalRecords = "/api/MedicalRecords";
  static String medicalRecordById(int id) => "/api/MedicalRecords/$id";
  static String recordVitals(int recordId) =>
      "/api/MedicalRecords/$recordId/vitals";
  static String recordPrescriptions(int recordId) =>
      "/api/MedicalRecords/$recordId/prescriptions";
  static String recordLabOrders(int recordId) =>
      "/api/MedicalRecords/$recordId/lab-orders";

  // ── Patients ──────────────────────────────────────────
  static const String patients = "/api/Patients";
  static String patientById(int id) => "/api/Patients/$id";
  static String patientDetails(int id) => "/api/Patients/$id/details";
  static String patientAllergies(int id) => "/api/Patients/$id/allergies";
  static String patientMedicalHistories(int id) =>
      "/api/Patients/$id/medical-histories";
  static String patientEmergencyContacts(int id) =>
      "/api/Patients/$id/emergency-contacts";

  // ── Wards & Beds ──────────────────────────────────────
  static const String wards = "/api/Wards";
  static String wardRooms(int wardId) => "/api/Wards/$wardId/rooms";
  static String roomBeds(int roomId) => "/api/Rooms/$roomId/beds";
  static const String availableBeds = "/api/Beds/available";
  static String bedStatus(int bedId) => "/api/Beds/$bedId/status";

  // ── Admissions ────────────────────────────────────────
  static const String admissions = "/api/Admissions";
  static String admissionTransfer(int admissionId) =>
      "/api/Admissions/$admissionId/transfer";
  static String admissionDischarge(int admissionId) =>
      "/api/Admissions/$admissionId/discharge";

  // ── Invoices & Payments ───────────────────────────────
  static const String invoices = "/api/Invoices";
  static String invoiceById(String id) => "/api/Invoices/$id";
  static String invoiceLineItems(String invoiceId) =>
      "/api/Invoices/$invoiceId/line-items";
  static String invoiceIssue(String invoiceId) =>
      "/api/Invoices/$invoiceId/issue";
  static String invoicePdf(String invoiceId) => "/api/Invoices/$invoiceId/pdf";
  static const String paymentsCash = "/api/Payments/cash";
  static const String paymentsIntent = "/api/Payments/intent";
  static const String paymentsWebhook = "/api/Payments/webhook";

  // ── Insurance ─────────────────────────────────────────
  static const String insuranceClaims = "/api/Insurance/claims";
  static String claimStatus(String claimId) =>
      "/api/Insurance/claims/$claimId/status";
  static String claimResubmit(String claimId) =>
      "/api/Insurance/claims/$claimId/resubmit";

  // ── Reports ───────────────────────────────────────────
  static const String revenueReport = "/api/Reports/revenue";
  static const String outstandingReport = "/api/Reports/outstanding";
  static const String revenueExport = "/api/Reports/revenue/export";

  // ── Notifications ─────────────────────────────────────
  static const String notifications = "/api/Notifications";
  static const String unreadNotifications = "/api/Notifications/unread";
  static const String unreadCount = "/api/Notifications/unread/count";
  static const String readAll = "/api/Notifications/read-all";
  static String markRead(String id) => "/api/Notifications/$id/read";
  static const String notificationPreferences = "/api/NotificationPreferences";

  // ── Departments ───────────────────────────────────────
  static const String departments = "/api/Department";
  static String departmentById(int id) => "/api/Department/$id";
  static String departmentDoctors(int id) => "/api/Doctors/department/$id";
}
