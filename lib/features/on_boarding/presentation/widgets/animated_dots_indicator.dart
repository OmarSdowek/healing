import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/helper/extentions/media_query.dart';

class DotsIndicator extends StatelessWidget {
  final int currentIndex;
  final int count;

  const DotsIndicator({
    super.key,
    required this.currentIndex,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
            (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),

          height: context.h(8),
          width: currentIndex == index ? context.w(20) : context.w(8),

          decoration: BoxDecoration(
            color: currentIndex == index
                ? AppColors.primaryDark
                : AppColors.darkGrey,
            borderRadius: BorderRadius.circular(context.r(999)),
          ),
        ),
      ),
    );
  }
}