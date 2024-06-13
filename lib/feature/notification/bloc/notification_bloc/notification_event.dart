import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
}

class NotificationAttempt extends NotificationEvent {
  const NotificationAttempt(this.collectorCode);
  final String collectorCode;

  @override
  List<Object> get props => [collectorCode];
}
