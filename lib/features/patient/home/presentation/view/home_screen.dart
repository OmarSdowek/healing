import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/route/routes.dart';
import 'package:healing/core/widgets/custom_text_feild.dart';
import 'package:healing/features/patient/auth/presentatiion/manger/patient_auth_cubit.dart';
import 'package:healing/features/patient/home/presentation/widgets/profile_header.dart';
import '../../../../../core/constant/assets_manger.dart';
import '../manger/home_cubit/home_cubit.dart';
import '../widgets/department_chip.dart';
import '../widgets/doctor_card.dart';
import '../widgets/up_coming_appointement_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header - User Profile
                BlocBuilder<PatientAuthCubit, PatientAuthState>(
                  builder: (context, state) {
                    if (state is PatientAuthLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (state is PatientDataSuccess) {
                      return ProfileHeader(
                        name: state.meData.fullName.split(" ").take(2).join(" "),
                        image: AssetsManger.person,
                      );
                    } else if (state is PatientAuthError) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Error loading profile",
                              style: TextStyle(
                                color: Colors.red.shade900,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              state.message,
                              style: TextStyle(color: Colors.red.shade700),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),

                context.verticalSpace(20),

                /// Search Bar
                CustomTextFormField(
                  hintText: "Search for specialty, doctor",
                  controller: TextEditingController(),
                  prefixIcon: Icon(Icons.search, color: AppColors.grey),
                  onTap: () {
                    Navigator.pushNamed(context, Routes.search);
                  },
                ),

                context.verticalSpace(20),

                /// Banner
                Image.asset(
                  AssetsManger.home,
                  height: context.h(200),
                  width: context.screenWidth,
                  fit: BoxFit.cover,
                ),

                context.verticalSpace(20),

                // ── AI Symptom Checker Banner ────────────────────────────
                GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, Routes.symptomChecker),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withOpacity(0.75),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.auto_awesome,
                            color: Colors.white, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '🩺 AI Symptom Checker',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Describe your symptoms and get a preliminary analysis',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.85),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios,
                            color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                ),

                context.verticalSpace(12),

                // ── Healing AI Assistant Banner ───────────────────────────
                GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, Routes.aiAssistant),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.chat_bubble_outline_rounded,
                            color: Colors.white, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '✨ Healing AI Assistant',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Chat with your personal AI health assistant',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.85),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios,
                            color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                ),

                context.verticalSpace(20),

                /// Departments/Specialities Chips
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    print("🔥 HomeScreen Departments BlocBuilder: state = $state");
                    
                    if (state is HomeLoading) {
                      return const SizedBox(); // Don't show loading for departments
                    }
                    
                    if (state is HomeDataLoaded && state.departments.isNotEmpty) {
                      print("✅ HomeScreen: Showing ${state.departments.length} departments");
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Specialities",
                                style: AppTextStyles.reg20black.copyWith(
                                  color: AppColors.black,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, Routes.specialties);
                                },
                                child: Text(
                                  "Show All",
                                  style: AppTextStyles.semiBold16Black
                                      .copyWith(color: AppColors.primary),
                                ),
                              ),
                            ],
                          ),
                          context.verticalSpace(12),
                          SizedBox(
                            height: 45,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.departments.length + 1,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return DepartmentChip(
                                    name: "All",
                                    isSelected: state.selectedDepartmentId == null,
                                    onTap: () {
                                      context.read<HomeCubit>().filterByDepartment(null);
                                    },
                                  );
                                }

                                final dept = state.departments[index - 1];
                                return DepartmentChip(
                                  name: dept.name,
                                  isSelected: state.selectedDepartmentId == dept.id,
                                  onTap: () {
                                    print("🔥 Department ${dept.name} tapped");
                                    context.read<HomeCubit>().filterByDepartment(dept.id);
                                  },
                                );
                              },
                            ),
                          ),
                          context.verticalSpace(20),
                        ],
                      );
                    }
                    
                    print("⚠️ HomeScreen: No departments to show");
                    return const SizedBox();
                  },
                ),

                /// Upcoming Appointment
                const UpcomingAppointmentSection(),

                context.verticalSpace(20),

                /// Available Doctors Title
                Text(
                  "Available Doctors",
                  style: AppTextStyles.reg20black.copyWith(
                    color: AppColors.black,
                  ),
                ),

                context.verticalSpace(20),

                /// Doctor Cards
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    print("🔥 HomeScreen Doctors BlocBuilder: state = ${state.runtimeType}");
                    
                    if (state is HomeLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    List<dynamic>? doctors;
                    
                    if (state is HomeDoctorsLoaded) {
                      doctors = state.doctors;
                      print("✅ HomeScreen: HomeDoctorsLoaded with ${doctors.length} doctors");
                    } else if (state is HomeDataLoaded) {
                      doctors = state.doctors;
                      print("✅ HomeScreen: HomeDataLoaded with ${doctors.length} doctors");
                    }

                    if (doctors != null && doctors.isNotEmpty) {
                      print("🎉 HomeScreen: Rendering ${doctors.length} doctor cards");
                      return ListView.builder(
                        itemCount: doctors.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          final doctor = doctors![index];
                          print("🔥 Doctor $index: ${doctor.fullName}");
                          return DoctorCard(doctor: doctor);
                        },
                      );
                    }

                    if (state is HomeError) {
                      print("❌ HomeScreen Doctors Error: ${state.message}");
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Icon(Icons.error_outline, size: 48, color: Colors.red),
                              const SizedBox(height: 12),
                              Text(
                                "Failed to load doctors",
                                style: TextStyle(
                                  color: Colors.red.shade900,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                state.message,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  context.read<HomeCubit>().loadHomeData();
                                },
                                child: const Text("Retry"),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    print("⚠️ HomeScreen: No doctors to show, state = ${state.runtimeType}");
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text("No doctors available"),
                      ),
                    );
                  },
                ),

                context.verticalSpace(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
