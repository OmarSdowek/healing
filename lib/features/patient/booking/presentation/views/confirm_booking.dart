import 'package:flutter/material.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_style.dart';
import '../../../../../core/constant/assets_manger.dart';
import '../../../../../core/route/routes.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_header.dart';
import '../widgets/doctor_profile.dart';

class ConfirmBooking extends StatefulWidget {
  const ConfirmBooking({super.key});

  @override
  State<ConfirmBooking> createState() => _ConfirmBookingState();
}

class _ConfirmBookingState extends State<ConfirmBooking> {
  String selectedMethod = "Credit Card";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.w(16),
            vertical: context.h(12),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomHeader(title: "Book Appointment"),
                context.verticalSpace(20),
            
                DoctorProfileSection(
                  image: AssetsManger.doctorImage,
                  name: "Mohamed Saeed",
                  speciality: "Physical Therapy",
                  onTap: () {},
                  isFavorite: false,
                ),
                context.verticalSpace(20),
            
                Row(
                  children: [
                    Text(
                      "Friday, July 17 at 4:00 pm",
                      style: AppTextStyles.semiBold16Black,
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Reschedule",
                        style: AppTextStyles.semiBold16Black.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                context.verticalSpace(20),
            
                Text("Billing Breakdown",
                    style: AppTextStyles.semiBold24dark.copyWith(color: AppColors.black)),
                context.verticalSpace(12),
                Container(
                  padding: EdgeInsets.all(context.r(12)),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(context.r(12)),
                  ),
                  child: Column(
                    children: [
                      const BillingRow(title: "Consultation Fee", amount: "400.00"),
                      context.verticalSpace(8),
                      Divider(height: context.h(15)),
            
                      const BillingRow(title: "Radiology (Chest X-Ray)", amount: "180.00"),
                      context.verticalSpace(8),
                      Divider(height: context.h(15)),
            
                      const BillingRow(title: "Lab Tests (Lipid Profile)", amount: "100.00"),
                      context.verticalSpace(8),
                      Divider(height: context.h(24)),
            
                      const BillingRow(title: "Total", amount: "680.00", isTotal: true),
                    ],
                  ),
                ),
                context.verticalSpace(10),
            
                /// Payment Method
                Text("Payment Method", style: AppTextStyles.semiBold16Black),
                context.verticalSpace(8),
                PaymentOption(
                  title: "Credit Card",
                  icon: AssetsManger.visa,
                  isSelected: selectedMethod == "Credit Card",
                  onTap: () {
                    setState(() => selectedMethod = "Credit Card");
                  },
                ),
                context.verticalSpace(8),
                PaymentOption(
                  title: "Stripe",
                  icon: AssetsManger.masterCard,
                  isSelected: selectedMethod == "Stripe",
                  onTap: () {
                    setState(() => selectedMethod = "Stripe");
                  },
                ),
                context.verticalSpace(8),
                PaymentOption(
                  title: "Apple Pay",
                  icon: AssetsManger.applePay,
                  isSelected: selectedMethod == "Apple Pay",
                  onTap: () {
                    setState(() => selectedMethod = "Apple Pay");
                  },
                ),
            
                   context.verticalSpace(25),
                /// Continue Pay Button
                CustomButton(
                  text: "Pay with $selectedMethod - 680.00",
                  onPressed: () {
                    print("Selected Payment Method: $selectedMethod");
                    Navigator.pushNamed(context, Routes.addNewCard);
                  },
                  backgroundColor: AppColors.primary,
                  textColor: Colors.white,
                  height: 50,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 🔹 Billing Row Widget
class BillingRow extends StatelessWidget {
  final String title;
  final String amount;
  final bool isTotal;

  const BillingRow({
    super.key,
    required this.title,
    required this.amount,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: isTotal ? AppTextStyles.semiBold16Black : AppTextStyles.reg20black,
        ),
        Text(
          amount,
          style: isTotal
              ? AppTextStyles.semiBold16Black.copyWith(color: AppColors.primaryDark)
              : AppTextStyles.reg20black,
        ),
      ],
    );
  }
}

/// 🔹 Payment Option Widget
class PaymentOption extends StatelessWidget {
  final String title;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentOption({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(context.r(12)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.r(8)),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Image.asset(icon, height: context.h(24)),
            context.horizontalSpace(12),
            Text(title, style: AppTextStyles.semiBold16Black),
          ],
        ),
      ),
    );
  }
}
