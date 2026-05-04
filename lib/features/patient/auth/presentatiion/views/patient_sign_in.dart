import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/constant/assets_manger.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/utils/vaidation.dart';
import 'package:healing/core/widgets/custom_button.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../../../core/network/api_service.dart';
import '../../../../../core/route/routes.dart';
import '../../../../../core/widgets/custom_header.dart';
import '../../../../../core/widgets/custom_text_feild.dart';
import '../../data/model/login_request_model.dart';
import '../../data/repo/repo_impl.dart';
import '../../domin/use_case/email_verify.dart';
import '../../domin/use_case/login_use_case.dart';
import '../../domin/use_case/register_use_case.dart';
import '../manger/patient_auth_cubit.dart';

class PatientSignIn extends StatefulWidget {
  PatientSignIn({super.key});

  @override
  State<PatientSignIn> createState() => _PatientSignInState();
}

class _PatientSignInState extends State<PatientSignIn> {
  late TextEditingController nameController ;

  late TextEditingController passwordController ;


  @override
  void initState() {
    nameController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PatientAuthCubit>(),
      child: BlocListener<PatientAuthCubit, PatientAuthState>(
        listener: (context, state) {
          if (state is PatientLoginSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Login Successfully"),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pushReplacementNamed(context, Routes.patientHome);
          } else if (state is PatientAuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const CustomHeader(title: null),

              /// 🔹 Logo + Healing
              const SizedBox(height: 40),
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

              context.verticalSpace(20),

              /// 🔹 Title + Subtitle
              Text(
                "Login",
                style: AppTextStyles.semiBold24dark.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              context.verticalSpace(10),
              Text(
                "Enter your information to log in to your account",
                style: AppTextStyles.reg20black,
                textAlign: TextAlign.center,
              ),

              context.verticalSpace(20),

              /// 🔹 Input Fields
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🔹 Name Label
                    Text(
                      "Name",
                      style: AppTextStyles.semiBold16Black.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    context.verticalSpace(8),

                    CustomTextFormField(
                      hintText: "Enter your name",
                      controller: nameController,
                      validator: (name) => AppValidators.emailValidator(name),
                    ),

                    context.verticalSpace(20),

                    /// 🔹 Password Label
                    Text(
                      "Password",
                      style: AppTextStyles.semiBold16Black.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    context.verticalSpace(8),

                    CustomTextFormField(
                      hintText: "Enter your password",
                      controller: passwordController,
                      isPassword: true,
                      validator: (pass) => AppValidators.passwordValidator(pass),
                    ),
                  ],
                ),
              ),

              /// 🔹 Forget Password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.forgotPassword);
                    },
                    child: Text(
                      "Forget Password?",
                      style: AppTextStyles.semiBold16Black.copyWith(
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                ),
              ),

              /// 🔹 Login Button
              ///
              BlocBuilder<PatientAuthCubit, PatientAuthState>(
                builder: (context, state) {
                  if (state is PatientAuthLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomButton(
                      text: "Login",
                      backgroundColor: AppColors.primary,
                      onPressed: () {
                        context.read<PatientAuthCubit>().login(
                              request: LoginRequestModel(
                                email: nameController.text,
                                password: passwordController.text,
                              ),
                            );
                      },
                    ),
                  );
                },
              ),


              const SizedBox(height: 20),

              /// 🔹 Social Login Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    CustomButton(
                      text: "Log in with Google",
                      backgroundColor: Colors.white,
                      textColor: AppColors.primary,
                      outlined: false,
                      onPressed: () {
                      },
                      icon: Image.asset(AssetsManger.googleLogo),

                    ),
                    const SizedBox(height: 12),
                    CustomButton(
                      text: "Log in with Facebook",
                      backgroundColor: Colors.white,
                      textColor: AppColors.primary,
                      outlined: false,
                      onPressed: () {
                        // Facebook Login
                      },
                      icon: Image.asset(AssetsManger.facebookLogo),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              /// 🔹 Sign up link
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't have any account? ",
                      style: AppTextStyles.reg20black,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.patientRegister);
                      },
                      child: Text(
                        "Sign up",
                        style: AppTextStyles.semiBold16Black.copyWith(
                          color: AppColors.primary,
                          fontSize: context.sp(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}