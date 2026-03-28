import 'package:dartz/dartz.dart';
import '../error/failure.dart';

abstract class UseCase<type> {
  Future<Either<Failure, type>> call();
}