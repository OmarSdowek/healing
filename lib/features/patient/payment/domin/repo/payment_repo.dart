import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entity/payment_entity.dart';

abstract class PaymentRepo {
  /// POST /api/invoices — create draft invoice with line items
  Future<Either<Failure, InvoiceEntity>> createInvoice({
    required int appointmentId,
    required int patientId,
    required double amount,
  });

  /// PUT /api/invoices/{id}/issue — finalise invoice (Draft -> Issued)
  Future<Either<Failure, InvoiceEntity>> issueInvoice(String invoiceId);

  /// POST /api/payments/intent/{invoiceId} — create Stripe PaymentIntent
  Future<Either<Failure, PaymentIntentEntity>> createPaymentIntent(
      String invoiceId);

  /// POST /api/payments/cash/{invoiceId} — record cash/walk-in payment
  Future<Either<Failure, PaymentConfirmEntity>> confirmCashPayment(
      String invoiceId, double amount);
}
