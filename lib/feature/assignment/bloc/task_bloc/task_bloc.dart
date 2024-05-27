import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_collection/feature/assignment/domain/repo/task_repo.dart';
import 'bloc.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  TaskListState get initialState => TaskListInitial();
  TaskRepo taskRepo = TaskRepo();
  TaskListBloc({required this.taskRepo}) : super(TaskListInitial()) {
    on<TaskListEvent>((event, emit) async {
      if (event is TaskListAttempt) {
        try {
          emit(TaskListLoading());
          final taskListResponseModel =
              await taskRepo.attemptTaskList(event.collectorCode);
          if (taskListResponseModel.result == 1) {
            emit(TaskListLoaded(taskListResponseModel: taskListResponseModel));
          } else if (taskListResponseModel.result == 0) {
            emit(TaskListError(taskListResponseModel.message));
          } else {
            emit(const TaskListException('error'));
          }
        } catch (e) {
          emit(TaskListException(e.toString()));
        }
      }
    });
  }
}
