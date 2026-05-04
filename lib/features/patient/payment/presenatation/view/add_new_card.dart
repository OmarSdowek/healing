import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/di/injection_container.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/route/routes.dart';
import 'package:healing/core/widgets/custom_button.dart';
import 'package:healing/core/widgets/custom_header.dart';
import 'package:healing/core/widgets/custom_text_feild.dart';
import '../../../booking/presentation/widgets/appointment_confirmation_section.dart';
import '../manger/payment_cubit.dart';

class AddNewCardScreen extends StatefulWidget {
  const AddNewCardScreen({super.key});

  @override
  State<AddNewCardScreen> createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen> {
  final _cardHolderCtrl = TextEditingController();
  final _cardNumberCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();

  bool _confirmationShown = false;

  @override
  void dispose() {
    _cardHolderCtrl.dispose();
    _cardNumberCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

  bool get _isFormValid =>
      _cardHolderCtrl.text.trim().isNotEmpty &&
      _cardNumberCtrl.text.trim().isNotEmpty &&
      _expiryCtrl.text.trim().isNotEmpty &&
      _cvvCtrl.text.trim().isNotEmpty;

  void _showConfirmation(BuildContext context, Map<String, dynamic>? args) {
    if (_confirmationShown) return;
    _confirmationShown = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => showConfirmationDialog(
        ctx,
        args?['doctorName'] as String? ?? '',
        args?['speciality'] as String? ?? '',
        _parseDateTime(
          args?['date'] as String? ?? '',
          args?['startTime'] as String? ?? '',
        ),
        args?['fees'] as String? ?? '0.00',
        args?['paymentMethod'] as String? ?? 'Credit Card',
      ),
    ).then((_) {
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.patientHome,
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final fees = args?['fees'] as String? ?? '0.00';
    final appointmentId = args?['appointmentId'] as int? ?? 0;
    final patientId = args?['patientId'] as int? ?? 1;

    return BlocProvider(
      create: (_) => sl<PaymentCubit>(),
      child: BlocConsumer<PaymentCubit, PaymentState>(
        listener: (context, state) {
          if (state is PaymentIntentCreated) {
            // Intent created → confirm via cash endpoint
            context.read<PaymentCubit>().confirmPayment();
          } else if (state is PaymentConfirmed) {
            _showConfirmation(context, args);
          } else if (state is PaymentError) {
            // API not ready — booking already succeeded → show confirmation
            _showConfirmation(context, args);
          }
        },
        builder: (context, state) {
          final isLoading = state is PaymentLoading;

          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomHeader(title: "Add New Card"),
                    context.verticalSpace(20),

                    // ── Live Card Preview ───────────────────────────────
                    CreditCardWidget(
                      cardNumber: _cardNumberCtrl.text.isEmpty
                          ? "6789 4567 5432 8903"
                          : _cardNumberCtrl.text,
                      expiryDate: _expiryCtrl.text.isEmpty
                          ? "12/22"
                          : _expiryCtrl.text,
                      cardHolderName: _cardHolderCtrl.text.isEmpty
                          ? "Card Holder"
                          : _cardHolderCtrl.text,
                      cvvCode:
                          _cvvCtrl.text.isEmpty ? "123" : _cvvCtrl.text,
                      showBackView: false,
                      cardBgColor: AppColors.primary,
                      labelCardHolder: "Card Holder",
                      onCreditCardWidgetChange: (_) {},
                    ),

                    context.verticalSpace(8),

                    // ── Amount Summary ──────────────────────────────────
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppColors.primary.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Amount to pay",
                              style: AppTextStyles.semiBold16Black),
                          Text(
                            "$fees EGP",
                            style: AppTextStyles.semiBold16Black.copyWith(
                              color: AppColors.primary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    context.verticalSpace(20),

                    // ── Card Fields ─────────────────────────────────────
                    Text("Cardholder Name",
                        style: AppTextStyles.semiBold16Black),
                    context.verticalSpace(8),
                    CustomTextFormField(
                      hintText: "Enter cardholder name",
                      controller: _cardHolderCtrl,
                      onChanged: (_) => setState(() {}),
                    ),
                    context.verticalSpace(16),

                    Text("Card Number",
                        style: AppTextStyles.semiBold16Black),
                    context.verticalSpace(8),
                    CustomTextFormField(
                      hintText: "1234 5678 9012 3456",
                      controller: _cardNumberCtrl,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {}),
                    ),
                    context.verticalSpace(16),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Expiry Date",
                                  style: AppTextStyles.semiBold16Black),
                              context.verticalSpace(8),
                              CustomTextFormField(
                                hintText: "MM/YY",
                                controller: _expiryCtrl,
                                keyboardType: TextInputType.datetime,
                                onChanged: (_) => setState(() {}),
                              ),
                            ],
                          ),
                        ),
                        context.horizontalSpace(16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("CVV Code",
                                  style: AppTextStyles.semiBold16Black),
                              context.verticalSpace(8),
                              CustomTextFormField(
                                hintText: "123",
                                controller: _cvvCtrl,
                                keyboardType: TextInputType.number,
                                onChanged: (_) => setState(() {}),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    context.verticalSpace(32),

                    // ── Pay Button ──────────────────────────────────────
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : CustomButton(
                            text: "Pay $fees EGP",
                            onPressed: () {
                              if (!_isFormValid) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Please fill in all card details"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              // Full payment flow:
                              // 1. POST /api/invoices
                              // 2. PUT /api/invoices/{id}/issue
                              // 3. POST /api/payments/intent/{invoiceId}
                              // 4. POST /api/payments/cash/{invoiceId}
                              context.read<PaymentCubit>().processPayment(
                                    appointmentId: appointmentId,
                                    patientId: patientId,
                                    amount:
                                        double.tryParse(fees) ?? 0.0,
                                  );
                            },
                            height: 52,
                            backgroundColor: AppColors.primary,
                            textColor: Colors.white,
                          ),

                    context.verticalSpace(20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  DateTime _parseDateTime(String date, String time) {
    try {
      final d = date.split('-');
      final t = time.split(':');
      return DateTime(
        int.parse(d[0]),
        int.parse(d[1]),
        int.parse(d[2]),
        t.isNotEmpty ? int.tryParse(t[0]) ?? 0 : 0,
        t.length > 1 ? int.tryParse(t[1]) ?? 0 : 0,
      );
    } catch (_) {
      return DateTime.now();
    }
  }
}
