import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entity/payment_entity.dart';

abstract class PaymentRepo {
  /// POST /api/invoices — create draft invoice for appointment
  Future<Either<Failure, InvoiceEntity>> createInvoice({
    required int appointmentId,
    required int patientId,
    required double amount,
  });

  /// PUT /api/invoices/{id}/issue — issue the invoice
  Future<Either<Failure, InvoiceEntity>> issueInvoice(int invoiceId);

  /// POST /api/payments/intent/{invoiceId} — create payment intent
  Future<Either<Failure, PaymentIntentEntity>> createPaymentIntent(
      int invoiceId);

  /// POST /api/payments/cash/{invoiceId} — simulate confirmation
  Future<Either<Failure, PaymentConfirmEntity>> confirmCashPayment(
      int invoiceId);
}
