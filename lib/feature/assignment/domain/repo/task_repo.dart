import 'package:mobile_collection/feature/assignment/data/task_list_response_model.dart';
import 'package:mobile_collection/feature/assignment/domain/api/task_api.dart';

class TaskRepo {
  final TaskApi taskApi = TaskApi();
  Future<TaskListResponseModel> attemptTaskList(String collectorCode) =>
      taskApi.attemptTaskList(collectorCode);
}
