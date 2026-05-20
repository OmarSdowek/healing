import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/route/routes.dart';
import 'package:healing/core/widgets/custom_button.dart';
import 'package:healing/core/widgets/custom_header.dart';
import 'package:healing/core/widgets/custom_text_feild.dart';
import '../../../booking/presentation/widgets/appointment_confirmation_section.dart';

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
  bool _isLoading = false;

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
      _cardNumberCtrl.text.trim().length >= 16 &&
      _expiryCtrl.text.trim().isNotEmpty &&
      _cvvCtrl.text.trim().length >= 3;

  void _onPay(Map<String, dynamic>? args) {
    if (!_isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all card details'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulate processing delay then show success dialog
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showConfirmation(args);
    });
  }

  void _showConfirmation(Map<String, dynamic>? args) {
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
    final feeAmount = double.tryParse(fees) ?? 0.0;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomHeader(title: 'Add New Card'),
              context.verticalSpace(20),

              // ── Live Card Preview ─────────────────────────────────────
              CreditCardWidget(
                cardNumber: _cardNumberCtrl.text.isEmpty
                    ? '0000 0000 0000 0000'
                    : _cardNumberCtrl.text,
                expiryDate:
                    _expiryCtrl.text.isEmpty ? '00/00' : _expiryCtrl.text,
                cardHolderName: _cardHolderCtrl.text.isEmpty
                    ? 'Card Holder'
                    : _cardHolderCtrl.text,
                cvvCode: _cvvCtrl.text.isEmpty ? '000' : _cvvCtrl.text,
                showBackView: false,
                cardBgColor: AppColors.primary,
                labelCardHolder: 'Card Holder',
                onCreditCardWidgetChange: (_) {},
              ),

              context.verticalSpace(8),

              // ── Amount Summary ────────────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Amount to pay',
                        style: AppTextStyles.semiBold16Black),
                    Text(
                      feeAmount > 0 ? '$fees EGP' : 'Fee not available',
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

              // ── Cardholder Name ───────────────────────────────────────
              Text('Cardholder Name',
                  style: AppTextStyles.semiBold16Black),
              context.verticalSpace(8),
              CustomTextFormField(
                hintText: 'Enter cardholder name',
                controller: _cardHolderCtrl,
                onChanged: (_) => setState(() {}),
              ),
              context.verticalSpace(16),

              // ── Card Number ───────────────────────────────────────────
              Text('Card Number', style: AppTextStyles.semiBold16Black),
              context.verticalSpace(8),
              CustomTextFormField(
                hintText: '1234 5678 9012 3456',
                controller: _cardNumberCtrl,
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() {}),
              ),
              context.verticalSpace(16),

              // ── Expiry & CVV ──────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Expiry Date',
                            style: AppTextStyles.semiBold16Black),
                        context.verticalSpace(8),
                        CustomTextFormField(
                          hintText: 'MM/YY',
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
                        Text('CVV Code',
                            style: AppTextStyles.semiBold16Black),
                        context.verticalSpace(8),
                        CustomTextFormField(
                          hintText: '123',
                          controller: _cvvCtrl,
                          keyboardType: TextInputType.number,
                          onChanged: (_) => setState(() {}),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              context.verticalSpace(12),

              // ── Security note ─────────────────────────────────────────
              Row(
                children: [
                  Icon(Icons.lock_outline,
                      size: 14, color: Colors.grey.shade500),
                  const SizedBox(width: 6),
                  Text(
                    'Secured by Stripe — your card details are encrypted',
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),

              context.verticalSpace(32),

              // ── Pay Button ────────────────────────────────────────────
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : CustomButton(
                      text: feeAmount > 0 ? 'Pay $fees EGP' : 'Confirm Booking',
                      onPressed: () => _onPay(args),
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
