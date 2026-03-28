import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/helper/extentions/media_query.dart';

import 'core/route/app_routes.dart';
import 'core/route/routes.dart';

class Healing extends StatelessWidget {
  const Healing({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize:  Size(context.screenWidth, context.screenHeight), // 📱 Standard design
      minTextAdapt: true,
      splitScreenMode: true,

      builder: (context, child) {
        return MaterialApp(
          title: 'Healing',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.scaffoldBackgroundDark
          ),
          initialRoute: Routes.splash,
          onGenerateRoute: AppRouter.generateRoute,
        );
      },
    );
  }
}