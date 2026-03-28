import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healing/core/constant/app_text_style.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/assets_manger.dart';
import '../../../../core/route/routes.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../data/data/onboarding_data.dart';
import '../widgets/animated_dots_indicator.dart';
import '../widgets/on_boarding_item.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final PageController controller = PageController();
  int currentIndex = 0;

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AssetsManger.logo,
                    height: 30,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Healing",
                    style: AppTextStyles.headline1.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),

                  if (currentIndex != onBoardingList.length - 1)
                    TextButton(
                      onPressed: () {
                        controller.jumpToPage(onBoardingList.length - 1);
                      },
                      child: Text(
                        "Skip",
                        style: AppTextStyles.semiBold16Black,
                      ),
                    ),
                ],
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: controller,
                itemCount: onBoardingList.length,
                onPageChanged: onPageChanged,
                itemBuilder: (context, index) {
                  return OnBoardingItem(
                    model: onBoardingList[index],
                  );
                },
              ),
            ),

            DotsIndicator(
              currentIndex: currentIndex,
              count: onBoardingList.length,
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButton(
                backgroundColor: AppColors.primary,
                textColor: AppColors.white,
                text: currentIndex == onBoardingList.length - 1
                    ? "Get Started"
                    : "Next",
                onPressed: () {
                  if (currentIndex == onBoardingList.length - 1) {
                    Navigator.pushNamed(context, Routes.signUpAs);
                  } else {
                    controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}