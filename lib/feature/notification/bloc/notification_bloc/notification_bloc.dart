import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_collection/feature/home/domain/repo/dashboard_repo.dart';
import 'package:mobile_collection/feature/notification/domain/repo/notification_repo.dart';
import 'bloc.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationState get initialState => NotificationInitial();
  NotificationRepo notificationRepo = NotificationRepo();
  NotificationBloc({required this.notificationRepo}) : super(NotificationInitial()) {
    on<NotificationEvent>((event, emit) async {
      if (event is NotificationAttempt) {
        try {
          emit(NotificationLoading());
          final notificationResponseModel =
              await notificationRepo.attemptNotification(event.collectorCode);
          if (notificationResponseModel.result == 1) {
            emit(NotificationLoaded(
                notificationResponseModel: notificationResponseModel));
          } else if (notificationResponseModel.result == 0) {
            emit(NotificationError(notificationResponseModel.message));
          } else {
            emit(const NotificationException('error'));
          }
        } catch (e) {
          emit(NotificationException(e.toString()));
        }
      }
    });
  }
}
