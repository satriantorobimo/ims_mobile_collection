class NotificationResponseModel {
  int? result;
  int? statusCode;
  String? message;
  List<Data>? data;
  String? code;
  int? id;

  NotificationResponseModel(
      {this.result,
      this.statusCode,
      this.message,
      this.data,
      this.code,
      this.id});

  NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    statusCode = json['StatusCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    code = json['code'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    data['StatusCode'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['code'] = code;
    data['id'] = id;
    return data;
  }
}

class Data {
  int? id;
  String? picCode;
  String? picName;
  String? taskType;
  String? taskCode;
  String? title;
  String? message;
  String? creDate;

  Data(
      {this.id,
      this.picCode,
      this.picName,
      this.taskType,
      this.taskCode,
      this.title,
      this.message,
      this.creDate});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    picCode = json['pic_code'];
    picName = json['pic_name'];
    taskType = json['task_type'];
    taskCode = json['task_code'];
    title = json['title'];
    message = json['message'];
    creDate = json['cre_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['pic_code'] = picCode;
    data['pic_name'] = picName;
    data['task_type'] = taskType;
    data['task_code'] = taskCode;
    data['title'] = title;
    data['message'] = message;
    data['cre_date'] = creDate;
    return data;
  }
}
