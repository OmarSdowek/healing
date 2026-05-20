class ApiEndpoints {
  static const String baseUrl = "https://crane-violate-dude.ngrok-free.dev";

  // ─── Auth ──────────────────────────────────────────────────────────────────
  static const String patientRegister = "/api/Auth/register";
  static const String patientLogin = "/api/Auth/login";
  static const String login = "/api/Auth/login";
  static const String patientVerifyEmail = "/api/Auth/verify-email";
  static const String verifyEmail = "/api/Auth/verify-email";
  static const String patientForgotPassword = "/api/Auth/forgot-password";
  static const String forgotPassword = "/api/Auth/forgot-password";
  static const String patientResetPassword = "/api/Auth/reset-password";
  static const String resetPassword = "/api/Auth/reset-password";
  static const String patientSetNewPassword = "/api/Auth/reset-password";
  static const String patientLogOut = "/api/Auth/logout";
  static const String logout = "/api/Auth/logout";
  static const String patientMe = "/api/Auth/me";
  static const String me = "/api/Auth/me";
  static const String register = "/api/Auth/register";
  static const String refreshToken = "/api/Auth/refresh";
  static const String changePassword = "/api/Auth/change-password";

  // ─── Doctors ───────────────────────────────────────────────────────────────
  static const String getDoctors = "/api/Doctors";
  static const String doctors = "/api/Doctors";
  static String getDoctorById(int id) => "/api/Doctors/$id";
  static String getDoctorDetails(int id) => "/api/Doctors/$id/details";
  static String doctorDetails(int id) => "/api/Doctors/$id/details";
  static String getDoctorsByDepartment(int deptId) =>
      "/api/Doctors/department/$deptId";
  static String departmentDoctors(int id) => "/api/Doctors/department/$id";
  static String getAvailableDoctors(String date) =>
      "/api/Doctors/available?date=$date";
  static String getDoctorSchedules(int id) => "/api/Doctors/$id/schedules";
  static String doctorSchedules(int id) => "/api/Doctors/$id/schedules";
  static String doctorQualifications(int id) =>
      "/api/Doctors/$id/qualifications";
  static const String doctorDashboard = "/api/Doctors/dashboard";

  // ─── Departments ───────────────────────────────────────────────────────────
  static const String getDepartments = "/api/department";
  static const String departments = "/api/Department";
  static String departmentById(int id) => "/api/Department/$id";

  // ─── Appointments ──────────────────────────────────────────────────────────
  static const String getAllAppointments = "/api/Appointments";
  static const String appointments = "/api/Appointments";
  static const String bookAppointment = "/api/Appointments";
  static String getAppointmentById(int id) => "/api/Appointments/$id";
  static String appointmentById(int id) => "/api/Appointments/$id";
  static String getPatientAppointments(int patientId) =>
      "/api/Appointments/patient/$patientId";
  static String getDoctorAppointments(int doctorId) =>
      "/api/Appointments/doctor/$doctorId";
  static String doctorAppointments(int doctorId) =>
      "/api/Appointments/doctor/$doctorId";
  static String doctorAllPatientAppointments(int doctorId) =>
      "/api/appointments/doctor/$doctorId/patients";
  static const String getAvailableSlots = "/api/Appointments/available-slots";
  static const String availableSlots = "/api/Appointments/available-slots";
  static String cancelAppointment(int id) => "/api/Appointments/$id/cancel";
  static String confirmAppointment(int id) => "/api/Appointments/$id/confirm";
  static String completeAppointment(int id) =>
      "/api/Appointments/$id/complete";
  static String noShowAppointment(int id) => "/api/Appointments/$id/no-show";

  // ─── Medical Records ───────────────────────────────────────────────────────
  static const String createMedicalRecord = "/api/medical-records";
  static const String medicalRecords = "/api/MedicalRecords";
  static String getMedicalReports(int patientId) =>
      "/api/medical-records/patient/$patientId";
  static String getMedicalReportDetail(String reportId) =>
      "/api/medical-records/$reportId";
  static String updateMedicalRecord(String id) => "/api/medical-records/$id";
  static String getDoctorMedicalRecords(int doctorId) =>
      "/api/medical-records/doctor/$doctorId";
  static String medicalRecordById(int id) => "/api/MedicalRecords/$id";
  static String addPrescriptionToRecord(int recordId) =>
      "/api/medical-records/$recordId/prescriptions";
  static String recordPrescriptions(int recordId) =>
      "/api/MedicalRecords/$recordId/prescriptions";
  static String addVitals(int recordId) =>
      "/api/medical-records/$recordId/vitals";
  static String recordVitals(int recordId) =>
      "/api/MedicalRecords/$recordId/vitals";
  static String addLabOrder(int recordId) =>
      "/api/medical-records/$recordId/lab-orders";
  static String recordLabOrders(int recordId) =>
      "/api/MedicalRecords/$recordId/lab-orders";

  // ─── Patients ──────────────────────────────────────────────────────────────
  static const String patients = "/api/Patients";
  static String patientById(int id) => "/api/Patients/$id";
  static String getPatientDetails(int patientId) =>
      "/api/patients/$patientId/details";
  static String patientDetails(int id) => "/api/Patients/$id/details";
  static String getPatientAllergies(int patientId) =>
      "/api/patients/$patientId/allergies";
  static String patientAllergies(int id) => "/api/Patients/$id/allergies";
  static String getPatientVitals(int patientId) =>
      "/api/patients/$patientId/vitals";
  static String patientMedicalHistories(int id) =>
      "/api/Patients/$id/medical-histories";
  static String patientEmergencyContacts(int id) =>
      "/api/Patients/$id/emergency-contacts";

  // ─── Prescriptions ─────────────────────────────────────────────────────────
  static String getPrescriptions(int patientId) =>
      "/api/patients/$patientId/prescriptions";
  static String getActivePrescriptions(int patientId) =>
      "/api/patients/$patientId/prescriptions/active";
  static String downloadPrescriptionPdf(int patientId, String prescriptionId) =>
      "/api/patients/$patientId/prescriptions/$prescriptionId/pdf";

  // ─── Notifications ─────────────────────────────────────────────────────────
  static const String getNotifications = "/api/notifications";
  static const String notifications = "/api/Notifications";
  static const String getUnreadNotifications = "/api/notifications/unread";
  static const String unreadNotifications = "/api/Notifications/unread";
  static const String getUnreadCount = "/api/notifications/unread/count";
  static const String unreadCount = "/api/Notifications/unread/count";
  static const String markAllRead = "/api/notifications/read-all";
  static const String readAll = "/api/Notifications/read-all";
  static String markNotificationRead(int id) =>
      "/api/notifications/$id/read";
  static String markRead(String id) => "/api/Notifications/$id/read";
  static const String getNotificationPreferences =
      "/api/notification-preferences";
  static const String notificationPreferences = "/api/NotificationPreferences";
  static const String resetNotificationPreferences =
      "/api/notification-preferences/reset";

  // ─── Payment ───────────────────────────────────────────────────────────────
  static const String createInvoice = "/api/invoices";
  static const String invoices = "/api/Invoices";
  static String issueInvoice(String invoiceId) =>
      "/api/invoices/$invoiceId/issue";
  static String invoiceById(String id) => "/api/Invoices/$id";
  static String invoiceLineItems(String invoiceId) =>
      "/api/Invoices/$invoiceId/line-items";
  static String invoiceIssue(String invoiceId) =>
      "/api/Invoices/$invoiceId/issue";
  static String invoicePdf(String invoiceId) => "/api/Invoices/$invoiceId/pdf";
  static String createPaymentIntent(String invoiceId) =>
      "/api/payments/intent/$invoiceId";
  static const String paymentsIntent = "/api/Payments/intent";
  static String confirmCashPayment(String invoiceId) =>
      "/api/payments/cash/$invoiceId";
  static const String paymentsCash = "/api/Payments/cash";
  static const String paymentsWebhook = "/api/Payments/webhook";
  static String getPatientPayments(int patientId) =>
      "/api/payments/patient/$patientId";

  // ─── Wards & Beds ──────────────────────────────────────────────────────────
  static const String wards = "/api/Wards";
  static String wardRooms(int wardId) => "/api/Wards/$wardId/rooms";
  static String roomBeds(int roomId) => "/api/Rooms/$roomId/beds";
  static const String availableBeds = "/api/Beds/available";
  static String bedStatus(int bedId) => "/api/Beds/$bedId/status";

  // ─── Admissions ────────────────────────────────────────────────────────────
  static const String admissions = "/api/Admissions";
  static String admissionTransfer(int admissionId) =>
      "/api/Admissions/$admissionId/transfer";
  static String admissionDischarge(int admissionId) =>
      "/api/Admissions/$admissionId/discharge";

  // ─── Insurance ─────────────────────────────────────────────────────────────
  static const String insuranceClaims = "/api/Insurance/claims";
  static String claimStatus(String claimId) =>
      "/api/Insurance/claims/$claimId/status";
  static String claimResubmit(String claimId) =>
      "/api/Insurance/claims/$claimId/resubmit";

  // ─── Reports ───────────────────────────────────────────────────────────────
  static const String revenueReport = "/api/Reports/revenue";
  static const String outstandingReport = "/api/Reports/outstanding";
  static const String revenueExport = "/api/Reports/revenue/export";

  // ─── Misc ───────────────────────────────────────────────────────────────────
  static const String supabaseKey =
      "sb_publishable_DT5mLTq-T8XeET-z6qC3TA_qvJNgZOf";
}
