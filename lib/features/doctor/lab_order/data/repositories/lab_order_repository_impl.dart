import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/constant/api_endpoint.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/network/api_service.dart';
import '../../../../../core/network/error_handling.dart';
import '../../domain/entities/lab_order_entity.dart';
import '../../domain/repositories/lab_order_repository.dart';

class LabOrderRepositoryImpl implements LabOrderRepository {
  final ApiService _api;
  LabOrderRepositoryImpl(this._api);

  @override
  Future<Either<Failure, LabOrderEntity>> createLabOrder({
    required int recordId,
    required List<String> tests,
    required String clinicalIndication,
    String priority = 'Routine',
  }) async {
    try {
      // API accepts one lab order per request — create orders for each test
      // Use the first test as primary, others as separate orders
      final firstTest = tests.isNotEmpty ? tests.first : 'General';

      final response = await _api.post(
        ApiEndpoints.addLabOrder(recordId),
        data: {
          'testName': firstTest,
          'testCode': '',
          'priority': priority,
          'notes': clinicalIndication.isNotEmpty ? clinicalIndication : null,
        },
      );

      final json = response.data as Map<String, dynamic>? ?? {};

      // Create additional orders for remaining tests
      for (int i = 1; i < tests.length; i++) {
        try {
          await _api.post(
            ApiEndpoints.addLabOrder(recordId),
            data: {
              'testName': tests[i],
              'testCode': '',
              'priority': priority,
              'notes': clinicalIndication.isNotEmpty
                  ? clinicalIndication
                  : null,
            },
          );
        } catch (_) {}
      }

      return Right(LabOrderEntity(
        id: ((json['id'] ?? json['Id']) as num?)?.toInt(),
        recordId: recordId,
        tests: tests,
        clinicalIndication: clinicalIndication,
        priority: priority,
        status: (json['status'] ?? json['Status'])?.toString(),
        createdAt: (json['createdAt'] ?? json['CreatedAt'])?.toString(),
      ));
    } on DioException catch (e) {
      return Left(Failure(ErrorHandler.handle(e).message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
