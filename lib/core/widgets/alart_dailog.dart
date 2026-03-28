import 'package:flutter/material.dart';

class SuccessDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onConfirm; // proper callback type

  const SuccessDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        height: 250, // a bit taller to fit the button
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.green, width: 2),
              ),
              padding: const EdgeInsets.all(10),
              child: const Icon(
                Icons.check,
                color: Colors.green,
                size: 40,
              ),
            ),
            const SizedBox(height: 15),
            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            // Subtitle
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // OK Button
            ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("OK"),
            ),
          ],
        ),
      ),
    );
  }
}