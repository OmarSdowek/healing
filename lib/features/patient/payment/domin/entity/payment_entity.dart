/// Invoice created before payment
class InvoiceEntity {
  final int id;
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

/// Payment intent created from invoice
class PaymentIntentEntity {
  final String paymentId;
  final int invoiceId;
  final double amount;
  final String currency;
  final String status;
  final String? clientSecret;
  final String? gatewayPaymentIntentId;

  PaymentIntentEntity({
    required this.paymentId,
    required this.invoiceId,
    required this.amount,
    required this.currency,
    required this.status,
    this.clientSecret,
    this.gatewayPaymentIntentId,
  });
}

/// Payment confirmation result
class PaymentConfirmEntity {
  final String paymentId;
  final int invoiceId;
  final String status; // Paid
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
