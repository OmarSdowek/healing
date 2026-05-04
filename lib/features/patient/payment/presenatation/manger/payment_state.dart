part of 'payment_cubit.dart';

abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentIntentCreated extends PaymentState {
  final PaymentIntentEntity intent;
  PaymentIntentCreated(this.intent);
}

class PaymentConfirmed extends PaymentState {
  final PaymentConfirmEntity confirm;
  PaymentConfirmed(this.confirm);
}

class PaymentError extends PaymentState {
  final String message;
  PaymentError(this.message);
}
