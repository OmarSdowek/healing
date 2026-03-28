import 'package:flutter/material.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import '../../../../core/constant/app_text_style.dart';

class OnBoardingItem extends StatelessWidget {
  final dynamic model;

  const OnBoardingItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),

        /// 🔹 Image
        Image.asset(
          model.image.toString(),
          height: context.h(380),
          width: context.w(343),
        ),

        const SizedBox(height: 20),

        /// 🔹 Title
        Text(
          model.title,
          style: AppTextStyles.semiBold24dark,
        ),

        const SizedBox(height: 10),

        /// 🔹 Subtitle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            model.subTitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.reg20black,
          ),
        ),
      ],
    );
  }
}