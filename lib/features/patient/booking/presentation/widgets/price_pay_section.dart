import 'package:flutter/material.dart';
import 'package:healing/core/helper/extentions/media_query.dart';

import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_style.dart';
import '../../../../../core/route/routes.dart';
import '../../../../../core/widgets/custom_button.dart';

class PriceAndPaySection extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  const PriceAndPaySection({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.r(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
