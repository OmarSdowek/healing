import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/constant/assets_manger.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/widgets/custom_button.dart';
import 'package:healing/core/widgets/custom_header.dart';
import 'package:healing/core/widgets/custom_text_feild.dart';
import 'package:healing/features/doctor/auth/presentatiion/manger/doctor_auth_cubit.dart';
import 'package:healing/features/doctor/auth/presentatiion/manger/doctor_auth_cubit_factory.dart';
import '../../../../../core/route/routes.dart';

class DoctorForgotPassword extends StatefulWidget {
  const DoctorForgotPassword({super.key});

  @override
  State<DoctorForgotPassword> createState() => _DoctorForgotPasswordState();
}

class _DoctorForgotPasswordState extends State<DoctorForgotPassword> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DoctorAuthCubitFactory.create(),
      child: BlocListener<DoctorAuthCubit, DoctorAuthState>(
        listener: (context, state) {
          if (state is DoctorForgotPasswordSent) {
            Navigator.pushNamed(context, Routes.doctorResetPassword);
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
          backgroundColor: AppColors.scaffoldBackground,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomHeader(title: "Forgot your Password"),
                  context.verticalSpace(30),
                  Center(
                    child: Image.asset(
                      AssetsManger.authLogo,
                      height: context.h(150),
                    ),
                  ),
                  context.verticalSpace(20),
                  Center(
                    child: Text(
                      "Forgot Password",
                      style: AppTextStyles.semiBold24dark,
                    ),
                  ),
                  context.verticalSpace(10),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: context.w(30)),
                      child: Text(
                        "A Code will be sent to your email to help reset password",
                        style: AppTextStyles.semiBold16Black,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  context.verticalSpace(30),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.w(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Email", style: AppTextStyles.semiBold16Black),
                        context.verticalSpace(8),
                        CustomTextFormField(
                          hintText: "Enter your email",
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ],
                    ),
                  ),
                  context.verticalSpace(30),
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
                          text: "Next",
                          backgroundColor: AppColors.primary,
                          onPressed: () {
                            if (_emailController.text.trim().isNotEmpty) {
                              context.read<DoctorAuthCubit>().forgotPassword(
                                _emailController.text.trim(),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                  context.verticalSpace(20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
