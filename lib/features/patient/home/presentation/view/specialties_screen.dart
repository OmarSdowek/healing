import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../../../core/helper/extentions/media_query.dart';
import '../../../../../core/route/routes.dart';
import '../../../../../core/widgets/custom_header.dart';
import '../manger/home_cubit/home_cubit.dart';
import '../widgets/speciality_item.dart';

class SpecialtiesScreen extends StatelessWidget {
  const SpecialtiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeCubit>()..loadHomeData(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomHeader(title: "Specialties"),
                context.verticalSpace(20),
                Expanded(
                  child: BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      if (state is HomeLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (state is HomeError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline,
                                  size: 64, color: Colors.red),
                              const SizedBox(height: 16),
                              Text(
                                "Failed to load specialties",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red.shade900,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                state.message,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.red.shade700),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () =>
                                    context.read<HomeCubit>().loadHomeData(),
                                child: const Text("Retry"),
                              ),
                            ],
                          ),
                        );
                      }

                      if (state is HomeDataLoaded) {
                        if (state.departments.isEmpty) {
                          return const Center(
                            child: Text("No specialties available"),
                          );
                        }

                        return GridView.builder(
                          itemCount: state.departments.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (_, i) {
                            final dept = state.departments[i];
                            return SpecialityItem(
                              title: dept.name,
                              iconPath: _getIconForDepartment(dept.name),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.doctorsByDepartment,
                                  arguments: {
                                    'departmentId': dept.id,
                                    'departmentName': dept.name,
                                  },
                                );
                              },
                            );
                          },
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getIconForDepartment(String name) {
    final Map<String, String> iconMap = {
      "Cardiology": "assets/images/7.png",
      "Neurology": "assets/images/1.png",
      "Orthopedics": "assets/images/13.png",
      "Pediatrics": "assets/images/5.png",
      "Dermatology": "assets/images/15.png",
      "Ophthalmology": "assets/images/14.png",
      "ENT": "assets/images/3.png",
      "Psychiatry": "assets/images/9.png",
      "Radiology": "assets/images/11.png",
      "General Surgery": "assets/images/16.png",
    };
    return iconMap[name] ?? "assets/images/1.png";
  }
}
