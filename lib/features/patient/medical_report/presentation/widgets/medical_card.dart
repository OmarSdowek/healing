import 'package:flutter/material.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/widgets/doctor_avatar.dart';

class ReportCard extends StatelessWidget {
  final String reportId;
  final String title;
  final String type;
  final String status;
  final String date;
  final String? thumbnailUrl;
  final String? doctorName;
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
    this.doctorName,
  });

  Color _statusTextColor(String s) {
    switch (s.toLowerCase()) {
      case 'normal':
      case 'active':
      case 'completed':
        return Colors.green.shade700;
      case 'abnormal':
        return Colors.red.shade700;
      default:
        return Colors.orange.shade700;
    }
  }

  Color _statusBgColor(String s) {
    switch (s.toLowerCase()) {
      case 'normal':
      case 'active':
      case 'completed':
        return Colors.green.shade50;
      case 'abnormal':
        return Colors.red.shade50;
      default:
        return Colors.orange.shade50;
    }
  }

  String _formatDate(String raw) {
    try {
      final d = DateTime.parse(raw.length >= 10 ? raw.substring(0, 10) : raw);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      return '${months[d.month - 1]} ${d.day.toString().padLeft(2, '0')}, ${d.year}';
    } catch (_) {
      return raw.length >= 10 ? raw.substring(0, 10) : raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusTextColor = _statusTextColor(status);
    final statusBgColor = _statusBgColor(status);
    final displayId = reportId.length > 8
        ? '#${reportId.substring(0, 8).toUpperCase()}'
        : '#$reportId';

    return Container(
      margin: EdgeInsets.only(bottom: context.h(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.r(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image + Status badge ──────────────────────────────────────
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(context.r(20)),
                  topRight: Radius.circular(context.r(20)),
                ),
                child: NetworkImageWithFallback(
                  imageUrl: thumbnailUrl,
                  height: context.h(200),
                  width: double.infinity,
                  fit: BoxFit.cover,
                  fallback: _defaultImage(context),
                ),
              ),
              Positioned(
                top: context.h(14),
                right: context.w(14),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: context.w(14), vertical: context.h(6)),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(context.r(30)),
                    border: Border.all(
                        color: statusTextColor.withOpacity(0.3), width: 1),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      fontSize: context.sp(12),
                      fontWeight: FontWeight.w700,
                      color: statusTextColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ── Card body ─────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(
                context.w(16), context.h(14), context.w(16), context.h(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type + ID
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      type.isNotEmpty ? type.toUpperCase() : 'MEDICAL RECORD',
                      style: TextStyle(
                        fontSize: context.sp(13),
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        letterSpacing: 0.3,
                      ),
                    ),
                    Text(
                      'ID: $displayId',
                      style: TextStyle(
                        fontSize: context.sp(13),
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                context.verticalSpace(6),

                // Title
                Text(
                  title.isNotEmpty ? title : 'Medical Record',
                  style: TextStyle(
                    fontSize: context.sp(17),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1F2937),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                context.verticalSpace(6),

                // Doctor name
                if (doctorName != null && doctorName!.isNotEmpty) ...[
                  Row(
                    children: [
                      Icon(Icons.person_outline,
                          size: context.sp(14), color: AppColors.primary),
                      context.horizontalSpace(4),
                      Text(
                        'Dr. $doctorName',
                        style: TextStyle(
                          fontSize: context.sp(13),
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  context.verticalSpace(6),
                ],

                // Date
                Row(
                  children: [
                    Icon(Icons.calendar_month_outlined,
                        size: context.sp(15), color: Colors.grey.shade500),
                    context.horizontalSpace(6),
                    Text(
                      _formatDate(date),
                      style: TextStyle(
                          fontSize: context.sp(14),
                          color: Colors.grey.shade600),
                    ),
                  ],
                ),
                context.verticalSpace(14),

                // View button
                SizedBox(
                  width: double.infinity,
                  height: context.h(48),
                  child: ElevatedButton.icon(
                    onPressed: onView,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(context.r(14))),
                      elevation: 0,
                    ),
                    icon: Icon(Icons.remove_red_eye_outlined,
                        color: Colors.white, size: context.sp(18)),
                    label: Text(
                      'View',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: context.sp(15),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _defaultImage(BuildContext context) {
    return Container(
      height: context.h(200),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFE07B5A).withOpacity(0.7),
            const Color(0xFFE07B5A).withOpacity(0.3),
            Colors.white.withOpacity(0.9),
            const Color(0xFFE07B5A).withOpacity(0.5),
          ],
          stops: const [0.0, 0.3, 0.6, 1.0],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.show_chart_rounded,
            size: context.sp(52),
            color: const Color(0xFFE07B5A).withOpacity(0.7),
          ),
        ),
      ),
    );
  }
}
