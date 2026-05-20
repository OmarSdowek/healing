import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import '../../../../../core/widgets/custom_header.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text_feild.dart';
import '../../../auth/data/model/me_data_model.dart';
import '../../../auth/presentatiion/manger/patient_auth_cubit.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final bloodController = TextEditingController();
  final idController = TextEditingController();
  final addressController = TextEditingController();

  String? selectedGender;
  DateTime? selectedBirthday;

  bool _isDataInitialized = false;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    bloodController.dispose();
    idController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void _initializeFormData(MeDataModel user) {
    if (_isDataInitialized) return; // Guard: prevent re-initialization

    print("🔥 Initializing form data for: ${user.fullName}");
    
    nameController.text = user.fullName;
    emailController.text = user.email;
    
    phoneController.text = "01285974635";
    bloodController.text = "A+";
    addressController.text = "Egypt";
    idController.text = "30415128965893";
    
    _isDataInitialized = true;
    print("✅ Form data initialized successfully");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<PatientAuthCubit, PatientAuthState>(
          builder: (context, state) {
            if (state is PatientAuthLoading) {
              return const Center(child: CircularProgressIndicator());
            } 
            
            if (state is PatientDataSuccess) {
              // ✅ Initialize data only once
              _initializeFormData(state.meData);

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
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
              );
            }

            if (state is PatientAuthError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        "Failed to load profile",
                        style: AppTextStyles.semiBold16Black,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: "Retry",
                        onPressed: () {
                          context.read<PatientAuthCubit>().meData();
                        },
                        height: 48,
                        backgroundColor: AppColors.primary,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              );
            }

            // ✅ Show empty state if no data yet
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
