import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/constant/api_endpoint.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/network/api_service.dart';
import '../../../../../core/network/error_handling.dart';
import '../../../appointment/data/model/appointment_model.dart';
import '../../../appointment/domin/entity/appointment_entity.dart';
import '../../domin/entity/book_appointment_request.dart';
import '../../domin/entity/time_slot_entity.dart';
import '../../domin/repo/booking_repo.dart';
import '../model/time_slot_model.dart';

class BookingRepoImpl implements BookingRepo {
  final ApiService api;

  BookingRepoImpl(this.api);

  @override
  Future<Either<Failure, List<TimeSlotEntity>>> getAvailableSlots({
    required int doctorId,
    required String date,
  }) async {
    try {
      print("🔥 BookingRepoImpl: getAvailableSlots(doctorId=$doctorId, date=$date)");

      final response = await api.get(
        ApiEndpoints.getAvailableSlots,
        queryParameters: {'doctorId': doctorId, 'date': date},
      );

      print("✅ Slots response: ${response.data}");

      final data = response.data as List;
      final slots = data.map((e) => TimeSlotModel.fromJson(e)).toList();

      print("✅ Parsed ${slots.length} slots");
      return Right(slots);
    } on DioException catch (e) {
      print("❌ Error getting slots: ${e.response?.statusCode} - ${e.message}");
      return Left(Failure(ErrorHandler.handle(e).message));
    } catch (e) {
      print("❌ Unexpected error getting slots: $e");
      return Left(Failure("Failed to load slots: $e"));
    }
  }

  @override
  Future<Either<Failure, AppointmentEntity>> bookAppointment(
    BookAppointmentRequest request,
  ) async {
    try {
      print("🔥 BookingRepoImpl: bookAppointment() called");
      print("🔥 Request: ${request.toJson()}");

      final response = await api.post(
        ApiEndpoints.bookAppointment,
        data: request.toJson(),
      );

      print("✅ Booking response: ${response.data}");

      final appointment = AppointmentModel.fromJson(
        response.data as Map<String, dynamic>,
      );

      print("✅ Appointment booked: ${appointment.confirmationNumber}");
      return Right(appointment);
    } on DioException catch (e) {
      print("❌ Error booking appointment: ${e.response?.statusCode} - ${e.message}");
      print("❌ Error body: ${e.response?.data}");
      return Left(Failure(ErrorHandler.handle(e).message));
    } catch (e) {
      print("❌ Unexpected error booking: $e");
      return Left(Failure("Failed to book appointment: $e"));
    }
  }
}
