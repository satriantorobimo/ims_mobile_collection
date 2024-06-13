import 'package:equatable/equatable.dart';
import 'package:mobile_collection/feature/notification/data/notification_response_model.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  const NotificationLoaded({required this.notificationResponseModel});
  final NotificationResponseModel notificationResponseModel;

  @override
  List<Object> get props => [notificationResponseModel];
}

class NotificationError extends NotificationState {
  const NotificationError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class NotificationException extends NotificationState {
  const NotificationException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
