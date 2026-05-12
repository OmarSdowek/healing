import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/lab_order_entity.dart';

abstract class LabOrderRepository {
  Future<Either<Failure, LabOrderEntity>> createLabOrder({
    required int recordId,
    required List<String> tests,
    required String clinicalIndication,
    String priority,
  });
}
