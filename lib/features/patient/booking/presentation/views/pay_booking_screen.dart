import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/constant/assets_manger.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../../../../core/widgets/custom_header.dart';
import '../widgets/appointment_confirmation_section.dart';
import '../widgets/doctor_profile.dart';
import '../widgets/price_pay_section.dart';

class PaymentScreen extends StatefulWidget {
  final String doctorName;
  final String speciality;
  final String image;
  final DateTime appointmentDate;

  const PaymentScreen({
    super.key,
    required this.doctorName,
    required this.speciality,
    required this.image,
    required this.appointmentDate,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int selectedIndex = 0; // 0 = Credit Card

  @override
  Widget build(BuildContext context) {
    final dayName = _dayName(widget.appointmentDate.weekday);
    final monthName = _monthName(widget.appointmentDate.month);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.w(12),
            vertical: context.h(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomHeader(title: "Book Appointment"),
              context.verticalSpace(20),

              DoctorProfileSection(
                name: widget.doctorName,
                speciality: widget.speciality,
                image: widget.image,
              ),
              context.verticalSpace(15),

              /// Appointment
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$dayName, $monthName ${widget.appointmentDate.day} – ${_formatTime(widget.appointmentDate)}",
                    style: AppTextStyles.semiBold16Black,
                  ),
                  Text(
                    "Reschedule",
                    style: AppTextStyles.reg20black.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              context.verticalSpace(20),

              Text("Payment Method",
                  style: AppTextStyles.semiBold24dark),

              context.verticalSpace(15),

              /// Credit Card
              _PaymentOption(
                title: "Credit Card",
                icons: [AssetsManger.visa, AssetsManger.masterCard],
                isSelected: selectedIndex == 0,
                onTap: () => setState(() => selectedIndex = 0),
              ),

              /// PayPal
              _PaymentOption(
                title: "PayPal",
                icons: [AssetsManger.paypal],
                isSelected: selectedIndex == 1,
                onTap: () => setState(() => selectedIndex = 1),
              ),

              /// Apple Pay
              _PaymentOption(
                title: "Apple Pay",
                icons: [AssetsManger.applePay],
                isSelected: selectedIndex == 2,
                onTap: () => setState(() => selectedIndex = 2),
              ),

              context.verticalSpace(15),

              /// Add new card
              DottedBorder(
                options: RoundedRectDottedBorderOptions(
                  radius: Radius.circular(context.r(12)),
                  dashPattern: const [6, 4],
                  color: AppColors.primary,                ),
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: context.h(14)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: AppColors.primary),
                        context.horizontalSpace(6),
                        Text(
                          "Add new card",
                          style: AppTextStyles.semiBold16Black
                              .copyWith(color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              context.verticalSpace(20),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
      PriceAndPaySection(
          text: "Pay",
          price: 350,
        onPressed: () {
          showConfirmationDialog(
            context,
            "Mohamed Saeed",
            DateTime(2026, 7, 30, 10, 0),
          );
        },

      ),
    );
  }

  /// Helpers
  String _dayName(int weekday) =>
      ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"][weekday - 1];

  String _monthName(int month) =>
      ["January","February","March","April","May","June","July","August","September","October","November","December"][month - 1];

  String _formatTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final suffix = date.hour >= 12 ? "pm" : "am";
    return "$hour:$minute$suffix";
  }
}
class _PaymentOption extends StatelessWidget {
  final String title;
  final List<String> icons;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.title,
    required this.icons,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: context.h(8)),
        padding: EdgeInsets.all(context.r(12)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(context.r(12)),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            /// Radio
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColors.primary : Colors.grey,
            ),

            context.horizontalSpace(10),

            /// Title
            Text(title, style: AppTextStyles.reg20black),

            const Spacer(),

            /// Icons
            Row(
              children: icons
                  .map((icon) => Padding(
                padding: EdgeInsets.only(left: context.w(8)),
                child: Image.asset(icon, height: context.h(24)),
              ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}