import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/constant/assets_manger.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/utils/vaidation.dart';
import 'package:healing/core/widgets/custom_button.dart';
import 'package:healing/features/doctor/auth/presentatiion/manger/doctor_auth_cubit.dart';
import 'package:healing/features/doctor/auth/presentatiion/manger/doctor_auth_cubit_factory.dart';
import '../../../../../core/route/routes.dart';
import '../../../../../core/widgets/custom_header.dart';
import '../../../../../core/widgets/custom_text_feild.dart';

class DoctorSignIn extends StatefulWidget {
  const DoctorSignIn({super.key});

  @override
  State<DoctorSignIn> createState() => _DoctorSignInState();
}

class _DoctorSignInState extends State<DoctorSignIn> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DoctorAuthCubitFactory.create(),
      child: BlocListener<DoctorAuthCubit, DoctorAuthState>(
        listener: (context, state) {
          if (state is DoctorAuthSuccess) {
            Navigator.pushReplacementNamed(context, Routes.doctorHome);
          }
          if (state is DoctorAuthError) {
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
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: context.h(20)),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const CustomHeader(title: null),
                    SizedBox(height: context.h(40)),

                    // Logo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          AssetsManger.logo,
                          height: context.h(50),
                          colorFilter: ColorFilter.mode(
                            AppColors.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: context.w(8)),
                        Text(
                          "Healing",
                          style: AppTextStyles.headline1.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),

                    context.verticalSpace(20),

                    Text(
                      "Login",
                      style: AppTextStyles.semiBold24dark.copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    context.verticalSpace(10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: context.w(20)),
                      child: Text(
                        "Enter your information to log in to your account",
                        style: AppTextStyles.reg20black,
                        textAlign: TextAlign.center,
                      ),
                    ),

                    context.verticalSpace(20),

                    // Fields
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: context.w(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Email",
                            style: AppTextStyles.semiBold16Black.copyWith(
                              color: AppColors.black,
                            ),
                          ),
                          context.verticalSpace(8),
                          CustomTextFormField(
                            hintText: "Enter your email",
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: AppValidators.emailValidator,
                          ),
                          context.verticalSpace(20),
                          Text(
                            "Password",
                            style: AppTextStyles.semiBold16Black.copyWith(
                              color: AppColors.black,
                            ),
                          ),
                          context.verticalSpace(8),
                          CustomTextFormField(
                            hintText: "Enter your password",
                            controller: _passwordController,
                            isPassword: true,
                            validator: AppValidators.passwordValidator,
                          ),
                        ],
                      ),
                    ),

                    // Forgot password
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.w(20),
                        vertical: context.h(10),
                      ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            Routes.doctorForgotPassword,
                          ),
                          child: Text(
                            "Forget Password?",
                            style: AppTextStyles.semiBold16Black.copyWith(
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Login button
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: context.w(20)),
                      child: BlocBuilder<DoctorAuthCubit, DoctorAuthState>(
                        builder: (context, state) {
                          if (state is DoctorAuthLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return CustomButton(
                            text: "Login",
                            backgroundColor: AppColors.primary,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<DoctorAuthCubit>().login(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text,
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),

                    context.verticalSpace(24),

                    // Sign up link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't have any account? ",
                          style: AppTextStyles.reg20black,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            Routes.doctorRegister,
                          ),
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
