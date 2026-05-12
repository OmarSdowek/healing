import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/constant/assets_manger.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/helper/extentions/context_extensions.dart';
import 'package:healing/core/widgets/custom_button.dart';
import 'package:healing/core/widgets/custom_header.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../../../core/network/api_service.dart';
import '../../../../../core/route/routes.dart';
import '../../../../../core/widgets/custom_text_feild.dart';
import '../../data/model/register_request_model.dart';
import '../../data/repo/repo_impl.dart';
import '../../domin/use_case/email_verify.dart';
import '../../domin/use_case/login_use_case.dart';
import '../../domin/use_case/register_use_case.dart';
import '../manger/patient_auth_cubit.dart';

class PatientSignUpScreen extends StatefulWidget {
  const PatientSignUpScreen({super.key});

  @override
  State<PatientSignUpScreen> createState() => _PatientSignUpScreenState();
}

class _PatientSignUpScreenState extends State<PatientSignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final idController = TextEditingController();
  final phoneController = TextEditingController();
  final bloodController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  DateTime? selectedBirthday;
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PatientAuthCubit>(),
      child: BlocListener<PatientAuthCubit, PatientAuthState>(
        listener: (context, state) {
          if (state is PatientRegisterSuccess) {
            context.showSuccess('Registration successful! Please verify your email.');
            Navigator.pushNamed(
              context,
              Routes.verifyEmail,
              arguments: {
                "token": state.emailVerificationToken,
                "email": state.email,
              },
            );
          } else if (state is PatientAuthError) {
            context.showError(state.message);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomHeader(title: null),
                  const SizedBox(height: 24),

                  /// LOGO
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AssetsManger.logo,
                        height: 50,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Healing",
                        style: AppTextStyles.headline1.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: Text(
                      "Sign up",
                      style: AppTextStyles.semiBold24dark.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// NAME
                  Text("Full Name", style: AppTextStyles.semiBold16Black),
                  CustomTextFormField(
                    hintText: "Enter your full name",
                    controller: nameController,
                  ),

                  const SizedBox(height: 20),

                  /// EMAIL
                  Text("Email", style: AppTextStyles.semiBold16Black),
                  CustomTextFormField(
                    hintText: "Enter your email",
                    controller: emailController,
                  ),

                  const SizedBox(height: 20),

                  /// BIRTHDAY
                  Text("Date of birth", style: AppTextStyles.semiBold16Black),
                  context.verticalSpace(10),
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
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    textColor: AppColors.primaryDark,
                  ),

                  const SizedBox(height: 20),

                  /// National ID
                  Text("National ID", style: AppTextStyles.semiBold16Black),
                  context.verticalSpace(10),
                  CustomTextFormField(
                    hintText: "Enter your ID",
                    controller: idController,
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 20),

                  /// Phone Number
                  Text("Phone Number", style: AppTextStyles.semiBold16Black),
                  context.verticalSpace(10),
                  CustomTextFormField(
                    hintText: "Enter your phone",
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 20),

                  /// Blood Type
                  Text("Blood Type", style: AppTextStyles.semiBold16Black),
                  context.verticalSpace(10),
                  CustomTextFormField(
                    hintText: "Enter your blood type",
                    controller: bloodController,
                  ),

                  const SizedBox(height: 20),

                  /// GENDER
                  Text("Gender", style: AppTextStyles.semiBold16Black),
                  context.verticalSpace(10),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: "Male",
                          onPressed: () =>
                              setState(() => selectedGender = "Male"),
                          backgroundColor: selectedGender == "Male"
                              ? AppColors.primary
                              : AppColors.cardBackground,
                          textColor: selectedGender == "Male"
                              ? Colors.white
                              : AppColors.primaryDark,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomButton(
                          text: "Female",
                          onPressed: () =>
                              setState(() => selectedGender = "Female"),
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
                  const SizedBox(height: 20),

                  /// PASSWORD
                  Text("Password", style: AppTextStyles.semiBold16Black),
                  CustomTextFormField(
                    hintText: "Enter password",
                    controller: passwordController,
                    isPassword: true,
                  ),

                  const SizedBox(height: 20),

                  /// CONFIRM PASSWORD
                  Text(
                    "Confirm Password",
                    style: AppTextStyles.semiBold16Black,
                  ),
                  CustomTextFormField(
                    hintText: "Confirm password",
                    controller: confirmPasswordController,
                    isPassword: true,
                  ),

                  const SizedBox(height: 30),

                  /// SIGN UP
                  BlocBuilder<PatientAuthCubit, PatientAuthState>(
                    builder: (context, state) {
                      if (state is PatientAuthLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return CustomButton(
                        text: "Sign up",
                        onPressed: () {
                          final request = RegisterRequestModel(
                            firstName: nameController.text,
                            lastName: nameController.text.lastIndexOf(" ") == -1
                                ? ""
                                : nameController.text.substring(
                                    nameController.text.lastIndexOf(" ") + 1,
                                  ),
                            email: emailController.text,
                            password: passwordController.text,
                            role: "Patient",
                            patientInfo: PatientInfoModel(
                              phone: phoneController.text,
                              dateOfBirth:
                                  selectedBirthday?.toIso8601String() ?? "",
                              gender: selectedGender ?? "",
                              nationalId: idController.text,
                              address: AddressModel(
                                street: "10 street",
                                city: "qaluib",
                                country: "Egypt",
                                postalCode: "11363",
                              ),
                            ),
                          );

                          context.read<PatientAuthCubit>().register(request);
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  /// Already have account? Login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: AppTextStyles.reg20black,
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, Routes.patientLogin),
                        child: Text(
                          "Login",
                          style: AppTextStyles.semiBold16Black.copyWith(
                            color: AppColors.primary,
                            fontSize: context.sp(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
