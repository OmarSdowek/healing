class ApiEndpoints {
  static const String baseUrl = "https://crane-violate-dude.ngrok-free.dev";

  // ─── Auth ──────────────────────────────────────────────────────────────────
  static const String patientRegister = "/api/Auth/register";
  static const String patientLogin = "/api/Auth/login";
  static const String patientVerifyEmail = "/api/Auth/verify-email";
  static const String patientForgotPassword = "/api/Auth/forgot-password";
  static const String patientResetPassword = "/api/Auth/reset-password";
  static const String patientSetNewPassword = "/api/Auth/reset-password";
  static const String patientLogOut = "/api/Auth/logout";
  static const String patientMe = "/api/Auth/me";

  // ─── Doctors ───────────────────────────────────────────────────────────────

  /// GET /api/Doctors?status=Active&pageIndex=1&pageSize=20
  /// Main endpoint — paginated, supports search/status/departmentId filters
  /// Used for: home screen doctors list, booking picker
  static const String getDoctors = "/api/Doctors";

  /// GET /api/Doctors/{id} — doctor summary
  static String getDoctorById(int id) => "/api/Doctors/$id";

  /// GET /api/Doctors/{id}/details — full doctor details with bio & qualifications
  static String getDoctorDetails(int id) => "/api/Doctors/$id/details";

  /// GET /api/Doctors/department/{deptId} — doctors filtered by department
  static String getDoctorsByDepartment(int deptId) =>
      "/api/Doctors/department/$deptId";

  /// GET /api/Doctors/available?date={date} — active doctors with schedule on date
  static String getAvailableDoctors(String date) =>
      "/api/Doctors/available?date=$date";

  /// GET /api/Doctors/{id}/schedules — doctor's weekly schedule
  static String getDoctorSchedules(int id) => "/api/Doctors/$id/schedules";

  /// GET /api/department — all departments (403 for Patient role — use fallback)
  static const String getDepartments = "/api/department";

  // ─── Appointments ──────────────────────────────────────────────────────────

  /// GET /api/Appointments — all appointments (admin/receptionist)
  static const String getAllAppointments = "/api/Appointments";

  /// GET /api/Appointments/{id} — single appointment by ID
  static String getAppointmentById(int id) => "/api/Appointments/$id";

  /// GET /api/Appointments/patient/{patientId} — patient's appointments
  static String getPatientAppointments(int patientId) =>
      "/api/Appointments/patient/$patientId";

  /// GET /api/Appointments/doctor/{doctorId} — doctor's appointments
  static String getDoctorAppointments(int doctorId) =>
      "/api/Appointments/doctor/$doctorId";

  /// GET /api/Appointments/available-slots?doctorId={id}&date={date}
  static const String getAvailableSlots = "/api/Appointments/available-slots";

  /// POST /api/Appointments — book appointment
  static const String bookAppointment = "/api/Appointments";

  /// PUT /api/Appointments/{id}/cancel?reason={reason} — Patient role
  static String cancelAppointment(int id) => "/api/Appointments/$id/cancel";

  /// PUT /api/Appointments/{id}/confirm — Doctor/Receptionist role
  static String confirmAppointment(int id) => "/api/Appointments/$id/confirm";

  /// PUT /api/Appointments/{id}/complete — Doctor role
  static String completeAppointment(int id) =>
      "/api/Appointments/$id/complete";

  /// PUT /api/Appointments/{id}/no-show — Doctor/Nurse role
  static String noShowAppointment(int id) => "/api/Appointments/$id/no-show";

  // ─── Notifications ─────────────────────────────────────────────────────────

  /// GET /api/notifications — all notifications
  static const String getNotifications = "/api/notifications";

  /// GET /api/notifications/unread — unread notifications only
  static const String getUnreadNotifications = "/api/notifications/unread";

  /// GET /api/notifications/unread/count — unread count
  static const String getUnreadCount = "/api/notifications/unread/count";

  /// PUT /api/notifications/{id}/read — mark single as read
  static String markNotificationRead(int id) =>
      "/api/notifications/$id/read";

  /// PUT /api/notifications/read-all — mark all as read
  static const String markAllRead = "/api/notifications/read-all";

  static const String getNotificationPreferences =
      "/api/notification-preferences";
  static const String resetNotificationPreferences =
      "/api/notification-preferences/reset";

  // ─── Payment ───────────────────────────────────────────────────────────────

  /// POST /api/invoices — create draft invoice for appointment
  static const String createInvoice = "/api/invoices";

  /// PUT /api/invoices/{id}/issue — issue the invoice
  static String issueInvoice(int invoiceId) =>
      "/api/invoices/$invoiceId/issue";

  /// POST /api/payments/intent/{invoiceId} — create payment intent
  static String createPaymentIntent(int invoiceId) =>
      "/api/payments/intent/$invoiceId";

  /// POST /api/payments/cash/{invoiceId} — simulate cash/card confirmation
  static String confirmCashPayment(int invoiceId) =>
      "/api/payments/cash/$invoiceId";

  /// GET /api/payments/patient/{patientId} — payment history
  static String getPatientPayments(int patientId) =>
      "/api/payments/patient/$patientId";

  // ─── Medical Records ───────────────────────────────────────────────────────

  /// GET /api/medical-records/patient/{patientId} — patient's medical records
  static String getMedicalReports(int patientId) =>
      "/api/medical-records/patient/$patientId";

  /// GET /api/medical-records/{id} — single medical record
  static String getMedicalReportDetail(String reportId) =>
      "/api/medical-records/$reportId";

  /// POST /api/medical-records — create medical record (Doctor role)
  static const String createMedicalRecord = "/api/medical-records";

  /// PUT /api/medical-records/{id} — update medical record (Doctor role)
  static String updateMedicalRecord(String id) => "/api/medical-records/$id";

  // ─── Prescriptions ─────────────────────────────────────────────────────────

  /// GET /api/patients/{patientId}/prescriptions — all prescriptions
  static String getPrescriptions(int patientId) =>
      "/api/patients/$patientId/prescriptions";

  /// GET /api/patients/{patientId}/prescriptions/active — active prescriptions only
  static String getActivePrescriptions(int patientId) =>
      "/api/patients/$patientId/prescriptions/active";
}
