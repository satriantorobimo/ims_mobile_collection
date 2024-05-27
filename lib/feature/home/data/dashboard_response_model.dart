class DashboardResponseModel {
  int? result;
  int? statusCode;
  String? message;
  List<Data>? data;
  String? code;
  int? id;

  DashboardResponseModel(
      {this.result,
      this.statusCode,
      this.message,
      this.data,
      this.code,
      this.id});

  DashboardResponseModel.fromJson(Map<String, dynamic> json) {
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
  List<DailyTaskStatus>? dailyTaskStatus;
  List<Achievement>? achievement;

  Data({this.dailyTaskStatus, this.achievement});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['daily_task_status'] != null) {
      dailyTaskStatus = <DailyTaskStatus>[];
      json['daily_task_status'].forEach((v) {
        dailyTaskStatus!.add(DailyTaskStatus.fromJson(v));
      });
    }
    if (json['achievement'] != null) {
      achievement = <Achievement>[];
      json['achievement'].forEach((v) {
        achievement!.add(Achievement.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (dailyTaskStatus != null) {
      data['daily_task_status'] =
          dailyTaskStatus!.map((v) => v.toJson()).toList();
    }
    if (achievement != null) {
      data['achievement'] = achievement!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DailyTaskStatus {
  String? resultStatus;
  int? resultCount;

  DailyTaskStatus({this.resultStatus, this.resultCount});

  DailyTaskStatus.fromJson(Map<String, dynamic> json) {
    resultStatus = json['result_status'];
    resultCount = json['result_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result_status'] = resultStatus;
    data['result_count'] = resultCount;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'result_status': resultStatus,
      'result_count': resultCount,
    };
  }

  factory DailyTaskStatus.fromMap(Map<String, dynamic> map) {
    return DailyTaskStatus(
      resultStatus: map['result_status'],
      resultCount: map['result_count'],
    );
  }
}

class Achievement {
  String? category;
  String? dailyCount;
  String? dailyTarget;
  String? monthlyCount;
  String? monthlyTarget;

  Achievement(
      {this.category,
      this.dailyCount,
      this.dailyTarget,
      this.monthlyCount,
      this.monthlyTarget});

  Achievement.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    dailyCount = json['daily_count'];
    dailyTarget = json['daily_target'];
    monthlyCount = json['monthly_count'];
    monthlyTarget = json['monthly_target'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category'] = category;
    data['daily_count'] = dailyCount;
    data['daily_target'] = dailyTarget;
    data['monthly_count'] = monthlyCount;
    data['monthly_target'] = monthlyTarget;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'daily_count': dailyCount,
      'daily_target': dailyTarget,
      'monthly_count': monthlyCount,
      'monthly_target': monthlyTarget,
    };
  }

  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      category: map['category'],
      dailyCount: map['daily_count'],
      dailyTarget: map['daily_target'],
      monthlyCount: map['monthly_count'],
      monthlyTarget: map['monthly_target'],
    );
  }
}
