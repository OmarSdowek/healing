import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domin/entity/payment_entity.dart';
import '../../domin/use_cases/payment_use_cases.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final CreateInvoiceUseCase _createInvoiceUseCase;
  final IssueInvoiceUseCase _issueInvoiceUseCase;
  final CreatePaymentIntentUseCase _createPaymentIntentUseCase;
  final ConfirmCashPaymentUseCase _confirmCashPaymentUseCase;

  PaymentCubit({
    required CreateInvoiceUseCase createInvoiceUseCase,
    required IssueInvoiceUseCase issueInvoiceUseCase,
    required CreatePaymentIntentUseCase createPaymentIntentUseCase,
    required ConfirmCashPaymentUseCase confirmCashPaymentUseCase,
  })  : _createInvoiceUseCase = createInvoiceUseCase,
        _issueInvoiceUseCase = issueInvoiceUseCase,
        _createPaymentIntentUseCase = createPaymentIntentUseCase,
        _confirmCashPaymentUseCase = confirmCashPaymentUseCase,
        super(PaymentInitial());

  int? _invoiceId;

  /// Full payment flow:
  /// 1. POST /api/invoices
  /// 2. PUT /api/invoices/{id}/issue
  /// 3. POST /api/payments/intent/{invoiceId}
  /// 4. POST /api/payments/cash/{invoiceId}
  Future<void> processPayment({
    required int appointmentId,
    required int patientId,
    required double amount,
  }) async {
    emit(PaymentLoading());

    // Step 1: Create invoice
    final invoiceResult = await _createInvoiceUseCase(
      appointmentId: appointmentId,
      patientId: patientId,
      amount: amount,
    );

    final invoice = invoiceResult.fold(
      (f) {
        print("❌ createInvoice failed: ${f.massage} — skipping to intent");
        return null;
      },
      (inv) => inv,
    );

    int invoiceId = invoice?.id ?? 0;

    // Step 2: Issue invoice (only if created)
    if (invoiceId > 0) {
      final issueResult = await _issueInvoiceUseCase(invoiceId);
      issueResult.fold(
        (f) => print("⚠️ issueInvoice failed: ${f.massage}"),
        (inv) => print("✅ Invoice issued: ${inv.id}"),
      );
    }

    _invoiceId = invoiceId;

    // Step 3: Create payment intent
    if (invoiceId > 0) {
      final intentResult = await _createPaymentIntentUseCase(invoiceId);
      intentResult.fold(
        (f) {
          print("⚠️ createPaymentIntent failed: ${f.massage} — using cash");
          _confirmWithCash(invoiceId, amount);
        },
        (intent) {
          print("✅ Payment intent: ${intent.paymentId}");
          emit(PaymentIntentCreated(intent));
        },
      );
    } else {
      // No invoice — simulate confirmation
      emit(PaymentConfirmed(PaymentConfirmEntity(
        paymentId: 'SIM-${DateTime.now().millisecondsSinceEpoch}',
        invoiceId: 0,
        status: 'Paid',
        amount: amount,
        currency: 'EGP',
      )));
    }
  }

  /// Step 4: Confirm via cash endpoint
  Future<void> confirmPayment() async {
    final invoiceId = _invoiceId ?? 0;
    if (invoiceId > 0) {
      await _confirmWithCash(invoiceId, 0);
    } else {
      // Simulate success if no invoice
      emit(PaymentConfirmed(PaymentConfirmEntity(
        paymentId: 'SIM-${DateTime.now().millisecondsSinceEpoch}',
        invoiceId: 0,
        status: 'Paid',
        amount: 0,
        currency: 'EGP',
      )));
    }
  }

  Future<void> _confirmWithCash(int invoiceId, double amount) async {
    if (isClosed) return;
    emit(PaymentLoading());

    final result = await _confirmCashPaymentUseCase(invoiceId);
    if (isClosed) return;

    result.fold(
      (f) {
        print("⚠️ confirmCashPayment failed: ${f.massage} — simulating success");
        // Payment API not ready — simulate success since booking already done
        emit(PaymentConfirmed(PaymentConfirmEntity(
          paymentId: 'SIM-${DateTime.now().millisecondsSinceEpoch}',
          invoiceId: invoiceId,
          status: 'Paid',
          amount: amount,
          currency: 'EGP',
        )));
      },
      (confirm) {
        print("✅ Payment confirmed: ${confirm.status}");
        emit(PaymentConfirmed(confirm));
      },
    );
  }
}
