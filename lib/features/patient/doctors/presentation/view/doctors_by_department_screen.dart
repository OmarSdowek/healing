import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../../../core/route/routes.dart';
import '../../../../../core/widgets/custom_header.dart';
import '../../../../../core/widgets/custom_text_feild.dart';
import '../../../../patient/home/presentation/manger/home_cubit/home_cubit.dart';
import '../widgets/doctor_item.dart';

class DoctorsByDepartmentScreen extends StatefulWidget {
  final int departmentId;
  final String departmentName;

  const DoctorsByDepartmentScreen({
    super.key,
    required this.departmentId,
    required this.departmentName,
  });

  @override
  State<DoctorsByDepartmentScreen> createState() =>
      _DoctorsByDepartmentScreenState();
}

class _DoctorsByDepartmentScreenState
    extends State<DoctorsByDepartmentScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<HomeCubit>()..filterByDepartmentDirect(widget.departmentId),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomHeader(title: widget.departmentName),
                const SizedBox(height: 12),

                CustomTextFormField(
                  hintText: "Search for doctor",
                  controller: _searchController,
                  prefixIcon: const Icon(Icons.search, color: AppColors.grey),
                  onChanged: (val) =>
                      setState(() => _searchQuery = val.toLowerCase()),
                ),
                const SizedBox(height: 12),

                Expanded(
                  child: BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      if (state is HomeLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is HomeError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline,
                                  size: 64, color: Colors.red),
                              const SizedBox(height: 16),
                              Text(state.message,
                                  textAlign: TextAlign.center,
                                  style:
                                      TextStyle(color: Colors.red.shade700)),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => context
                                    .read<HomeCubit>()
                                    .filterByDepartmentDirect(
                                        widget.departmentId),
                                child: const Text("Retry"),
                              ),
                            ],
                          ),
                        );
                      }

                      List<dynamic> doctors = [];
                      if (state is HomeDataLoaded) {
                        doctors = state.doctors;
                      } else if (state is HomeDoctorsLoaded) {
                        doctors = state.doctors;
                      }

                      if (_searchQuery.isNotEmpty) {
                        doctors = doctors
                            .where((d) =>
                                d.fullName
                                    .toLowerCase()
                                    .contains(_searchQuery) ||
                                d.specialization
                                    .toLowerCase()
                                    .contains(_searchQuery))
                            .toList();
                      }

                      if (doctors.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person_search,
                                  size: 64, color: Colors.grey.shade400),
                              const SizedBox(height: 16),
                              Text("No doctors found",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey.shade600)),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: doctors.length,
                        itemBuilder: (_, i) {
                          final doctor = doctors[i];
                          return DoctorItem(
                            name: doctor.fullName,
                            speciality: doctor.specialization,
                            hours:
                                "${doctor.yearsOfExperience} yrs experience",
                            rating: 4.5,
                            pictureUrl: doctor.pictureUrl,
                            onTap: () => Navigator.pushNamed(
                              context,
                              Routes.booking,
                              arguments: doctor,
                            ),
                            onFavorite: () {},
                          );
                        },
                      );
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
}
