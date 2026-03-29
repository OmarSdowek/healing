import 'package:flutter/material.dart';
import 'package:healing/core/widgets/custom_header.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/constant/assets_manger.dart';
import '../../../../../core/route/routes.dart';
import '../widgets/payment_option_Item.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomHeader(title: "Payment Method"),
              const SizedBox(height: 20),

              Text("Credit / Debit Card", style: AppTextStyles.semiBold16Black),
              PaymentOptionItem(
                title: "VISA Banque Misr",
                iconPath: AssetsManger.visa,
                onTap: () {},
              ),
              PaymentOptionItem(
                title: "Master Card",
                iconPath: AssetsManger.masterCard,
                onTap: () {
                  Navigator.pushNamed(context, Routes.addNewCard);
                },
              ),

              const SizedBox(height: 20),
              Text("Mobile Wallets", style: AppTextStyles.semiBold16Black),
              PaymentOptionItem(
                title: "VISA Banque Misr",
                iconPath: AssetsManger.visa,
                onTap: () {},
              ),
              PaymentOptionItem(
                title: "PayPal",
                iconPath: AssetsManger.paypal,
                onTap: () {},
              ),
              PaymentOptionItem(
                title: "Apple Pay",
                iconPath: AssetsManger.applePay,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
