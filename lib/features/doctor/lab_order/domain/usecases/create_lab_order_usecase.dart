import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/lab_order_entity.dart';
import '../repositories/lab_order_repository.dart';

class CreateLabOrderParams {
  final int recordId;
  final List<String> tests;
  final String clinicalIndication;
  final String priority;

  const CreateLabOrderParams({
    required this.recordId,
    required this.tests,
    required this.clinicalIndication,
    this.priority = 'Routine',
  });
}

class CreateLabOrderUseCase {
  final LabOrderRepository _repository;
  CreateLabOrderUseCase(this._repository);

  Future<Either<Failure, LabOrderEntity>> call(
      CreateLabOrderParams params) {
    return _repository.createLabOrder(
      recordId: params.recordId,
      tests: params.tests,
      clinicalIndication: params.clinicalIndication,
      priority: params.priority,
    );
  }
}
