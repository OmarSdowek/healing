import 'package:flutter/material.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_style.dart';
import '../../../../../core/constant/assets_manger.dart';
import '../../../../../core/route/routes.dart';
import '../../../../../core/widgets/alart_dailog.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_header.dart';


class DoctorOtpEmail extends StatefulWidget {

  DoctorOtpEmail({super.key});

  @override
  State<DoctorOtpEmail> createState() => _DoctorOtpEmailState();
}

class _DoctorOtpEmailState extends State<DoctorOtpEmail> {
  late TextEditingController pinController ;


  @override
  void initState() {
    pinController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                padding: EdgeInsets.symmetric(horizontal: context.w(30)),
                child: Text(
                  "Enter the verification code we send to \nyour email Example@gmail.com",
                  style: AppTextStyles.semiBold16Black,
                  textAlign: TextAlign.center,
                ),
              ),

              context.verticalSpace(30),

              /// 🔹 PIN CODE (UPDATED)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.w(20)),
                child: MaterialPinField(
                  length: 6,
                  onCompleted: (pin) => print('PIN: $pin'),
                  onChanged: (value) => print('Changed: $value'),
                  theme: MaterialPinTheme(
                    shape: MaterialPinShape.outlined,
                    cellSize: Size(56, 64),
                    borderRadius: BorderRadius.circular(4),
                    fillColor: AppColors.otp,
                  ),
                ),
              ),

              context.verticalSpace(30),

              /// 🔹 Confirm Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.w(20)),
                child: CustomButton(
                  text: "Send",
                  backgroundColor: AppColors.primary,
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false, // prevent closing by tapping outside
                      builder: (context) => SuccessDialog(
                        title: 'Success',
                        subtitle: 'You have been Login Successfully',
                        onConfirm: () {
                          Navigator.pop(context); // close the dialog
                          Navigator.pushReplacementNamed(context, Routes.doctorLogin);
                        },
                      ),
                    );
                  },
                ),
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
    );
  }
}
