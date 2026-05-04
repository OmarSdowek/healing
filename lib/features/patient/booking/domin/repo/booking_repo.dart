import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entity/book_appointment_request.dart';
import '../entity/time_slot_entity.dart';
import '../../../../patient/appointment/domin/entity/appointment_entity.dart';

abstract class BookingRepo {
  Future<Either<Failure, List<TimeSlotEntity>>> getAvailableSlots({
    required int doctorId,
    required String date, // YYYY-MM-DD
  });

  Future<Either<Failure, AppointmentEntity>> bookAppointment(
    BookAppointmentRequest request,
  );
}
