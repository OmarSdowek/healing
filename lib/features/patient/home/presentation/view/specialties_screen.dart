import 'package:flutter/material.dart';
import '../../../../../core/helper/extentions/media_query.dart';
import '../../../../../core/widgets/custom_header.dart';
import '../widgets/speciality_item.dart';

class SpecialtiesScreen extends StatelessWidget {
  const SpecialtiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> specialities = [
      {"title": "Ophthalmology", "icon": "assets/images/14.png"},
      {"title": "Cardiology", "icon": "assets/images/7.png"},
      {"title": "Physical Therapy", "icon": "assets/images/12.png"},
      {"title": "Pulmonologist", "icon": "assets/images/10.png"},
      {"title": "Endocrinology", "icon": "assets/images/6.png"},
      {"title": "Pediatrics", "icon": "assets/images/5.png"},
      {"title": "Neurology", "icon": "assets/images/1.png"},
      {"title": "Phoniatrics", "icon": "assets/images/2.png"},
      {"title": "Gastroenterology", "icon": "assets/images/8.png"},
      {"title": "ENT", "icon": "assets/images/3.png"},
      {"title": "Psychiatry", "icon": "assets/images/9.png"},
      {"title": "Dentist", "icon": "assets/images/4.png"},
      {"title": "Radiology", "icon": "assets/images/11.png"},
      {"title": "Orthopedic", "icon": "assets/images/13.png"},
      {"title": "General Surgery", "icon": "assets/images/16.png"},
      {"title": "Dermatology", "icon": "assets/images/15.png"},
      {"title": "Obstetrics", "icon": "assets/images/17.png"},
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 Custom Header
              const CustomHeader(title: "Specialties"),

              context.verticalSpace(20),

              /// 🔹 Grid of Specialities
              Expanded(
                child: GridView.builder(
                  itemCount: specialities.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 3 عناصر في الصف
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (_, i) => SpecialityItem(
                    title: specialities[i]["title"]!,
                    iconPath: specialities[i]["icon"]!,
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
