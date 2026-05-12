import 'package:flutter/material.dart';
import '../helper/image_helper.dart';

/// Displays a profile picture as a circle.
/// - Shows network image if URL resolves correctly
/// - Falls back to Icons.person on error or missing URL
class DoctorAvatar extends StatelessWidget {
  final String? pictureUrl;
  final double radius;
  final Color? backgroundColor;
  final Color? iconColor;

  const DoctorAvatar({
    super.key,
    required this.pictureUrl,
    this.radius = 28,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final resolved = resolveImageUrl(pictureUrl);

    if (resolved != null) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ?? Colors.grey.shade200,
        child: ClipOval(
          child: Image.network(
            resolved,
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _fallback(),
            loadingBuilder: (_, child, progress) {
              if (progress == null) return child;
              return _fallback();
            },
          ),
        ),
      );
    }

    return _fallback();
  }

  Widget _fallback() {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? Colors.grey.shade200,
      child: Icon(
        Icons.person,
        size: radius,
        color: iconColor ?? Colors.grey.shade500,
      ),
    );
  }
}

/// Rectangular image widget with rounded corners.
/// Falls back to Icons.person if image fails or URL is missing.
class DoctorImage extends StatelessWidget {
  final String? pictureUrl;
  final double height;
  final double width;
  final double borderRadius;

  const DoctorImage({
    super.key,
    required this.pictureUrl,
    this.height = 90,
    this.width = 90,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final resolved = resolveImageUrl(pictureUrl);

    if (resolved != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.network(
          resolved,
          height: height,
          width: width,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _fallback(),
          loadingBuilder: (_, child, progress) {
            if (progress == null) return child;
            return _loadingPlaceholder();
          },
        ),
      );
    }

    return _fallback();
  }

  Widget _fallback() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        height: height,
        width: width,
        color: Colors.grey.shade200,
        child: Icon(Icons.person,
            size: height * 0.5, color: Colors.grey.shade400),
      ),
    );
  }

  Widget _loadingPlaceholder() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        height: height,
        width: width,
        color: Colors.grey.shade100,
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
    );
  }
}

/// Network image with fallback — for any rectangular image
class NetworkImageWithFallback extends StatelessWidget {
  final String? imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  final double borderRadius;
  final Widget? fallback;

  const NetworkImageWithFallback({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius = 0,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    final resolved = resolveImageUrl(imageUrl);

    if (resolved != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.network(
          resolved,
          height: height,
          width: width,
          fit: fit,
          errorBuilder: (_, __, ___) =>
              fallback ?? _defaultFallback(),
        ),
      );
    }

    return fallback ?? _defaultFallback();
  }

  Widget _defaultFallback() {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Icon(Icons.person,
          size: (height ?? 40) * 0.5, color: Colors.grey.shade400),
    );
  }
}
