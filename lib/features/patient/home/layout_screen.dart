import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/features/patient/home/presentation/manger/layout_cubit/layout_cubit.dart';
import 'package:healing/features/patient/home/presentation/view/home_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static const List<Widget> screens = [
    HomeScreen(),
    Scaffold(body: Center(child: Text("schedule"))),
    Scaffold(body: Center(child: Text("booking"))),
    Scaffold(body: Center(child: Text("profile"))),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LayoutCubit(),
      child: BlocBuilder<LayoutCubit, int>(
        builder: (context, currentIndex) {
          return Scaffold(
            body: screens[currentIndex],

            bottomNavigationBar: Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
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
                onTap: (index) {
                  context.read<LayoutCubit>().changeTab(index);
                },

                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                elevation: 0,

                selectedItemColor: AppColors.primary,
                unselectedItemColor: Colors.grey,

                selectedFontSize: 16,
                unselectedFontSize: 15,

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
                    label: "Schedule",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.book_outlined),
                    activeIcon: Icon(Icons.book),
                    label: "Booking",
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