import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/constant/assets_manger.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/utils/vaidation.dart';
import 'package:healing/core/widgets/custom_button.dart';
import '../../../../../core/route/routes.dart';
import '../../../../../core/widgets/custom_header.dart';
import '../../../../../core/widgets/custom_text_feild.dart';
import '../cubit/patient_auth_cubit.dart';
import '../cubit/patient_auth_cubit_factory.dart';

class PatientSignIn extends StatefulWidget {
  PatientSignIn({super.key});

  @override
  State<PatientSignIn> createState() => _PatientSignInState();
}

class _PatientSignInState extends State<PatientSignIn> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PatientAuthCubitFactory.create(),
      child: BlocListener<PatientAuthCubit, PatientAuthState>(
        listener: (context, state) {
          if (state is PatientAuthSuccess) {
            Navigator.pushReplacementNamed(context, Routes.patientHome);
          } else if (state is PatientAuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 🔹 Email Label
                        Text(
                          "Email",
                          style: AppTextStyles.semiBold16Black.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                        context.verticalSpace(8),

                        CustomTextFormField(
                          hintText: "Enter your email",
                          controller: emailController,
                          validator: (email) =>
                              AppValidators.emailValidator(email),
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
                          validator: (pass) =>
                              AppValidators.passwordValidator(pass),
                        ),
                      ],
                    ),
                  ),
                ),

                /// 🔹 Forget Password
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: BlocBuilder<PatientAuthCubit, PatientAuthState>(
                    builder: (context, state) {
                      final isLoading = state is PatientAuthLoading;
                      return CustomButton(
                        text: isLoading ? "Logging in..." : "Login",
                        backgroundColor: AppColors.primary,
                        onPressed: () {
                          if (!isLoading && _formKey.currentState!.validate()) {
                            context.read<PatientAuthCubit>().login(
                              emailController.text,
                              passwordController.text,
                            );
                          }
                        },
                      );
                    },
                  ),
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
                        onPressed: () {},
                        icon: Image.asset(AssetsManger.googleLogo),
                      ),
                      const SizedBox(height: 12),
                      CustomButton(
                        text: "Log in with Facebook",
                        backgroundColor: Colors.white,
                        textColor: AppColors.primary,
                        outlined: false,
                        onPressed: () {},
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
      ),
    );
  }
}
