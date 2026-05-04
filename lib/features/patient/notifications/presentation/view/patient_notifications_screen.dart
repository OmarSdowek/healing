import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/core/constant/app_colors.dart';
import 'package:healing/core/constant/app_text_style.dart';
import 'package:healing/core/di/injection_container.dart';
import 'package:healing/core/helper/extentions/media_query.dart';
import 'package:healing/core/widgets/custom_header.dart';
import '../../../auth/presentatiion/manger/patient_auth_cubit.dart';
import '../../domin/entity/notification_display_item.dart';
import '../manger/notification_cubit.dart';

class PatientNotificationsScreen extends StatelessWidget {
  const PatientNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PatientAuthCubit>(
      create: (_) => sl<PatientAuthCubit>()..meData(),
      child: BlocBuilder<PatientAuthCubit, PatientAuthState>(
        builder: (ctx, authState) {
          int patientId = 1;
          if (authState is PatientDataSuccess) {
            patientId =
                int.tryParse(authState.meData.patientId ?? '1') ?? 1;
          }

          return BlocProvider<NotificationCubit>(
            key: ValueKey(patientId),
            create: (_) => sl<NotificationCubit>()
              ..loadNotifications(patientId),
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
                            return _NotificationList(groups: state.groups);
                          }
                          if (state is NotificationEmpty ||
                              state is NotificationError) {
                            return const _EmptyState();
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Notification List ────────────────────────────────────────────────────────

class _NotificationList extends StatelessWidget {
  final NotificationGroups groups;
  const _NotificationList({required this.groups});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(20),
        vertical: context.h(8),
      ),
      children: [
        if (groups.today.isNotEmpty) ...[
          const _SectionLabel(label: "Today"),
          ...groups.today.map((n) => _NotificationTile(item: n)),
        ],
        if (groups.earlier.isNotEmpty) ...[
          const _SectionLabel(label: "Earlier"),
          ...groups.earlier.map((n) => _NotificationTile(item: n)),
        ],
      ],
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none,
              size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            "No notifications yet",
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

// ─── Section Label ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
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

// ─── Notification Tile ────────────────────────────────────────────────────────

class _NotificationTile extends StatelessWidget {
  final NotificationDisplayItem item;
  const _NotificationTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final config = _TileConfig.from(item.type);

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
              color: config.iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(config.icon,
                color: config.iconColor, size: context.sp(22)),
          ),
          context.horizontalSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTextStyles.semiBold16Black.copyWith(
                    fontSize: context.sp(14),
                    color: AppColors.primaryText,
                  ),
                ),
                context.verticalSpace(4),
                Text(
                  item.body,
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
            item.timeAgo,
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

// ─── Tile Config ─────────────────────────────────────────────────────────────

class _TileConfig {
  final Color iconBg;
  final Color iconColor;
  final IconData icon;

  const _TileConfig({
    required this.iconBg,
    required this.iconColor,
    required this.icon,
  });

  factory _TileConfig.from(NotificationType type) {
    switch (type) {
      case NotificationType.cancelled:
        return _TileConfig(
          iconBg: const Color(0xFFFFE5E5),
          iconColor: const Color(0xFFE53935),
          icon: Icons.event_busy_outlined,
        );
      case NotificationType.completed:
        return _TileConfig(
          iconBg: Colors.green.withOpacity(0.12),
          iconColor: Colors.green.shade700,
          icon: Icons.check_circle_outline,
        );
      case NotificationType.upcoming:
        return _TileConfig(
          iconBg: AppColors.primary.withOpacity(0.12),
          iconColor: AppColors.primary,
          icon: Icons.access_time_rounded,
        );
    }
  }
}
