import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTextStyles {

  static  TextStyle headline1 = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.cardBackground,
  );
  static  TextStyle headline2 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.cardBackground,
  );
  static  TextStyle semiBold24dark = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.secondary,
  );
  static  TextStyle reg20black = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
  );
  static  TextStyle semiBold16Black = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
  );
}