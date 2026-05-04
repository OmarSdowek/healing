import 'package:flutter/material.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_style.dart';
import '../../../../../core/route/routes.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/doctor_avatar.dart';
import '../../../home/domin/entity/doctor_entity.dart';

class DoctorCard extends StatelessWidget {
  final DoctorEntity doctor;

  const DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DoctorImage(
                  pictureUrl: doctor.pictureUrl, height: 90, width: 90),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(doctor.fullName,
                        style: AppTextStyles.semiBold16Black,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text(doctor.specialization,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.semiBold16Black
                            .copyWith(color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text(
                      "${doctor.consultationFee.toStringAsFixed(0)} EGP",
                      style: AppTextStyles.semiBold16Black
                          .copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          CustomButton(
            text: "Book Now",
            onPressed: () => Navigator.pushNamed(
                context, Routes.booking,
                arguments: doctor),
            backgroundColor: AppColors.primary,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
