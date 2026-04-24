import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/helper/extentions/media_query.dart';

class DigitalSignaturePad extends StatelessWidget {
  const DigitalSignaturePad({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.h(120),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.r(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: context.sp(60),
            color: AppColors.primary.withOpacity(0.08),
          ),
          CustomPaint(
            size: Size(context.w(160), context.h(50)),
            painter: _PulsePainter(),
          ),
          Text(
            "Tap here to sign",
            style: TextStyle(
              fontSize: context.sp(13),
              color: AppColors.primary.withOpacity(0.25),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _PulsePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1F2B6C).withOpacity(0.12)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, size.height / 2)
      ..lineTo(size.width * 0.3, size.height / 2)
      ..lineTo(size.width * 0.4, size.height * 0.1)
      ..lineTo(size.width * 0.5, size.height * 0.9)
      ..lineTo(size.width * 0.6, size.height / 2)
      ..lineTo(size.width, size.height / 2);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
