# Patient API Integration Plan

## 📋 Overview
This document outlines the plan to integrate all Patient-related API endpoints from the HMS API documentation into the Flutter app.

---

## ✅ Already Implemented

### Authentication
- ✅ Register (`POST /api/auth/register`)
- ✅ Login (`POST /api/auth/login`)
- ✅ Verify Email (`GET /api/auth/verify-email`)
- ✅ Logout (`POST /api/auth/logout`)
- ✅ Delete Account
- ✅ Get User Profile (`GET /api/auth/me`)

### Doctors
- ✅ Get Available Doctors (`GET /api/Doctors/available`)

---

## 🔨 To Be Implemented

### 1. Home Screen Features

#### A. Departments/Specialities (Priority: HIGH)
**Endpoint:** `GET /api/department`
**Purpose:** Display speciality chips at top of home screen
**Response:**
```json
[
  { "id": 1, "name": "Cardiology", "phoneExtension": "1001" },
  { "id": 4, "name": "Neurology", "phoneExtension": "1004" }
]
```

**Implementation:**
- Create `DepartmentModel` ✅
- Create `GetDepartmentsUseCase`
- Add to `HomeCubit` state
- Display as horizontal chips in `HomeScreen`
- On tap → filter doctors by department

#### B. Doctors by Department
**Endpoint:** `GET /api/doctors/department/{deptId}`
**Purpose:** Filter doctors when user taps a speciality chip
**Implementation:**
- Create `GetDoctorsByDepartmentUseCase`
- Add to `HomeCubit`
- Update UI to show filtered doctors

---

### 2. Appointments Feature (Priority: HIGH)

#### A. View Patient Appointments
**Endpoint:** `GET /api/appointments/patient/{patientId}`
**Purpose:** Show upcoming appointments on home screen
**Response:**
```json
[
  {
    "id": 1,
    "confirmationNumber": "APT-20260310-A1B2C3",
    "patientId": 1,
    "patientName": "Ahmed Hassan",
    "doctorId": 1,
    "doctorName": "Khaled Mansour",
    "doctorSpecialization": "Interventional Cardiology",
    "appointmentDate": "2026-03-10",
    "startTime": "09:00:00",
    "endTime": "09:30:00",
    "status": "Confirmed",
    "type": "InPerson",
    "reasonForVisit": "Annual cardiac checkup"
  }
]
```

**Implementation:**
- Create `AppointmentModel` ✅
- Create `GetPatientAppointmentsUseCase`
- Create `AppointmentCubit`
- Display upcoming appointments section in `HomeScreen`
- Filter for `status == 'Scheduled' || 'Confirmed'`

#### B. Cancel Appointment
**Endpoint:** `PUT /api/appointments/{id}/cancel?reason=...`
**Business Rule:** Cannot cancel within 2 hours of appointment start time
**Implementation:**
- Create `CancelAppointmentUseCase`
- Add to `AppointmentCubit`
- Show confirmation dialog
- Handle 422 error (too close to appointment time)

#### C. Reschedule Appointment (3-step flow)
**Step 1:** Get available slots
**Endpoint:** `GET /api/appointments/available-slots?doctorId=1&date=2026-04-15`

**Step 2:** Cancel existing appointment
**Endpoint:** `PUT /api/appointments/{id}/cancel?reason=Rescheduling`

**Step 3:** Book new appointment
**Endpoint:** `POST /api/appointments`
**Request:**
```json
{
  "patientId": 1,
  "doctorId": 1,
  "appointmentDate": "2026-04-15",
  "startTime": "09:00:00",
  "type": "InPerson",
  "reasonForVisit": "Annual cardiac checkup"
}
```

**Implementation:**
- Create `GetAvailableSlotsUseCase`
- Create `BookAppointmentUseCase`
- Create reschedule flow in `AppointmentCubit`
- UI: Date picker → Show available slots → Confirm → Execute 3 steps

---

### 3. Medical Records Feature (Priority: MEDIUM)

#### A. View Patient Details
**Endpoint:** `GET /api/patients/{id}/details`
**Purpose:** Show full patient history (allergies, medical history, emergency contacts)
**Implementation:**
- Create `PatientDetailsModel`
- Create `GetPatientDetailsUseCase`
- Create `MedicalRecordsCubit`
- Create `PatientDetailsScreen`

#### B. View Prescriptions
**Endpoint:** `GET /api/patients/{patientId}/prescriptions`
**Endpoint:** `GET /api/patients/{patientId}/prescriptions/active` (active only)
**Implementation:**
- Create `PrescriptionModel`
- Create `GetPrescriptionsUseCase`
- Display in `PrescriptionsScreen`

#### C. View Lab Orders
**Endpoint:** `GET /api/patients/{patientId}/lab-orders`
**Implementation:**
- Create `LabOrderModel`
- Create `GetLabOrdersUseCase`
- Display in `LabOrdersScreen`

#### D. View Vitals History
**Endpoint:** `GET /api/patients/{patientId}/vitals`
**Endpoint:** `GET /api/patients/{patientId}/vitals/latest` (latest only)
**Implementation:**
- Create `VitalsModel`
- Create `GetVitalsUseCase`
- Display in `VitalsScreen`

---

## 📁 File Structure

```
lib/features/patient/
├── home/
│   ├── data/
│   │   ├── model/
│   │   │   ├── doctor_model.dart ✅
│   │   │   └── department_model.dart ✅
│   │   └── repo/
│   │       └── home_repo_impl.dart ✅
│   ├── domain/
│   │   ├── repo/
│   │   │   └── home_repo.dart
│   │   └── use_cases/
│   │       ├── get_doctors_use_case.dart ✅
│   │       ├── get_departments_use_case.dart (NEW)
│   │       └── get_doctors_by_department_use_case.dart (NEW)
│   └── presentation/
│       ├── manger/
│       │   └── home_cubit/ ✅
│       ├── view/
│       │   └── home_screen.dart ✅
│       └── widgets/
│           ├── department_chip.dart (NEW)
│           └── upcoming_appointment_card.dart (NEW)
│
├── appointment/
│   ├── data/
│   │   ├── model/
│   │   │   ├── appointment_model.dart ✅
│   │   │   ├── available_slot_model.dart (NEW)
│   │   │   └── book_appointment_request.dart (NEW)
│   │   └── repo/
│   │       └── appointment_repo_impl.dart (NEW)
│   ├── domain/
│   │   ├── repo/
│   │   │   └── appointment_repo.dart (NEW)
│   │   └── use_cases/
│   │       ├── get_patient_appointments_use_case.dart (NEW)
│   │       ├── cancel_appointment_use_case.dart (NEW)
│   │       ├── get_available_slots_use_case.dart (NEW)
│   │       └── book_appointment_use_case.dart (NEW)
│   └── presentation/
│       ├── manger/
│       │   └── appointment_cubit.dart (NEW)
│       └── view/
│           ├── appointments_screen.dart (EXISTS)
│           └── book_appointment_screen.dart (NEW)
│
└── medical_records/
    ├── data/
    │   ├── model/
    │   │   ├── prescription_model.dart (NEW)
    │   │   ├── lab_order_model.dart (NEW)
    │   │   └── vitals_model.dart (NEW)
    │   └── repo/
    │       └── medical_records_repo_impl.dart (NEW)
    ├── domain/
    │   ├── repo/
    │   │   └── medical_records_repo.dart (NEW)
    │   └── use_cases/
    │       ├── get_prescriptions_use_case.dart (NEW)
    │       ├── get_lab_orders_use_case.dart (NEW)
    │       └── get_vitals_use_case.dart (NEW)
    └── presentation/
        ├── manger/
        │   └── medical_records_cubit.dart (NEW)
        └── view/
            ├── prescriptions_screen.dart (NEW)
            ├── lab_orders_screen.dart (NEW)
            └── vitals_screen.dart (NEW)
```

---

## 🎯 Implementation Priority

### Phase 1: Home Screen Enhancement (URGENT)
1. ✅ Create `DepartmentModel`
2. Add Departments API to `HomeRepoImpl`
3. Create `GetDepartmentsUseCase`
4. Update `HomeCubit` to load departments
5. Create `DepartmentChip` widget
6. Update `HomeScreen` to display departments chips
7. Add filter by department functionality

### Phase 2: Appointments (HIGH)
1. ✅ Create `AppointmentModel`
2. Create Appointment repository & use cases
3. Create `AppointmentCubit`
4. Add upcoming appointments section to `HomeScreen`
5. Implement cancel functionality
6. Implement reschedule flow

### Phase 3: Medical Records (MEDIUM)
1. Create models for prescriptions, lab orders, vitals
2. Create repository & use cases
3. Create screens for each feature
4. Link from profile/settings

---

## 🔗 API Endpoints Summary

| Feature | Method | Endpoint | Status |
|---------|--------|----------|--------|
| **Auth** |
| Register | POST | `/api/auth/register` | ✅ |
| Login | POST | `/api/auth/login` | ✅ |
| Logout | POST | `/api/auth/logout` | ✅ |
| Me | GET | `/api/auth/me` | ✅ |
| **Home** |
| Get Departments | GET | `/api/department` | ❌ |
| Get Doctors | GET | `/api/Doctors/available` | ✅ |
| Get Doctors by Dept | GET | `/api/doctors/department/{id}` | ❌ |
| **Appointments** |
| Get Patient Appointments | GET | `/api/appointments/patient/{id}` | ❌ |
| Cancel Appointment | PUT | `/api/appointments/{id}/cancel` | ❌ |
| Get Available Slots | GET | `/api/appointments/available-slots` | ❌ |
| Book Appointment | POST | `/api/appointments` | ❌ |
| **Medical Records** |
| Get Prescriptions | GET | `/api/patients/{id}/prescriptions` | ❌ |
| Get Lab Orders | GET | `/api/patients/{id}/lab-orders` | ❌ |
| Get Vitals | GET | `/api/patients/{id}/vitals` | ❌ |
| Get Patient Details | GET | `/api/patients/{id}/details` | ❌ |

---

## 📝 Notes

### Business Rules to Remember:
1. ⚠️ Cannot cancel appointment within 2 hours of start time (422 error)
2. ⚠️ Cannot book on a day doctor has no schedule
3. ⚠️ Reschedule = Cancel old + Book new (no single endpoint)
4. ⚠️ Filter appointments by status: `Scheduled` or `Confirmed` for upcoming

### Error Handling:
- 400: Validation failed
- 401: Unauthorized (token expired)
- 403: Forbidden (wrong role)
- 404: Not found
- 409: Conflict (duplicate)
- 422: Business rule violation

---

## 🚀 Next Steps

1. Start with Phase 1 (Departments in Home Screen)
2. Test each feature thoroughly
3. Handle all error cases
4. Add loading states
5. Add empty states
6. Add success/error messages

---

**Status:** Ready to implement Phase 1
**Last Updated:** 2026-04-28
