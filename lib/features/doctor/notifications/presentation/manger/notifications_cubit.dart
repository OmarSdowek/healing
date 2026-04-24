import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healing/features/doctor/notifications/data/models/notification_model.dart';
import 'package:healing/features/doctor/notifications/domin/repo/notifications_repo.dart';
import 'package:healing/features/doctor/notifications/domin/use_cases/get_notifications_use_case.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final GetNotificationsUseCase _getNotifications;
  final NotificationsRepo _repo;

  NotificationsCubit(this._getNotifications, this._repo)
    : super(NotificationsInitial());

  Future<void> loadNotifications() async {
    emit(NotificationsLoading());
    final result = await _getNotifications();
    result.fold(
      (f) => emit(NotificationsError(f.massage)),
      (list) => emit(NotificationsLoaded(list)),
    );
  }

  Future<void> markAsRead(String id) async {
    await _repo.markAsRead(id);
    loadNotifications();
  }

  Future<void> markAllAsRead() async {
    await _repo.markAllAsRead();
    loadNotifications();
  }
}
