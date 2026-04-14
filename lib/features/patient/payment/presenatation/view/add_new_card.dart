import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:healing/core/widgets/custom_header.dart';
import 'package:healing/core/widgets/custom_button.dart';
import 'package:healing/core/widgets/custom_text_feild.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';

import '../../../booking/presentation/widgets/appointment_confirmation_section.dart';

class AddNewCardScreen extends StatefulWidget {
  const AddNewCardScreen({super.key});

  @override
  State<AddNewCardScreen> createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen> {
  final cardHolderController = TextEditingController();
  final cardNumberController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomHeader(title: "Add New Card"),
              context.verticalSpace(20),

              CreditCardWidget(
                cardNumber: cardNumberController.text.isEmpty
                    ? "6789 4567 5432 8903"
                    : cardNumberController.text,
                expiryDate: expiryController.text.isEmpty
                    ? "12/22"
                    : expiryController.text,
                cardHolderName: cardHolderController.text.isEmpty
                    ? "Ahmed Mohamed"
                    : cardHolderController.text,
                cvvCode: cvvController.text.isEmpty
                    ? "123"
                    : cvvController.text,
                showBackView: false,
                cardBgColor: AppColors.primary,
                labelCardHolder: "Spenny",
                onCreditCardWidgetChange: (CreditCardBrand p1) {},
              ),

              context.verticalSpace(20),

              Text("Cardholder Name", style: AppTextStyles.semiBold16Black),
              CustomTextFormField(
                hintText: "Enter cardholder name",
                controller: cardHolderController,
              ),
              context.verticalSpace(16),

              Text("Card Number", style: AppTextStyles.semiBold16Black),
              CustomTextFormField(
                hintText: "Enter card number",
                controller: cardNumberController,
              ),
              context.verticalSpace(16),

              Text("Expiry Date", style: AppTextStyles.semiBold16Black),
              CustomTextFormField(
                hintText: "MM/YY",
                controller: expiryController,
              ),
              context.verticalSpace(16),

              Text("CVV Code", style: AppTextStyles.semiBold16Black),
              CustomTextFormField(
                hintText: "Enter CVV",
                controller: cvvController,
              ),
              context.verticalSpace(24),

              CustomButton(
                text: "Save",
                onPressed: () {
                  setState(() {
                    // أي لوجيك للحفظ
                  });

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (ctx) {
                      return showConfirmationDialog(
                        context,
                        "Mohamed Samee",
                        "Physical Therapy",
                        DateTime(2028, 6, 13, 10, 0),
                        "400",
                        "Credit Card",
                      );
                    },
                  );
                },
                height: 48,
                backgroundColor: AppColors.primary,
                textColor: Colors.white,
              ),

            ],
          ),
        ),
      ),
    );
  }
}
