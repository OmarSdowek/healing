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
  // static String cancelAppointment(int id) => "/api/Appointments/$id/cancel";
  //
  // /// PUT /api/Appointments/{id}/confirm — Doctor/Receptionist role
  // static String confirmAppointment(int id) => "/api/Appointments/$id/confirm";
  //
  // /// PUT /api/Appointments/{id}/complete — Doctor role
  // static String completeAppointment(int id) =>
  //     "/api/Appointments/$id/complete";
  //
  // /// PUT /api/Appointments/{id}/no-show — Doctor/Nurse role
  // static String noShowAppointment(int id) => "/api/Appointments/$id/no-show";

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
