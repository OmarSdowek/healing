import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';

class DoctorProfileSection extends StatelessWidget {
  final String name;
  final String speciality;
  final String image;
  final bool isFavorite;
  final void Function()? onTap;

  const DoctorProfileSection({
    super.key,
    required this.name,
    required this.speciality,
    required this.image,
    this.isFavorite = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(context.r(18)),
        margin: EdgeInsets.symmetric(horizontal: context.w(10) , vertical: context.h(10)),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(context.r(12)),
        ),
        child: Row(
          children: [
            /// صورة الدكتور
            CircleAvatar(
              radius: context.r(30),
              backgroundImage: AssetImage(image),
            ),
            context.horizontalSpace(12),

            /// الاسم + التخصص
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.reg20black),
                Text(speciality, style: AppTextStyles.semiBold16Black.copyWith(color: Colors.grey.shade500)),
              ],
            ),

            const Spacer(),

            /// أيقونة Favorite
            Icon(
              Icons.favorite,
              color: isFavorite ? Colors.red : AppColors.secondaryText,
              size: context.r(28),
            ),
          ],
        ),
      ),
    );
  }
}
