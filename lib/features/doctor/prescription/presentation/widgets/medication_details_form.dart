import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';

class MedicationDetailsForm extends StatelessWidget {
  final TextEditingController medicationNameController;
  final TextEditingController dosageController;
  final TextEditingController frequencyController;
  final TextEditingController durationController;

  const MedicationDetailsForm({
    super.key,
    required this.medicationNameController,
    required this.dosageController,
    required this.frequencyController,
    required this.durationController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.r(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FieldLabel("Medication Name"),
          context.verticalSpace(6),
          _InputField(
            controller: medicationNameController,
            hint: "Amoxicillin 500mg",
            suffix: Icon(
              Icons.search,
              color: AppColors.grey,
              size: context.sp(18),
            ),
          ),
          context.verticalSpace(14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FieldLabel("Dosage"),
                    context.verticalSpace(6),
                    _InputField(controller: dosageController, hint: "1 tablet"),
                  ],
                ),
              ),
              context.horizontalSpace(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FieldLabel("Frequency"),
                    context.verticalSpace(6),
                    _InputField(
                      controller: frequencyController,
                      hint: "Twice daily",
                    ),
                  ],
                ),
              ),
            ],
          ),
          context.verticalSpace(14),
          _FieldLabel("Duration"),
          context.verticalSpace(6),
          _InputField(
            controller: durationController,
            hint: "7 days",
            suffix: Icon(
              Icons.calendar_today_outlined,
              color: AppColors.grey,
              size: context.sp(18),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.semiBold16Black.copyWith(
        fontSize: context.sp(13),
        color: AppColors.grey,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Widget? suffix;

  const _InputField({
    required this.controller,
    required this.hint,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: AppTextStyles.semiBold16Black.copyWith(
        fontSize: context.sp(13),
        color: AppColors.primaryText,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.semiBold16Black.copyWith(
          fontSize: context.sp(13),
          color: AppColors.grey,
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFFF4F6FB),
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.w(14),
          vertical: context.h(12),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.r(10)),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
