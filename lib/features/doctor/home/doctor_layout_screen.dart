import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/features/doctor/home/presentation/manger/layout_cubit/doctor_layout_cubit.dart';
import 'package:healing/features/doctor/home/presentation/view/doctor_home_screen.dart';
import 'package:healing/features/doctor/profile/presentation/view/doctor_profile_screen.dart';
import 'package:healing/features/doctor/schedule/presentation/view/doctor_schedule_screen.dart';

class DoctorMainScreen extends StatelessWidget {
  const DoctorMainScreen({super.key});

  static const List<Widget> _screens = [
    DoctorHomeScreen(),
    DoctorScheduleScreen(),
    DoctorProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DoctorLayoutCubit(),
      child: BlocBuilder<DoctorLayoutCubit, int>(
        builder: (context, currentIndex) {
          return Scaffold(
            body: _screens[currentIndex],
            bottomNavigationBar: Container(
              padding: EdgeInsets.symmetric(vertical: context.h(6)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(context.r(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: BottomNavigationBar(
                currentIndex: currentIndex,
                onTap: (index) =>
                    context.read<DoctorLayoutCubit>().changeTab(index),
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedItemColor: AppColors.primary,
                unselectedItemColor: Colors.grey,
                selectedFontSize: context.sp(14),
                unselectedFontSize: context.sp(13),
                showUnselectedLabels: true,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_today_outlined),
                    activeIcon: Icon(Icons.calendar_today),
                    label: "Scheduel",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline),
                    activeIcon: Icon(Icons.person),
                    label: "Profile",
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
