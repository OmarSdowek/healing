import 'package:flutter/material.dart';

import '../../../../../core/constant/app_text_style.dart';
import '../../../../../core/route/routes.dart';



class ProfileHeader extends StatelessWidget {
  final String name;
  final String image;
  const ProfileHeader({super.key, required this.name, required this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(image),
            radius: 25,
          ),
          const SizedBox(width: 12),
          Text("👋 Hi $name", style: AppTextStyles.reg20black),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              Navigator.pushNamed(context, Routes.favorites);
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

