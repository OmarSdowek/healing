import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/constant/assets_manger.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/widgets/custom_button.dart';

class ReportCard extends StatelessWidget {
  final String reportId;
  final String title;
  final String type;
  final String status;
  final String date;
  final String? thumbnailUrl;
  final VoidCallback onView;

  const ReportCard({
    super.key,
    required this.reportId,
    required this.title,
    required this.type,
    required this.status,
    required this.date,
    required this.onView,
    this.thumbnailUrl,
  });

  @override
  Widget build(BuildContext context) {
    // thumbnailUrl is already resolved by the model (null if localhost)
    final imageUrl = thumbnailUrl;

    return Container(
      margin: EdgeInsets.only(bottom: context.h(16)),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(context.r(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Image + Status badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(context.r(12)),
                  topRight: Radius.circular(context.r(12)),
                ),
                child: imageUrl != null && imageUrl.startsWith('http')
                    ? Image.network(
                        imageUrl,
                        height: context.h(140),
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _fallbackImage(context),
                      )
                    : _fallbackImage(context),
              ),
              Positioned(
                top: context.h(8),
                right: context.w(8),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: context.w(10), vertical: context.h(4)),
                  decoration: BoxDecoration(
                    color: status.toLowerCase() == 'normal'
                        ? Colors.green
                        : Colors.orange,
                    borderRadius: BorderRadius.circular(context.r(6)),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: AppTextStyles.semiBold16Black.copyWith(
                        color: Colors.white, fontSize: 11),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.all(context.r(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type.toUpperCase(),
                  style: AppTextStyles.semiBold16Black
                      .copyWith(color: AppColors.primaryDark),
                ),
                context.verticalSpace(4),
                Text("ID: $reportId",
                    style: AppTextStyles.semiBold16Black),
                context.verticalSpace(4),
                Text(title, style: AppTextStyles.semiBold16Black),
                context.verticalSpace(4),
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(date,
                        style: AppTextStyles.semiBold16Black
                            .copyWith(color: Colors.grey)),
                  ],
                ),
                context.verticalSpace(16),
                CustomButton(
                  text: "View",
                  onPressed: onView,
                  backgroundColor: AppColors.primary,
                  textColor: Colors.white,
                  height: 40,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _fallbackImage(BuildContext context) {
    return Container(
      height: context.h(140),
      width: double.infinity,
      color: Colors.grey.shade200,
      child: const Icon(Icons.image_outlined, size: 48, color: Colors.grey),
    );
  }
}
