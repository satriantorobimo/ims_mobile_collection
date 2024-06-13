import 'package:mobile_collection/feature/notification/data/notification_response_model.dart';
import 'package:mobile_collection/feature/notification/domain/api/notification_api.dart';

class NotificationRepo {
  final NotificationApi notificationApi = NotificationApi();

  Future<NotificationResponseModel> attemptNotification(String collectorCode) =>
      notificationApi.attemptNotification(collectorCode);
}
