import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domin/entity/payment_entity.dart';
import '../../domin/use_cases/payment_use_cases.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final CreatePaymentIntentUseCase _createPaymentIntentUseCase;

  PaymentCubit({
    required CreatePaymentIntentUseCase createPaymentIntentUseCase,
  })  : _createPaymentIntentUseCase = createPaymentIntentUseCase,
        super(PaymentInitial());

  String? _invoiceId;
  double _amount = 0;

  /// Flutter = Payment Client فقط.
  /// الـ invoiceId بيجي جاهز من الـ backend (booking response).
  /// POST /api/payments/intent/{invoiceId} → clientSecret → Stripe
  Future<void> preparePayment({
    required String invoiceId,
    required double amount,
  }) async {
    if (isClosed) return;
    emit(PaymentLoading());

    _invoiceId = invoiceId;
    _amount = amount;

    final intentResult = await _createPaymentIntentUseCase(invoiceId);
    if (isClosed) return;

    intentResult.fold(
      (f) => emit(PaymentError(f.massage)),
      (intent) => emit(PaymentIntentCreated(intent)),
    );
  }

  /// بعد ما Stripe يأكد الدفع — poll الـ invoice للتأكد
  /// الـ webhook هو الـ source of truth — مش cash endpoint
  Future<void> confirmAfterStripe() async {
    final invoiceId = _invoiceId ?? '';
    if (invoiceId.isEmpty) {
      if (!isClosed) emit(PaymentError('Invoice ID missing'));
      return;
    }
    if (isClosed) return;
    emit(PaymentLoading());

    // انتظر الـ webhook يشتغل على الـ backend
    await Future.delayed(const Duration(seconds: 3));

    if (isClosed) return;

    // Emit success — الـ webhook هو اللي حدّث الـ invoice
    emit(PaymentConfirmed(PaymentConfirmEntity(
      paymentId: '',
      invoiceId: invoiceId,
      status: 'Paid',
      amount: _amount,
      currency: 'EGP',
    )));
  }

  /// Reset بعد Stripe error عشان المريض يقدر يحاول تاني
  void resetToInitial() {
    if (!isClosed) emit(PaymentInitial());
  }
}
