import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_style.dart';
import '../../../../../core/constant/assets_manger.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../../../core/network/api_service.dart';
import '../../../../../core/route/routes.dart';
import '../../../../../core/widgets/alart_dailog.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_header.dart';
import '../../data/repo/repo_impl.dart';
import '../../domin/use_case/email_verify.dart';
import '../../domin/use_case/login_use_case.dart';
import '../../domin/use_case/register_use_case.dart';
import '../manger/patient_auth_cubit.dart';


class PatientOtpEmail extends StatelessWidget {
  final String token;
  final String email;

  const PatientOtpEmail({
    super.key,
    required this.token,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final tokenValue = token;
    final emailValue = email;

    return BlocProvider(
      create: (context) => sl<PatientAuthCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [

                /// 🔹 Header
                const CustomHeader(title: null),

                context.verticalSpace(30),

                /// 🔹 Logo
                Center(
                  child: Image.asset(
                    AssetsManger.authLogo,
                    height: 150,
                  ),
                ),

                context.verticalSpace(20),

                /// 🔹 Title
                Text(
                  "Verify Your Email",
                  style: AppTextStyles.semiBold24dark,
                ),

                context.verticalSpace(10),

                /// 🔹 Subtitle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "Enter the verification code we send to \nyour email $emailValue",
                    style: AppTextStyles.semiBold16Black,
                    textAlign: TextAlign.center,
                  ),
                ),

                context.verticalSpace(30),

                // /// 🔹 PIN CODE (UPDATED)
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                //   child: MaterialPinField(
                //     length: 6,
                //     onCompleted: (pin) => print('PIN: $pin'),
                //     onChanged: (value) => print('Changed: $value'),
                //     theme: MaterialPinTheme(
                //       shape: MaterialPinShape.outlined,
                //       cellSize: Size(56, 64),
                //       borderRadius: BorderRadius.circular(4),
                //       fillColor: AppColors.otp,
                //     ),
                //   ),
                // ),

                Text("Please Check Your Email",style: AppTextStyles.reg20black,),

                context.verticalSpace(30),

                /// 🔹 Confirm Button
                ///
                BlocConsumer<PatientAuthCubit, PatientAuthState>(
                  listener: (context, state) {
                    if (state is PatientAuthError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else if (state is PatientEmailVerifiedSuccess) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => SuccessDialog(
                          title: 'Success',
                          subtitle: 'Email verified successfully!',
                          onConfirm: () {
                            Navigator.pop(context);
                            Navigator.pushReplacementNamed(context, Routes.patientLogin);
                          },
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is PatientAuthLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomButton(
                        text: "Verify",
                        backgroundColor: AppColors.primary,
                        onPressed: () {
                          if (tokenValue.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("❌ Token is empty"),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          context.read<PatientAuthCubit>().verifyEmail(tokenValue);
                        },
                      ),
                    );
                  },
                ),


                context.verticalSpace(15),

                /// 🔹 Resend Code
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Send Again",
                    style: AppTextStyles.semiBold16Black.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),

                context.verticalSpace(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}