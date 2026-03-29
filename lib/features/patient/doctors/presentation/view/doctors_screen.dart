import 'package:flutter/material.dart';
import '../../../../../core/widgets/custom_header.dart';
import '../../../../../core/widgets/custom_text_feild.dart';
import '../widgets/doctor_item.dart';
import '../../../../../core/constant/app_colors.dart';
import '../widgets/filter_chip_section.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  String selectedFilter = "All";

  @override
  Widget build(BuildContext context) {
    final doctors = [
      {
        "name": "Ziad Ahmed",
        "speciality": "Orthopedic",
        "hours": "8:00am - 2:00pm",
        "rating": 4.7,
        "image": "assets/images/doctor1.png"
      },
      {
        "name": "Mohamed Saeed",
        "speciality": "Physical Therapy",
        "hours": "8:00am - 2:00pm",
        "rating": 4.8,
        "image": "assets/images/doctor2.png"
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomHeader(title: "Doctors"),

              const SizedBox(height: 12),

              CustomTextFormField(
                hintText: "Search for specialty, doctor",
                controller: TextEditingController(),
                prefixIcon: const Icon(Icons.search, color: AppColors.grey),
              ),

              const SizedBox(height: 12),

              FilterChipSection(
                filters: const ["All", "Neurology", "Phoniatrics"],
                selected: selectedFilter,
                onSelected: (f) {
                  setState(() => selectedFilter = f);
                },
              ),

              const SizedBox(height: 12),

              Expanded(
                child: ListView.builder(
                  itemCount: doctors.length,
                  itemBuilder: (_, i) {
                    final d = doctors[i];
                    return DoctorItem(
                      name: d["name"] as String,
                      speciality: d["speciality"] as String,
                      hours: d["hours"] as String,
                      rating: d["rating"] as double,
                      image: d["image"] as String,
                      onTap: () {
                      },
                      onFavorite: () {
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
