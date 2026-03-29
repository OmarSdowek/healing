import 'package:flutter/material.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_style.dart';
import '../../../../../core/widgets/custom_button.dart';

class AppointmentCard extends StatelessWidget {
  final String date;
  final String doctorName;
  final String speciality;
  final String image;
  final VoidCallback onCancel;
  final VoidCallback onReschedule;

  const AppointmentCard({
    super.key,
    required this.date,
    required this.doctorName,
    required this.speciality,
    required this.image,
    required this.onCancel,
    required this.onReschedule,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// التاريخ + Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: AppTextStyles.semiBold16Black.copyWith(
                  color: Colors.grey.shade700,
                ),
              ),
               Text(
                "Upcoming",
                style: AppTextStyles.semiBold16Black.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          const Divider(thickness: 1),
          const SizedBox(height: 8),

          /// اسم الدكتور + التخصص
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: _getImageProvider(),
              ),
              const SizedBox(width: 12),
              Column(
                children: [
                  Text(
                    doctorName,
                    style: AppTextStyles.semiBold16Black,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    speciality,
                    style: AppTextStyles.semiBold16Black.copyWith(color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),



          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: "Cancel",
                        textColor: AppColors.primary,
                        onPressed: onCancel,
                        outlined: true,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomButton(
                        text: "Reschedule",
                        onPressed: onReschedule,
                        outlined: false,
                        backgroundColor: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Handle asset / network image
  ImageProvider _getImageProvider() {
    if (image.startsWith('http')) {
      return NetworkImage(image);
    } else {
      return AssetImage(image);
    }
  }
}
