import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/widgets/doctor_avatar.dart';

class DoctorProfileSection extends StatelessWidget {
  final String name;
  final String speciality;
  final String? image; // URL or asset path
  final bool isFavorite;
  final void Function()? onTap;

  const DoctorProfileSection({
    super.key,
    required this.name,
    required this.speciality,
    this.image,
    this.isFavorite = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(context.r(18)),
        margin: EdgeInsets.symmetric(
            horizontal: context.w(10), vertical: context.h(10)),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(context.r(12)),
        ),
        child: Row(
          children: [
            /// Uses DoctorAvatar — resolves URL, falls back to default
            DoctorAvatar(pictureUrl: image, radius: context.r(30)),

            context.horizontalSpace(12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: AppTextStyles.reg20black,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  Text(speciality,
                      style: AppTextStyles.semiBold16Black
                          .copyWith(color: Colors.grey.shade500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),

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
