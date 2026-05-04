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
  @override
  Future<Either<Failure, InvoiceEntity>> createInvoice({
    required int appointmentId,
    required int patientId,
    required double amount,
  }) async {
    try {
      print("🔥 PaymentRepo: createInvoice(appointmentId=$appointmentId)");
      final response = await api.post(
        ApiEndpoints.createInvoice,
        data: {
          'appointmentId': appointmentId,
          'patientId': patientId,
          'amount': amount,
          'currency': 'EGP',
        },
      );
      print("✅ Invoice created: ${response.data}");
      return Right(_parseInvoice(response.data));
    } on DioException catch (e) {
      print("❌ createInvoice: ${e.response?.statusCode} - ${e.message}");
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  // ─── PUT /api/invoices/{id}/issue ─────────────────────────────────────────
  @override
  Future<Either<Failure, InvoiceEntity>> issueInvoice(int invoiceId) async {
    try {
      print("🔥 PaymentRepo: issueInvoice($invoiceId)");
      final response =
          await api.put(ApiEndpoints.issueInvoice(invoiceId));
      print("✅ Invoice issued: ${response.data}");
      return Right(_parseInvoice(response.data));
    } on DioException catch (e) {
      print("❌ issueInvoice: ${e.response?.statusCode} - ${e.message}");
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  // ─── POST /api/payments/intent/{invoiceId} ────────────────────────────────
  @override
  Future<Either<Failure, PaymentIntentEntity>> createPaymentIntent(
      int invoiceId) async {
    try {
      print("🔥 PaymentRepo: createPaymentIntent(invoiceId=$invoiceId)");
      final response = await api.post(
          ApiEndpoints.createPaymentIntent(invoiceId));
      print("✅ Payment intent: ${response.data}");
      final data = response.data as Map<String, dynamic>;
      return Right(PaymentIntentEntity(
        paymentId: data['paymentId']?.toString() ?? '',
        invoiceId: (data['invoiceId'] as num?)?.toInt() ?? invoiceId,
        amount: (data['amount'] as num?)?.toDouble() ?? 0,
        currency: data['currency']?.toString() ?? 'EGP',
        status: data['status']?.toString() ?? 'Pending',
        clientSecret: data['clientSecret']?.toString(),
        gatewayPaymentIntentId:
            data['gatewayPaymentIntentId']?.toString(),
      ));
    } on DioException catch (e) {
      print("❌ createPaymentIntent: ${e.response?.statusCode} - ${e.message}");
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  // ─── POST /api/payments/cash/{invoiceId} ──────────────────────────────────
  @override
  Future<Either<Failure, PaymentConfirmEntity>> confirmCashPayment(
      int invoiceId) async {
    try {
      print("🔥 PaymentRepo: confirmCashPayment(invoiceId=$invoiceId)");
      final response = await api.post(
          ApiEndpoints.confirmCashPayment(invoiceId));
      print("✅ Payment confirmed: ${response.data}");
      final data = response.data as Map<String, dynamic>;
      return Right(PaymentConfirmEntity(
        paymentId: data['paymentId']?.toString() ?? '',
        invoiceId: (data['invoiceId'] as num?)?.toInt() ?? invoiceId,
        status: data['status']?.toString() ?? 'Paid',
        amount: (data['amount'] as num?)?.toDouble() ?? 0,
        currency: data['currency']?.toString() ?? 'EGP',
        paidAt: data['paidAt']?.toString(),
        receiptUrl: data['receiptUrl']?.toString(),
      ));
    } on DioException catch (e) {
      print("❌ confirmCashPayment: ${e.response?.statusCode} - ${e.message}");
      return Left(Failure(ErrorHandler.handle(e).message));
    }
  }

  InvoiceEntity _parseInvoice(dynamic data) {
    if (data is Map<String, dynamic>) {
      return InvoiceEntity(
        id: (data['id'] as num?)?.toInt() ?? 0,
        appointmentId:
            (data['appointmentId'] as num?)?.toInt() ?? 0,
        amount: (data['amount'] as num?)?.toDouble() ?? 0,
        currency: data['currency']?.toString() ?? 'EGP',
        status: data['status']?.toString() ?? 'Draft',
      );
    }
    return InvoiceEntity(
        id: 0, appointmentId: 0, amount: 0, currency: 'EGP', status: 'Draft');
  }
}
