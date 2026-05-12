import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import '../../../../core/constant/assets_manger.dart';
import '../../../../core/route/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, Routes.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accent,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AssetsManger.logo,
                      width: context.w(62),
                      height: context.h(51),
                    ),
                    context.horizontalSpace(8),
                    Text("Healing", style: AppTextStyles.headline1),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(bottom: context.h(20)),
              child: Text(
                "Healing – Care Without Boundaries",
                style: AppTextStyles.headline2,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
