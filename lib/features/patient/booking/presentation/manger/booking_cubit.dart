import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../appointment/domin/entity/appointment_entity.dart';
import '../../../booking/domin/entity/book_appointment_request.dart';
import '../../../booking/domin/entity/time_slot_entity.dart';
import '../../../booking/domin/use_cases/book_appointment_use_case.dart';
import '../../../booking/domin/use_cases/get_available_slots_use_case.dart';
import '../../../home/domin/entity/doctor_entity.dart';
import '../../../home/domin/use_cases/get_doctor_use_case.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final GetAvailableSlotsUseCase getAvailableSlotsUseCase;
  final BookAppointmentUseCase bookAppointmentUseCase;
  final GetDoctorUseCase getDoctorUseCase;

  BookingCubit(
    this.getAvailableSlotsUseCase,
    this.bookAppointmentUseCase,
    this.getDoctorUseCase,
  ) : super(BookingInitial());

  /// Fetch all available doctors (for doctor picker)
  Future<void> loadDoctors() async {
    print("🔥 BookingCubit: loadDoctors() called");
    emit(BookingDoctorsLoading());

    final result = await getDoctorUseCase();

    result.fold(
      (failure) {
        print("❌ BookingCubit: doctors error - ${failure.massage}");
        emit(BookingError(failure.massage));
      },
      (doctors) {
        print("✅ BookingCubit: Got ${doctors.length} doctors");
        emit(BookingDoctorsLoaded(List<DoctorEntity>.from(doctors)));
      },
    );
  }

  /// Fetch available slots for a doctor on a specific date
  Future<void> loadSlots({
    required int doctorId,
    required String date,
  }) async {
    print("🔥 BookingCubit: loadSlots(doctorId=$doctorId, date=$date)");
    emit(BookingSlotsLoading());

    final result = await getAvailableSlotsUseCase(
      doctorId: doctorId,
      date: date,
    );

    result.fold(
      (failure) {
        print("❌ BookingCubit: slots error - ${failure.massage}");
        emit(BookingError(failure.massage));
      },
      (slots) {
        print("✅ BookingCubit: Got ${slots.length} slots");
        emit(BookingSlotsLoaded(slots));
      },
    );
  }

  /// Book the appointment
  Future<void> book(BookAppointmentRequest request) async {
    print("🔥 BookingCubit: book() called");
    emit(BookingLoading());

    final result = await bookAppointmentUseCase(request);

    result.fold(
      (failure) {
        print("❌ BookingCubit: booking error - ${failure.massage}");
        emit(BookingError(failure.massage));
      },
      (appointment) {
        print("✅ BookingCubit: Booked! ${appointment.confirmationNumber}");
        emit(BookingSuccess(appointment));
      },
    );
  }
}
