import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entity/payment_entity.dart';
import '../repo/payment_repo.dart';

class CreateInvoiceUseCase {
  final PaymentRepo repo;
  CreateInvoiceUseCase(this.repo);

  Future<Either<Failure, InvoiceEntity>> call({
    required int appointmentId,
    required int patientId,
    required double amount,
  }) =>
      repo.createInvoice(
        appointmentId: appointmentId,
        patientId: patientId,
        amount: amount,
      );
}

class IssueInvoiceUseCase {
  final PaymentRepo repo;
  IssueInvoiceUseCase(this.repo);

  Future<Either<Failure, InvoiceEntity>> call(int invoiceId) =>
      repo.issueInvoice(invoiceId);
}

class CreatePaymentIntentUseCase {
  final PaymentRepo repo;
  CreatePaymentIntentUseCase(this.repo);

  Future<Either<Failure, PaymentIntentEntity>> call(int invoiceId) =>
      repo.createPaymentIntent(invoiceId);
}

class ConfirmCashPaymentUseCase {
  final PaymentRepo repo;
  ConfirmCashPaymentUseCase(this.repo);

  Future<Either<Failure, PaymentConfirmEntity>> call(int invoiceId) =>
      repo.confirmCashPayment(invoiceId);
}
