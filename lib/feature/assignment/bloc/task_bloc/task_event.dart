import 'package:equatable/equatable.dart';

abstract class TaskListEvent extends Equatable {
  const TaskListEvent();
}

class TaskListAttempt extends TaskListEvent {
  const TaskListAttempt(this.collectorCode);
  final String collectorCode;

  @override
  List<Object> get props => [collectorCode];
}
