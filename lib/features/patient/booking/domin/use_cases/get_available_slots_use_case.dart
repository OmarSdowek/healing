import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entity/time_slot_entity.dart';
import '../repo/booking_repo.dart';

class GetAvailableSlotsUseCase {
  final BookingRepo repo;

  GetAvailableSlotsUseCase(this.repo);

  Future<Either<Failure, List<TimeSlotEntity>>> call({
    required int doctorId,
    required String date,
  }) async {
    return await repo.getAvailableSlots(doctorId: doctorId, date: date);
  }
}
