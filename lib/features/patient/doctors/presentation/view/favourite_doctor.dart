import 'package:flutter/material.dart';
import '../../../../../core/widgets/custom_header.dart';
import '../widgets/doctor_favourite_item.dart';

class FavoritesDoctorsScreen extends StatelessWidget {
  const FavoritesDoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final doctors = [
      {
        "name": "Dr. Ahmed Sayed",
        "speciality": "Orthopedic",
        "price": "450 EGP/hour",
        "image": "assets/images/doctor1.png"
      },
      {
        "name": "Dr. Ahmed Sayed",
        "speciality": "Phoniatrics",
        "price": "200 EGP/hour",
        "image": "assets/images/doctor2.png"
      },
      {
        "name": "Dr. Manar Mostafa",
        "speciality": "Pediatrics",
        "price": "400 EGP/hour",
        "image": "assets/images/doctor3.png"
      },
      {
        "name": "Dr. Mohamed Kamel",
        "speciality": "Dermatology",
        "price": "250 EGP/hour",
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
              const CustomHeader(title: "Favorites Doctors"),
              const SizedBox(height: 20),

              Expanded(
                child: GridView.builder(
                  itemCount: doctors.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.65, // 🔥 أهم حاجة
                  ),
                  itemBuilder: (_, i) {
                    final d = doctors[i];
                    return DoctorFavoriteItem(
                      name: d["name"]!,
                      speciality: d["speciality"]!,
                      price: d["price"]!,
                      image: d["image"]!,
                      onDetails: () {},
                      onBook: () {},
                      onChat: () {},
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
