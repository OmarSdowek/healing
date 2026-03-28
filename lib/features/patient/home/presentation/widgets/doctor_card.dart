import 'package:flutter/material.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_style.dart';
import '../../../../../core/widgets/custom_button.dart';

class DoctorCard extends StatelessWidget {
  final String name;
  final String speciality;
  final String price;
  final String image;
  const DoctorCard({
    super.key,
    required this.name,
    required this.speciality,
    required this.price,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              /// صورة الدكتور
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  image,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 16),

              /// بيانات الدكتور
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTextStyles.semiBold16Black),
                    const SizedBox(height: 4),
                    Text(
                      speciality,
                      style: AppTextStyles.semiBold16Black.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      price,
                      style: AppTextStyles.semiBold16Black.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// زرارين Details / Book Now
          Row(
            children: [
             Expanded(
               child: CustomButton(text: "Details", onPressed: () {

               },
                 backgroundColor: Colors.white,
                 textColor: AppColors.primary,
                 outlined: true,
               ),
             ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  text: "Book Now",
                  onPressed: () {},
                  backgroundColor: AppColors.primary,
                  textColor: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// زر Chat
          SizedBox(
            height: 41,
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: Icon(Icons.chat_bubble_outline,
                  color: AppColors.primary, size: 20),
              label: Text(
                "Chat",
                style: AppTextStyles.semiBold16Black.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
