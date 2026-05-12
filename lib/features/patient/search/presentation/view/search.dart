import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/constant/assets_manger.dart';
import 'package:healing/core/di/injection_container.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/route/routes.dart';
import 'package:healing/core/widgets/custom_header.dart';
import 'package:healing/core/widgets/custom_text_feild.dart';
import 'package:healing/core/widgets/doctor_avatar.dart';
import '../../../home/domin/entity/doctor_entity.dart';
import '../../../home/presentation/manger/home_cubit/home_cubit.dart';
import '../../../home/presentation/widgets/specility_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  bool _isSearching = false;

  final List<Map<String, String>> _specialities = [
    {"title": "Neurology", "icon": AssetsManger.specialities1},
    {"title": "Phoniatrics", "icon": AssetsManger.specialities2},
    {"title": "ENT", "icon": AssetsManger.specialities3},
    {"title": "Dentist", "icon": AssetsManger.specialities4},
    {"title": "Pediatrics", "icon": AssetsManger.specialities5},
    {"title": "Endocrinology", "icon": AssetsManger.specialities6},
    {"title": "Cardiology", "icon": AssetsManger.specialities7},
    {"title": "Gastroenterology", "icon": AssetsManger.specialities8},
    {"title": "Psychiatry", "icon": AssetsManger.specialities9},
    {"title": "Pulmonology", "icon": AssetsManger.specialities10},
    {"title": "Radiology", "icon": AssetsManger.specialities11},
    {"title": "Physical Therapy", "icon": AssetsManger.specialities12},
    {"title": "Orthopedic", "icon": AssetsManger.specialities13},
    {"title": "Ophthalmology", "icon": AssetsManger.specialities14},
    {"title": "Dermatology", "icon": AssetsManger.specialities15},
    {"title": "General Surgery", "icon": AssetsManger.specialities16},
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeCubit>()..loadHomeData(),
      child: Builder(builder: (ctx) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomHeader(title: "Search"),
                  context.verticalSpace(12),

                  /// Search Field
                  CustomTextFormField(
                    hintText: "Search for specialty, doctor",
                    controller: _controller,
                    prefixIcon:
                        const Icon(Icons.search, color: AppColors.grey),
                    onChanged: (value) {
                      setState(() => _isSearching = value.trim().isNotEmpty);
                      ctx.read<HomeCubit>().searchDoctors(value);
                    },
                  ),

                  context.verticalSpace(20),

                  /// Content
                  Expanded(
                    child: BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        // Show search results when searching
                        if (_isSearching) {
                          if (state is HomeLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          List<DoctorEntity> doctors = [];
                          if (state is HomeDataLoaded) {
                            doctors = state.doctors;
                          }

                          if (doctors.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search_off,
                                      size: 64,
                                      color: Colors.grey.shade400),
                                  const SizedBox(height: 16),
                                  Text(
                                    "No results for \"${_controller.text}\"",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: doctors.length,
                            itemBuilder: (_, i) {
                              final d = doctors[i];
                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                leading: DoctorAvatar(
                                  pictureUrl: d.pictureUrl,
                                  radius: 26,
                                ),
                                title: Text(d.fullName,
                                    style: AppTextStyles.semiBold16Black),
                                subtitle: Text(
                                  d.specialization,
                                  style: AppTextStyles.semiBold16Black
                                      .copyWith(
                                          color: Colors.grey, fontSize: 13),
                                ),
                                trailing: Text(
                                  "${d.consultationFee.toStringAsFixed(0)} EGP",
                                  style: AppTextStyles.semiBold16Black
                                      .copyWith(
                                          color: AppColors.primary,
                                          fontSize: 13),
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    Routes.booking,
                                    arguments: d,
                                  );
                                },
                              );
                            },
                          );
                        }

                        // Default: show all specialties
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "All Specialties",
                                style: AppTextStyles.semiBold24dark
                                    .copyWith(color: AppColors.black),
                              ),
                              context.verticalSpace(12),
                              Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children: _specialities
                                    .map((s) => GestureDetector(
                                          onTap: () {
                                            _controller.text = s["title"]!;
                                            setState(() =>
                                                _isSearching = true);
                                            ctx
                                                .read<HomeCubit>()
                                                .searchDoctors(s["title"]!);
                                          },
                                          child: SpecialityCard(
                                            title: s["title"]!,
                                            iconPath: s["icon"]!,
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
