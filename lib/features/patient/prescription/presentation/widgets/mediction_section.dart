import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';

import 'mediction_item.dart';

class MedicationsSection extends StatelessWidget {
  final List<MedicationItem> medications;

  const MedicationsSection({super.key, required this.medications});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Medications (Active)", style: AppTextStyles.reg20black),
        context.verticalSpace(10),
        ...medications,
      ],
    );
  }
}
