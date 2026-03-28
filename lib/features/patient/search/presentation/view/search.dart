import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/constant/assets_manger.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/widgets/custom_header.dart';
import 'package:healing/core/widgets/custom_text_feild.dart';
import '../../../home/presentation/widgets/specility_card.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> specialities = [
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
    final List<String> history = [
      "Neurology",
      "Ophthalmology",
      "Obstetrics & Gynecology",
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 Custom Header
             CustomHeader(title: "Search",),

              context.verticalSpace(12),

              /// 🔹 Custom TextField
              CustomTextFormField(
                hintText: "Search for specialty, doctor",
                controller: TextEditingController(),
                prefixIcon: Icon(Icons.search, color: AppColors.grey),
              ),

              context.verticalSpace(20),

              /// 🔹 All Specialties Title
              Text("All Specialties",
                  style: AppTextStyles.semiBold24dark.copyWith(
                    color: AppColors.black,
                  )),

              context.verticalSpace(12),

              /// 🔹 Specialities Grid
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: specialities
                        .map((s) => SpecialityCard(
                      title: s["title"]!,
                      iconPath: s["icon"]!,
                    ))
                        .toList(),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
