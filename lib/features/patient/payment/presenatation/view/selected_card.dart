import 'package:flutter/material.dart';
import 'package:healing/core/widgets/custom_header.dart';
import 'package:healing/core/widgets/custom_button.dart';
import 'package:healing/core/constant/assets_manger.dart';
import '../../../../../core/route/routes.dart';
import '../widgets/payment_option_Item.dart';

class SelectedCardScreen extends StatelessWidget {
  const SelectedCardScreen({super.key});

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

              PaymentOptionItem(
                title: "Banque Misr (VISA)",
                iconPath: AssetsManger.visa,
                onTap: () {
                  Navigator.pushNamed(context, Routes.addNewCard);
                },
              ),

              const Spacer(),

              CustomButton(
                text: "+ Add Card",
                onPressed: () {
                  Navigator.pushNamed(context, Routes.paymentMethod);
                },
                height: 48,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
