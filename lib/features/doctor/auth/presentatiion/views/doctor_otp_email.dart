import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/constant/assets_manger.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/widgets/alart_dailog.dart';
import 'package:healing/core/widgets/app_snack_bar.dart';
import 'package:healing/core/widgets/custom_button.dart';
import 'package:healing/core/widgets/custom_header.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../../../core/route/routes.dart';
import '../cubit/doctor_auth_cubit.dart';

class DoctorOtpEmail extends StatelessWidget {
  final String token;
  final String email;

  const DoctorOtpEmail({
    super.key,
    required this.token,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DoctorAuthCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: SafeArea(
          child: BlocConsumer<DoctorAuthCubit, DoctorAuthState>(
            listener: (context, state) {
              if (state is DoctorAuthError) {
                AppSnackBar.showError(context, state.message);
              } else if (state is DoctorEmailVerifiedSuccess) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => SuccessDialog(
                    title: 'Email Verified',
                    subtitle: 'Your account is now active. Please log in.',
                    onConfirm: () {
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(
                          context, Routes.doctorLogin);
                    },
                  ),
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is DoctorAuthLoading;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const CustomHeader(title: null),
                    context.verticalSpace(30),

                    Center(
                      child: Image.asset(AssetsManger.authLogo, height: 150),
                    ),
                    context.verticalSpace(20),

                    Text('Verify Your Email',
                        style: AppTextStyles.semiBold24dark),
                    context.verticalSpace(10),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        'A verification email has been sent to\n$email\n\nClick the link in the email or press Verify below.',
                        style: AppTextStyles.semiBold16Black,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    context.verticalSpace(40),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : CustomButton(
                              text: 'Verify Email',
                              backgroundColor: AppColors.primary,
                              onPressed: () {
                                if (token.isEmpty) {
                                  AppSnackBar.showWarning(context,
                                      'Verification token not found.');
                                  return;
                                }
                                context
                                    .read<DoctorAuthCubit>()
                                    .verifyEmail(token);
                              },
                            ),
                    ),
                    context.verticalSpace(15),

                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Resend Email',
                        style: AppTextStyles.semiBold16Black
                            .copyWith(color: AppColors.primary),
                      ),
                    ),
                    context.verticalSpace(20),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
