import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/widgets/custom_text_feild.dart';
import '../../../home/presentation/widgets/specility_card.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> specialities = [
      {"title": "Neurology", "icon": "assets/images/1.png"},
      {"title": "Phoniatrics", "icon": "assets/images/2.png"},
      {"title": "ENT", "icon": "assets/images/3.png"},
      {"title": "Dentist", "icon": "assets/images/4.png"},
      {"title": "Pediatrics", "icon": "assets/images/5.png"},
      {"title": "Endocrinology", "icon": "assets/images/6.png"},
      {"title": "Cardiology", "icon": "assets/images/7.png"},
      {"title": "Gastroenterology", "icon": "assets/images/8.png"},
      {"title": "Psychiatry", "icon": "assets/images/9.png"},
      {"title": "Pulmonology", "icon": "assets/images/10.png"},
      {"title": "Radiology", "icon": "assets/images/11.png"},
      {"title": "Physical Therapy", "icon": "assets/images/12.png"},
      {"title": "Orthopedic", "icon": "assets/images/13.png"},
      {"title": "Ophthalmology", "icon": "assets/images/14.png"},
      {"title": "Dermatology", "icon": "assets/images/15.png"},
      {"title": "General Surgery", "icon": "assets/images/16.png"},
      {"title": "Obstetrics & Gynecology", "icon": "assets/images/17.png"},
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
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text("Search", style: AppTextStyles.reg20black),
                ],
              ),

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
                  style: AppTextStyles.reg20black.copyWith(
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

              context.verticalSpace(12),

            ],
          ),
        ),
      ),
    );
  }
}
