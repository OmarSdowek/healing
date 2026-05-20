import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/constant/api_endpoint.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/network/api_service.dart';
import '../../../../../core/network/error_handling.dart';
import '../../domin/entity/payment_entity.dart';
import '../../domin/repo/payment_repo.dart';

class PaymentRepoImpl implements PaymentRepo {
  final ApiService api;
  PaymentRepoImpl(this.api);

  // ─── POST /api/invoices ───────────────────────────────────────────────────
  // Body per API guide: { patientId, appointmentId, lineItems: [...] }
  @override
  Future<Either<Failure, InvoiceEntity>> createInvoice({
    required int appointmentId,
    required int patientId,
    required double amount,
  }) async {
    try {
      print("🔥 PaymentRepo: createInvoice(appointmentId=$appointmentId, amount=$amount)");
      final response = await api.post(
        ApiEndpoints.createInvoice,
        data: {
          'patientId': patientId,
          'appointmentId': appointmentId,
          'lineItems': [
            {
              'description': 'Consultation Fee',
              'lineItemType': 'Consultation',
              'quantity': 1,
              'unitPrice': amount,
            }
          ],
        },
      );
      print("✅ Invoice created: ${response.data}");
      return Right(_parseInvoice(response.data, amount));
    } on DioException catch (e) {
      print("❌ createInvoice: ${e.response?.statusCode} - ${e.message}");
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  // ─── PUT /api/invoices/{id}/issue ─────────────────────────────────────────
  // Body per API guide: { discountAmount, discountPercent, taxPercent }
  @override
  Future<Either<Failure, InvoiceEntity>> issueInvoice(String invoiceId) async {
    try {
      print("🔥 PaymentRepo: issueInvoice($invoiceId)");
      final response = await api.put(
        ApiEndpoints.issueInvoice(invoiceId),
        data: {
          'discountAmount': 0,
          'discountPercent': 0,
          'taxPercent': 0,
        },
      );
      print("✅ Invoice issued: ${response.data}");
      return Right(_parseInvoice(response.data, 0));
    } on DioException catch (e) {
      print("❌ issueInvoice: ${e.response?.statusCode} - ${e.message}");
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  // ─── POST /api/payments/intent/{invoiceId} ────────────────────────────────
  // Response: { invoiceId, stripePaymentIntentId, clientSecret, amount }
  @override
  Future<Either<Failure, PaymentIntentEntity>> createPaymentIntent(
      String invoiceId) async {
    try {
      print("🔥 PaymentRepo: createPaymentIntent(invoiceId=$invoiceId)");
      final response =
          await api.post(ApiEndpoints.createPaymentIntent(invoiceId));
      print("✅ Payment intent: ${response.data}");
      final data = response.data as Map<String, dynamic>;
      return Right(PaymentIntentEntity(
        paymentId: data['stripePaymentIntentId']?.toString() ?? '',
        invoiceId: invoiceId,
        amount: (data['amount'] as num?)?.toDouble() ?? 0,
        currency: 'EGP',
        status: 'Pending',
        clientSecret: data['clientSecret']?.toString(),
        stripePaymentIntentId:
            data['stripePaymentIntentId']?.toString(),
      ));
    } on DioException catch (e) {
      print("❌ createPaymentIntent: ${e.response?.statusCode} - ${e.message}");
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  // ─── POST /api/payments/cash/{invoiceId} ──────────────────────────────────
  // Body per API guide: { amount }
  @override
  Future<Either<Failure, PaymentConfirmEntity>> confirmCashPayment(
      String invoiceId, double amount) async {
    try {
      print("🔥 PaymentRepo: confirmCashPayment(invoiceId=$invoiceId, amount=$amount)");
      final response = await api.post(
        ApiEndpoints.confirmCashPayment(invoiceId),
        data: {'amount': amount},
      );
      print("✅ Payment confirmed: ${response.data}");
      final data = response.data as Map<String, dynamic>;
      return Right(PaymentConfirmEntity(
        paymentId: data['id']?.toString() ?? '',
        invoiceId: invoiceId,
        status: data['status']?.toString() ?? 'Succeeded',
        amount: (data['amount'] as num?)?.toDouble() ?? amount,
        currency: 'EGP',
        paidAt: data['paidAt']?.toString(),
        receiptUrl: data['receiptUrl']?.toString(),
      ));
    } on DioException catch (e) {
      print("❌ confirmCashPayment: ${e.response?.statusCode} - ${e.message}");
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  InvoiceEntity _parseInvoice(dynamic data, double fallbackAmount) {
    if (data is Map<String, dynamic>) {
      return InvoiceEntity(
        id: data['id']?.toString() ?? '',
        appointmentId:
            (data['appointmentId'] as num?)?.toInt() ?? 0,
        amount: (data['totalAmount'] as num?)?.toDouble() ??
            (data['subTotal'] as num?)?.toDouble() ??
            fallbackAmount,
        currency: 'EGP',
        status: data['status']?.toString() ?? 'Draft',
      );
    }
    return InvoiceEntity(
        id: '',
        appointmentId: 0,
        amount: fallbackAmount,
        currency: 'EGP',
        status: 'Draft');
  }
}
