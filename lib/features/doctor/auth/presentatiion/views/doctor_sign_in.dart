import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/constant/assets_manger.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/utils/vaidation.dart';
import 'package:healing/core/widgets/app_snack_bar.dart';
import 'package:healing/core/widgets/custom_button.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../../../core/route/routes.dart';
import '../../../../../core/widgets/custom_header.dart';
import '../../../../../core/widgets/custom_text_feild.dart';
import '../cubit/doctor_auth_cubit.dart';

class DoctorSignIn extends StatefulWidget {
  const DoctorSignIn({super.key});

  @override
  State<DoctorSignIn> createState() => _DoctorSignInState();
}

class _DoctorSignInState extends State<DoctorSignIn> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
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
      create: (_) => sl<DoctorAuthCubit>(),
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<DoctorAuthCubit, DoctorAuthState>(
            listener: (context, state) {
              if (state is DoctorLoginSuccess) {
                Navigator.pushReplacementNamed(context, Routes.doctorHome);
              } else if (state is DoctorAuthError) {
                AppSnackBar.showError(context, state.message);
              }
            },
            builder: (context, state) {
              final isLoading = state is DoctorAuthLoading;

              return Form(
                key: _formKey,
                child: SingleChildScrollView(
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
                            colorFilter: const ColorFilter.mode(
                              AppColors.primary,
                              BlendMode.srcIn,
                            ),
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

                      /// 🔹 Forget Password
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: isLoading
                                ? null
                                : () {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.doctorForgotPassword,
                                    );
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
                        child: isLoading
                            ? const CircularProgressIndicator()
                            : CustomButton(
                                text: "Login",
                                backgroundColor: AppColors.primary,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<DoctorAuthCubit>().login(
                                      email: emailController.text.trim(),
                                      password: passwordController.text,
                                    );
                                  }
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
                              onPressed: () {
                                // Google Login
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

                      const SizedBox(height: 20),

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
                              onTap: isLoading
                                  ? null
                                  : () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.doctorRegister,
                                      );
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
              );
            },
          ),
        ),
      ),
    );
  }
}
