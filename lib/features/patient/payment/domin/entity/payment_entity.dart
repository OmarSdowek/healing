/// Invoice created before payment — id is UUID string from API
class InvoiceEntity {
  final String id;
  final int appointmentId;
  final double amount;
  final String currency;
  final String status; // Draft, Issued, Paid, Cancelled

  InvoiceEntity({
    required this.id,
    required this.appointmentId,
    required this.amount,
    required this.currency,
    required this.status,
  });
}

/// Payment intent returned by POST /api/payments/intent/{invoiceId}
class PaymentIntentEntity {
  final String paymentId;
  final String invoiceId;
  final double amount;
  final String currency;
  final String status;
  final String? clientSecret;
  final String? stripePaymentIntentId;

  PaymentIntentEntity({
    required this.paymentId,
    required this.invoiceId,
    required this.amount,
    required this.currency,
    required this.status,
    this.clientSecret,
    this.stripePaymentIntentId,
  });
}

/// Payment confirmation result
class PaymentConfirmEntity {
  final String paymentId;
  final String invoiceId;
  final String status;
  final double amount;
  final String currency;
  final String? paidAt;
  final String? receiptUrl;

  PaymentConfirmEntity({
    required this.paymentId,
    required this.invoiceId,
    required this.status,
    required this.amount,
    required this.currency,
    this.paidAt,
    this.receiptUrl,
  });
}
