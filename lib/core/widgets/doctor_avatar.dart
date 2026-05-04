import 'package:flutter/material.dart';
import '../helper/image_helper.dart';

/// Displays a doctor's profile picture.
/// - Shows network image if URL is valid and accessible
/// - Falls back to Icons.person if URL is localhost or empty
class DoctorAvatar extends StatelessWidget {
  final String? pictureUrl;
  final double radius;

  const DoctorAvatar({
    super.key,
    required this.pictureUrl,
    this.radius = 28,
  });

  @override
  Widget build(BuildContext context) {
    final resolved = resolveImageUrl(pictureUrl);

    if (resolved != null) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey.shade200,
        backgroundImage: NetworkImage(resolved),
        onBackgroundImageError: (_, __) {},
      );
    }

    // Default fallback — Icons.person
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey.shade200,
      child: Icon(
        Icons.person,
        size: radius,
        color: Colors.grey.shade500,
      ),
    );
  }
}

/// Rectangular doctor image (for DoctorCard)
class DoctorImage extends StatelessWidget {
  final String? pictureUrl;
  final double height;
  final double width;

  const DoctorImage({
    super.key,
    required this.pictureUrl,
    this.height = 90,
    this.width = 90,
  });

  @override
  Widget build(BuildContext context) {
    final resolved = resolveImageUrl(pictureUrl);

    if (resolved != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          resolved,
          height: height,
          width: width,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _fallback(),
        ),
      );
    }

    return _fallback();
  }

  Widget _fallback() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: height,
        width: width,
        color: Colors.grey.shade200,
        child: const Icon(Icons.person, size: 40, color: Colors.grey),
      ),
    );
  }
}
