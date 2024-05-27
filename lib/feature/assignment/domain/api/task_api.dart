import 'dart:convert';

import 'package:mobile_collection/feature/assignment/data/task_list_response_model.dart';
import 'package:mobile_collection/utility/general_util.dart';
import 'package:mobile_collection/utility/shared_pref_util.dart';
import 'package:mobile_collection/utility/url_util.dart';
import 'package:http/http.dart' as http;

class TaskApi {
  TaskListResponseModel taskListResponseModel = TaskListResponseModel();
  final UrlUtil urlUtil = UrlUtil();

  Future<TaskListResponseModel> attemptTaskList(String collectorCode) async {
    List a = [];
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(
        token!, GeneralUtil().encodeId(collectorCode));
    final Map mapData = {};
    mapData['p_collector_code'] = collectorCode;
    a.add(mapData);

    final json = jsonEncode(a);

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(Uri.parse(urlUtil.getUrlTaskList()),
          body: json, headers: header);
      if (res.statusCode == 200) {
        stopwatch.stop();
        taskListResponseModel =
            TaskListResponseModel.fromJson(jsonDecode(res.body));
        return taskListResponseModel;
      } else if (res.statusCode == 401) {
        throw 'expired';
      } else {
        taskListResponseModel =
            TaskListResponseModel.fromJson(jsonDecode(res.body));
        throw taskListResponseModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }
}
