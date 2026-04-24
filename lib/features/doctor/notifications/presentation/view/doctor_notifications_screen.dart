import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/network/api_service.dart';
import 'package:healing/core/widgets/custom_header.dart';
import 'package:healing/features/doctor/notifications/data/models/notification_model.dart';
import 'package:healing/features/doctor/notifications/data/repo/notifications_repo_impl.dart';
import 'package:healing/features/doctor/notifications/domin/use_cases/get_notifications_use_case.dart';
import 'package:healing/features/doctor/notifications/presentation/manger/notifications_cubit.dart';

class DoctorNotificationsScreen extends StatelessWidget {
  const DoctorNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final repo = NotificationsRepoImpl(ApiService());
        return NotificationsCubit(GetNotificationsUseCase(repo), repo)
          ..loadNotifications();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FB),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomHeader(title: "Notification"),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(20),
                  vertical: context.h(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Today",
                      style: AppTextStyles.semiBold16Black.copyWith(
                        color: AppColors.primary,
                        fontSize: context.sp(15),
                      ),
                    ),
                    BlocBuilder<NotificationsCubit, NotificationsState>(
                      builder: (context, state) => GestureDetector(
                        onTap: () =>
                            context.read<NotificationsCubit>().markAllAsRead(),
                        child: Text(
                          "Mark all read",
                          style: AppTextStyles.semiBold16Black.copyWith(
                            color: AppColors.grey,
                            fontSize: context.sp(13),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<NotificationsCubit, NotificationsState>(
                  builder: (context, state) {
                    if (state is NotificationsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is NotificationsError) {
                      return Center(child: Text(state.message));
                    }
                    if (state is NotificationsLoaded) {
                      if (state.notifications.isEmpty) {
                        return const Center(
                          child: Text("No notifications yet"),
                        );
                      }
                      return ListView.separated(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.w(20),
                        ),
                        itemCount: state.notifications.length,
                        separatorBuilder: (_, __) => context.verticalSpace(10),
                        itemBuilder: (context, index) {
                          final n = state.notifications[index];
                          return GestureDetector(
                            onTap: () => context
                                .read<NotificationsCubit>()
                                .markAsRead(n.id),
                            child: _NotificationTile(notification: n),
                          );
                        },
                      );
                    }
                    // fallback: static demo list
                    return _StaticNotificationList();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Static fallback (shown before first API call succeeds) ──────────────────

class _StaticNotificationList extends StatelessWidget {
  static const _items = [
    {
      "type": "upcoming",
      "title": "Upcoming Appointment",
      "body": "Reminder: You have an appointment with...",
      "time": "1h",
    },
    {
      "type": "upcoming",
      "title": "Upcoming Appointment",
      "body": "Reminder: You have an appointment with...",
      "time": "2h",
    },
    {
      "type": "upcoming",
      "title": "Upcoming Appointment",
      "body": "Reminder: You have an appointment with...",
      "time": "5h",
    },
    {
      "type": "cancelled",
      "title": "Appointment Cancelled",
      "body":
          "You have successfully cancelled your appointment with Ahmed Yasser.",
      "time": "3d",
    },
    {
      "type": "cancelled",
      "title": "Appointment Cancelled",
      "body":
          "You have successfully cancelled your appointment with Bassant Kamel.",
      "time": "5d",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: context.w(20)),
      itemCount: _items.length,
      separatorBuilder: (_, __) => context.verticalSpace(10),
      itemBuilder: (_, i) => _NotificationTileStatic(
        title: _items[i]["title"]!,
        body: _items[i]["body"]!,
        time: _items[i]["time"]!,
        isUpcoming: _items[i]["type"] == "upcoming",
      ),
    );
  }
}

// ── Tiles ───────────────────────────────────────────────────────────────────

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;

  const _NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context) {
    final isUpcoming =
        notification.type.toLowerCase().contains("appointment") &&
        !notification.type.toLowerCase().contains("cancel");
    return _NotificationTileStatic(
      title: notification.subject,
      body: notification.body,
      time: _formatTime(notification.createdAt),
      isUpcoming: isUpcoming,
      isRead: notification.isRead,
    );
  }

  String _formatTime(String createdAt) {
    try {
      final dt = DateTime.parse(createdAt);
      final diff = DateTime.now().difference(dt);
      if (diff.inDays > 0) return "${diff.inDays}d";
      if (diff.inHours > 0) return "${diff.inHours}h";
      return "${diff.inMinutes}m";
    } catch (_) {
      return "";
    }
  }
}

class _NotificationTileStatic extends StatelessWidget {
  final String title;
  final String body;
  final String time;
  final bool isUpcoming;
  final bool isRead;

  const _NotificationTileStatic({
    required this.title,
    required this.body,
    required this.time,
    required this.isUpcoming,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconBg = isUpcoming
        ? AppColors.primary.withOpacity(0.12)
        : const Color(0xFFFFE5E5);
    final iconColor = isUpcoming ? AppColors.primary : const Color(0xFFE53935);
    final icon = isUpcoming
        ? Icons.access_time_rounded
        : Icons.event_busy_outlined;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isRead ? AppColors.white : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: isRead
            ? null
            : Border.all(color: AppColors.primary.withOpacity(0.15)),
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
                Text(
                  title,
                  style: AppTextStyles.semiBold16Black.copyWith(
                    fontSize: context.sp(14),
                    color: AppColors.primaryText,
                  ),
                ),
                context.verticalSpace(4),
                Text(
                  body,
                  style: AppTextStyles.semiBold16Black.copyWith(
                    fontSize: context.sp(12),
                    color: AppColors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          context.horizontalSpace(8),
          Text(
            time,
            style: AppTextStyles.semiBold16Black.copyWith(
              fontSize: context.sp(12),
              color: AppColors.grey,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
