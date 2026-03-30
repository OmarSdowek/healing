import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_text_style.dart';

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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          /// 🔥 Image + Favorite
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.r),
                ),
                child: Image.asset(
                  image,
                  height: 120.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              Positioned(
                top: 8,
                right: 8,
                child: _favoriteIcon(),
              ),
            ],
          ),

          /// 🔥 Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Name
                  Text(
                    name,
                    style: AppTextStyles.semiBold16Black,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 4.h),

                  /// Speciality
                  Text(
                    speciality,
                    style: AppTextStyles.semiBold16Black.copyWith(
                      color: AppColors.primary,
                      fontSize: 13.sp,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  /// Price
                  Text(
                    price,
                    style: AppTextStyles.semiBold16Black.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const Spacer(),

                  /// Buttons
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 36.h,
                          child: OutlinedButton(
                            onPressed: onDetails,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: AppColors.primary),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                            ),
                            child: Text(
                              "Details",
                              style: TextStyle(color: AppColors.primary, fontSize: 10.sp),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 8.w),

                      Expanded(
                        child: SizedBox(
                          height: 36.h,
                          child: ElevatedButton(
                            onPressed: onBook,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                            ),
                            child: Text(
                            "Book Now",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp, // 🔥 كبرناه
                              fontWeight: FontWeight.w600,
                            ),
                              maxLines: 1,
                          ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  /// Chat Button
                  InkWell(
                    onTap: onChat,
                    borderRadius: BorderRadius.circular(20.r),
                    child: Container(
                      height: 40.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: const Center(
                        child: Icon(Icons.chat_bubble_outline),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _favoriteIcon() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.favorite,
        color: Colors.red,
        size: 18,
      ),
    );
  }
}