import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entity/book_appointment_request.dart';
import '../repo/booking_repo.dart';
import '../../../../patient/appointment/domin/entity/appointment_entity.dart';

class BookAppointmentUseCase {
  final BookingRepo repo;

  BookAppointmentUseCase(this.repo);

  Future<Either<Failure, AppointmentEntity>> call(
    BookAppointmentRequest request,
  ) async {
    return await repo.bookAppointment(request);
  }
}
