import 'package:flutter/material.dart';
import 'package:healing/core/helper/extentions/media_query.dart';

import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_style.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_header.dart';
import '../../../../../core/widgets/custom_text_feild.dart';

class DoctorPersonalInformation extends StatefulWidget {
  const DoctorPersonalInformation({super.key});

  @override
  State<DoctorPersonalInformation> createState() =>
      _DoctorPersonalInformationState();
}

class _DoctorPersonalInformationState extends State<DoctorPersonalInformation> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final bloodController = TextEditingController();
  final idController = TextEditingController();
  final addressController = TextEditingController();

  // ✅ الجنس
  String? selectedGender;

  // ✅ الميلاد
  DateTime? selectedBirthday;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: context.w(12),
            vertical: context.h(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomHeader(title: "Personal information"),
              context.verticalSpace(20),

              /// Full Name
              Text("Full Name", style: AppTextStyles.semiBold16Black),
              context.verticalSpace(6),
              CustomTextFormField(
                hintText: "Enter full name",
                controller: nameController,
              ),
              context.verticalSpace(16),

              /// Phone Number
              Text("Phone Number", style: AppTextStyles.semiBold16Black),
              context.verticalSpace(6),
              CustomTextFormField(
                hintText: "Enter your phone",
                controller: phoneController,
                prefixIcon: const Icon(Icons.phone),
              ),
              context.verticalSpace(16),

              /// Email
              Text("Email", style: AppTextStyles.semiBold16Black),
              context.verticalSpace(6),
              CustomTextFormField(
                hintText: "Enter your email",
                controller: emailController,
                prefixIcon: const Icon(Icons.email),
              ),
              context.verticalSpace(16),

              /// Birthday (DatePicker)
              Text("Your birthday", style: AppTextStyles.semiBold16Black),
              context.verticalSpace(6),
              CustomButton(
                text: selectedBirthday == null
                    ? "Select your birthday"
                    : "${selectedBirthday!.day}/${selectedBirthday!.month}/${selectedBirthday!.year}",
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000, 1, 1),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() => selectedBirthday = picked);
                  }
                },
                height: 48,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                textColor: AppColors.primaryDark,
              ),
              context.verticalSpace(16),

              /// Gender (زرارين)
              Text("Gender", style: AppTextStyles.semiBold16Black),
              context.verticalSpace(6),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: "Male",
                      onPressed: () {
                        setState(() => selectedGender = "Male");
                      },
                      height: 45,
                      backgroundColor: selectedGender == "Male"
                          ? AppColors.primary
                          : AppColors.cardBackground,
                      textColor: selectedGender == "Male"
                          ? Colors.white
                          : AppColors.primaryDark,
                    ),
                  ),
                  context.horizontalSpace(12),
                  Expanded(
                    child: CustomButton(
                      text: "Female",
                      onPressed: () {
                        setState(() => selectedGender = "Female");
                      },
                      height: 45,
                      backgroundColor: selectedGender == "Female"
                          ? AppColors.primary
                          : AppColors.cardBackground,
                      textColor: selectedGender == "Female"
                          ? Colors.white
                          : AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
              context.verticalSpace(16),

              /// Blood Type
              Text("Blood Type", style: AppTextStyles.semiBold16Black),
              context.verticalSpace(6),
              CustomTextFormField(
                hintText: "Enter your Blood type",
                controller: bloodController,
              ),
              context.verticalSpace(16),

              /// National ID
              Text("National ID", style: AppTextStyles.semiBold16Black),
              context.verticalSpace(6),
              CustomTextFormField(
                hintText: "Enter your ID",
                controller: idController,
              ),
              context.verticalSpace(16),

              /// Address
              Text("Address", style: AppTextStyles.semiBold16Black),
              context.verticalSpace(6),
              CustomTextFormField(
                hintText: "Enter your address",
                controller: addressController,
              ),
              context.verticalSpace(24),

              /// زر الحفظ
              CustomButton(
                text: "Save",
                onPressed: () {
                  print("Name: ${nameController.text}");
                  print("Phone: ${phoneController.text}");
                  print("Email: ${emailController.text}");
                  print("Gender: $selectedGender");
                  print("Birthday: $selectedBirthday");
                  print("Blood: ${bloodController.text}");
                  print("ID: ${idController.text}");
                  print("Address: ${addressController.text}");
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
