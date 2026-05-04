import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/services/local_notification_service.dart';
import '../../domin/entity/notification_display_item.dart';
import '../../domin/repo/notification_repo.dart';
import '../../domin/use_cases/build_notifications_from_appointments_use_case.dart';
import '../../domin/use_cases/get_notifications_use_case.dart';
import '../../domin/use_cases/map_api_notifications_use_case.dart';
import '../../../appointment/domin/use_cases/get_patient_appointments_use_case.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final GetPatientAppointmentsUseCase _getAppointmentsUseCase;
  final NotificationRepo _notificationRepo;
  final MapApiNotificationsUseCase _mapApiNotifications;
  final BuildNotificationsFromAppointmentsUseCase _buildFromAppointments;

  NotificationCubit({
    required GetNotificationsUseCase getNotificationsUseCase,
    required GetPatientAppointmentsUseCase getAppointmentsUseCase,
    required NotificationRepo notificationRepo,
  })  : _getNotificationsUseCase = getNotificationsUseCase,
        _getAppointmentsUseCase = getAppointmentsUseCase,
        _notificationRepo = notificationRepo,
        _mapApiNotifications = MapApiNotificationsUseCase(),
        _buildFromAppointments = BuildNotificationsFromAppointmentsUseCase(),
        super(NotificationInitial());

  Future<void> loadNotifications(int patientId) async {
    emit(NotificationLoading());

    // Step 1: Try real API
    final apiResult = await _getNotificationsUseCase();

    await apiResult.fold(
      (failure) async {
        print("⚠️ Notifications API failed — using fallback");
        await _loadFallback(patientId);
      },
      (notifications) async {
        if (notifications.isEmpty) {
          await _loadFallback(patientId);
          return;
        }

        // Show local notifications for unread items
        await LocalNotificationService.showFromApi(notifications);

        final items = _mapApiNotifications(notifications);
        if (items.isEmpty) {
          await _loadFallback(patientId);
        } else {
          emit(NotificationsLoaded(_groupByDay(items)));
        }
      },
    );
  }

  Future<void> markAsRead(int notificationId) async {
    await _notificationRepo.markAsRead(notificationId);
    // Reload to reflect updated read status
  }

  Future<void> markAllAsRead() async {
    await _notificationRepo.markAllAsRead();
  }

  Future<void> _loadFallback(int patientId) async {
    final aptResult = await _getAppointmentsUseCase(patientId);

    aptResult.fold(
      (failure) => emit(NotificationEmpty()),
      (appointments) {
        if (appointments.isEmpty) {
          emit(NotificationEmpty());
          return;
        }
        final items = _buildFromAppointments(appointments);

        // Show local notifications for upcoming appointments
        for (final item in items) {
          if (item.type == NotificationType.upcoming && item.isToday) {
            LocalNotificationService.show(
              id: item.hashCode,
              title: item.title,
              body: item.body,
            );
          }
        }

        if (items.isEmpty) {
          emit(NotificationEmpty());
        } else {
          emit(NotificationsLoaded(_groupByDay(items)));
        }
      },
    );
  }

  NotificationGroups _groupByDay(List<NotificationDisplayItem> items) {
    return NotificationGroups(
      today: items.where((i) => i.isToday).toList(),
      earlier: items.where((i) => !i.isToday).toList(),
    );
  }
}
