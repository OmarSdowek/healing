import 'package:flutter/material.dart';
import 'package:healing/core/widgets/custom_header.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import '../widgets/doctor_notes_section.dart';
import '../widgets/mediction_item.dart';
import '../widgets/prescription_header.dart';


class PrescriptionScreen extends StatelessWidget {
  const PrescriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomHeader(title: "Prescription Details"),
              context.verticalSpace(20),

              /// Header
              const PrescriptionHeader(
                doctorName: "Reham Saeed",
                speciality: "Cardiologist",
                date: "Oct 24, 2023",
                prescriptionId: "#RX-8B210452",
              ),
              context.verticalSpace(20),

              /// Medications
              Text("Medications (Active)", style: AppTextStyles.reg20black),
              context.verticalSpace(10),
              const MedicationItem(
                name: "Amoxicillin",
                dosage: "500mg Tablet",
                duration: "7 Days",
                instructions: "Twice daily, after meals",
              ),
              const MedicationItem(
                name: "Lisinopril",
                dosage: "10mg Tablet",
                duration: "30 Days",
                instructions: "Once daily, morning",
              ),
              const MedicationItem(
                name: "Parastomal",
                dosage: "50mg Tablet",
                duration: "7 Days",
                instructions: "Twice daily, after meals",
              ),
              context.verticalSpace(20),

              /// Notes
              const DoctorNotesSection(
                notes:
                "Please ensure complete rest for the first 3 days.\nIncrease fluid intake.\nIf fever persists above 101°F for more than 48 hours, please contact the clinic immediately.",
                doctorName: "Reham Saeed",
              ),
              context.verticalSpace(30),

              /// Download Button with Icon
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Logic for download
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.download, color: Colors.white),
                  label: Text(
                    "Download PDF",
                    style: AppTextStyles.semiBold16Black.copyWith(color: Colors.white),
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
