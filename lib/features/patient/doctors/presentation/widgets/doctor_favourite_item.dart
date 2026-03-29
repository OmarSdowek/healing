import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_style.dart';
import '../../../../../core/widgets/custom_button.dart';

class DoctorFavoriteItem extends StatelessWidget {
  final String name;
  final String speciality;
  final String price;
  final String image;
  final VoidCallback onDetails;
  final VoidCallback onBook;
  final VoidCallback onChat;

  const DoctorFavoriteItem({
    super.key,
    required this.name,
    required this.speciality,
    required this.price,
    required this.image,
    required this.onDetails,
    required this.onBook,
    required this.onChat,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🖼️ Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.asset(
                  image,
                  height: 110.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(height: 8.h),

              /// 👨‍⚕️ Name
              Text(
                name,
                style: AppTextStyles.semiBold16Black,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              /// تخصص
              Text(
                speciality,
                style: AppTextStyles.semiBold16Black.copyWith(
                  color: AppColors.primary,
                ),
              ),

              /// 💰 Price
              Text(
                price,
                style: AppTextStyles.semiBold16Black,
              ),

              SizedBox(height: 8.h),

              /// Buttons Row
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: "Details",
                      onPressed: onDetails,
                      outlined: true,
                      height: 30.h,
                      textColor: Colors.black,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: CustomButton(
                      text: "Book",
                      onPressed: onBook,
                      height: 30.h,
                      backgroundColor: AppColors.primary,
                      textColor: Colors.white,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 6.h),

              /// Chat Button
              CustomButton(
                text: "Chat",
                onPressed: onChat,
                height: 30.h,
                backgroundColor: Colors.grey.shade100,
                textColor: Colors.black,
              ),
            ],
          ),
        ),

        /// ❤️ Favorite Icon
        Positioned(
          top: 10,
          right: 10,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                ),
              ],
            ),
            child: const Icon(
              Icons.favorite,
              color: Colors.red,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }
}