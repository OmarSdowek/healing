import 'package:flutter/material.dart';
import 'package:healing/core/helper/extentions/media_query.dart';

import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_style.dart';
import '../../../../../core/route/routes.dart';
import '../../../../../core/widgets/custom_button.dart';

class PriceAndPaySection extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  final num price;
  const PriceAndPaySection({
    super.key,
    required this.text,
    required this.price,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.r(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: "Price ", style: AppTextStyles.reg20black),
                    TextSpan(
                      text: " / hour",
                      style: AppTextStyles.semiBold16Black.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "$price\$",
                style: AppTextStyles.reg20black.copyWith(color: Colors.red),
              ),
            ],
          ),
          context.verticalSpace(10),
          CustomButton(
            text: text,
            onPressed: onPressed,
            backgroundColor: AppColors.primary,
            textColor: AppColors.white,
            height: context.h(50),
          ),
        ],
      ),
    );
  }
}
