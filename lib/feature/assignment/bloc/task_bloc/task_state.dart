import 'package:equatable/equatable.dart';
import 'package:mobile_collection/feature/assignment/data/task_list_response_model.dart';

abstract class TaskListState extends Equatable {
  const TaskListState();

  @override
  List<Object> get props => [];
}

class TaskListInitial extends TaskListState {}

class TaskListLoading extends TaskListState {}

class TaskListLoaded extends TaskListState {
  const TaskListLoaded({required this.taskListResponseModel});
  final TaskListResponseModel taskListResponseModel;

  @override
  List<Object> get props => [taskListResponseModel];
}

class TaskListPersonalLoaded extends TaskListState {
  const TaskListPersonalLoaded({required this.taskListResponseModel});
  final TaskListResponseModel taskListResponseModel;

  @override
  List<Object> get props => [taskListResponseModel];
}

class TaskListError extends TaskListState {
  const TaskListError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class TaskListException extends TaskListState {
  const TaskListException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
