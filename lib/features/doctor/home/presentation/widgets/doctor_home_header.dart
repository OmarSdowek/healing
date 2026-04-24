import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/route/routes.dart';

class DoctorHomeHeader extends StatelessWidget {
  final String name;
  final String imageAsset;

  const DoctorHomeHeader({
    super.key,
    required this.name,
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: context.r(24),
          backgroundImage: AssetImage(imageAsset),
        ),
        context.horizontalSpace(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Good Morning",
                style: AppTextStyles.semiBold16Black.copyWith(
                  color: AppColors.grey,
                  fontWeight: FontWeight.w400,
                  fontSize: context.sp(14),
                ),
              ),
              Text(
                name,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.semiBold16Black.copyWith(
                  color: AppColors.primaryText,
                  fontSize: context.sp(16),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () =>
              Navigator.pushNamed(context, Routes.doctorNotifications),
          icon: Icon(
            Icons.notifications_outlined,
            color: AppColors.primaryText,
            size: context.sp(26),
          ),
        ),
      ],
    );
  }
}
