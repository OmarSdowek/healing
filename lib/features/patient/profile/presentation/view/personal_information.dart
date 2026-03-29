import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import '../../../../../core/widgets/custom_header.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text_feild.dart';

class PersonalInformationScreen extends StatelessWidget {
  const PersonalInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final genderController = TextEditingController();
    final bloodController = TextEditingController();
    final idController = TextEditingController();
    final addressController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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

              /// Birthday (Dropdowns)
              Text("Your birthday", style: AppTextStyles.semiBold16Black),
              context.verticalSpace(6),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: DropdownButtonFormField<int>(
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                      items: List.generate(
                        31,
                            (i) => DropdownMenuItem(value: i + 1, child: Text("${i + 1}")),
                      ),
                      onChanged: (_) {},
                    ),
                  ),
                  context.horizontalSpace(6),

                  Flexible(
                    flex: 2, // الشهر بياخد مساحة أكبر
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                      items: [
                        "January","February","March","April","May","June",
                        "July","August","September","October","November","December"
                      ].map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                      onChanged: (_) {},
                    ),
                  ),
                  context.horizontalSpace(6),

                  Flexible(
                    flex: 1,
                    child: DropdownButtonFormField<int>(
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                      items: List.generate(
                        50,
                            (i) => DropdownMenuItem(value: 1980 + i, child: Text("${1980 + i}")),
                      ),
                      onChanged: (_) {},
                    ),
                  ),
                ],
              ),
              context.verticalSpace(16),

              /// Gender
              Text("Gender", style: AppTextStyles.semiBold16Black),
              context.verticalSpace(6),
              CustomTextFormField(
                hintText: "Write your gender",
                controller: genderController,
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
                  // 🔹 هنا تعمل لوجيك حفظ البيانات
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
