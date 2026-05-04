import 'package:flutter/material.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_style.dart';
import '../../../../../core/widgets/doctor_avatar.dart';

class DoctorItem extends StatelessWidget {
  final String name;
  final String speciality;
  final String hours;
  final double rating;
  final String? pictureUrl; // network URL from API
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const DoctorItem({
    super.key,
    required this.name,
    required this.speciality,
    required this.hours,
    required this.rating,
    this.pictureUrl,
    required this.onTap,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            /// Doctor avatar — resolves URL, falls back to default
            DoctorAvatar(pictureUrl: pictureUrl, radius: 30),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTextStyles.reg20black),
                  Text(speciality,
                      style: AppTextStyles.semiBold16Black
                          .copyWith(color: Colors.grey)),
                  Row(
                    children: [
                      Icon(Icons.access_time,
                          color: Colors.grey.shade400, size: 18),
                      context.horizontalSpace(4),
                      Expanded(
                        child: Text(hours,
                            style: AppTextStyles.semiBold16Black
                                .copyWith(color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      context.horizontalSpace(4),
                      Text(rating.toStringAsFixed(1),
                          style: AppTextStyles.semiBold16Black),
                    ],
                  ),
                ],
              ),
            ),

            IconButton(
              icon: const Icon(Icons.favorite_border,
                  color: AppColors.primary),
              onPressed: onFavorite,
            ),
          ],
        ),
      ),
    );
  }
}
