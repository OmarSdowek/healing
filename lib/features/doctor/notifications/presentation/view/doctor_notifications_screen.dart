import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/di/injection_container.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/widgets/custom_header.dart';
import '../../../../patient/notifications/presentation/manger/notification_cubit.dart';
import '../../../../patient/notifications/domin/entity/notification_display_item.dart';

class DoctorNotificationsScreen extends StatelessWidget {
  const DoctorNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NotificationCubit>()..loadNotifications(0),
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FB),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomHeader(title: "Notification"),
              Expanded(
                child: BlocBuilder<NotificationCubit, NotificationState>(
                  builder: (_, state) {
                    if (state is NotificationLoading) {
                      return const Center(
                          child: CircularProgressIndicator());
                    }

                    if (state is NotificationsLoaded) {
                      final groups = state.groups;
                      if (groups.isEmpty) {
                        return _emptyState();
                      }

                      return ListView(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.w(20),
                          vertical: context.h(8),
                        ),
                        children: [
                          if (groups.today.isNotEmpty) ...[
                            _sectionLabel(context, "Today"),
                            ...groups.today
                                .map((n) => _NotificationTile(item: n)),
                          ],
                          if (groups.earlier.isNotEmpty) ...[
                            _sectionLabel(context, "Earlier"),
                            ...groups.earlier
                                .map((n) => _NotificationTile(item: n)),
                          ],
                        ],
                      );
                    }

                    return _emptyState();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text("No notifications yet",
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.h(8), top: context.h(4)),
      child: Text(
        label,
        style: AppTextStyles.semiBold16Black.copyWith(
          color: AppColors.primary,
          fontSize: context.sp(15),
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationDisplayItem item;
  const _NotificationTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final isUpcoming = item.type == NotificationType.upcoming;
    final isCancelled = item.type == NotificationType.cancelled;

    final iconBg = isUpcoming
        ? AppColors.primary.withOpacity(0.12)
        : isCancelled
            ? const Color(0xFFFFE5E5)
            : Colors.green.withOpacity(0.12);

    final iconColor = isUpcoming
        ? AppColors.primary
        : isCancelled
            ? const Color(0xFFE53935)
            : Colors.green.shade700;

    final icon = isUpcoming
        ? Icons.access_time_rounded
        : isCancelled
            ? Icons.event_busy_outlined
            : Icons.check_circle_outline;

    return Container(
      margin: EdgeInsets.only(bottom: context.h(10)),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: context.w(42),
            height: context.h(42),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: context.sp(22)),
          ),
          context.horizontalSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    style: AppTextStyles.semiBold16Black.copyWith(
                      fontSize: context.sp(14),
                      color: AppColors.primaryText,
                    )),
                context.verticalSpace(4),
                Text(item.body,
                    style: AppTextStyles.semiBold16Black.copyWith(
                      fontSize: context.sp(12),
                      color: AppColors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          context.horizontalSpace(8),
          Text(item.timeAgo,
              style: AppTextStyles.semiBold16Black.copyWith(
                fontSize: context.sp(12),
                color: AppColors.grey,
                fontWeight: FontWeight.w400,
              )),
        ],
      ),
    );
  }
}
