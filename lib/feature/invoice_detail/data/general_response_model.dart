class GeneralResponseModel {
  int? result;
  int? statusCode;
  String? message;
  String? code;
  int? id;

  GeneralResponseModel(
      {this.result, this.statusCode, this.message, this.code, this.id});

  GeneralResponseModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    statusCode = json['StatusCode'];
    message = json['message'];
    code = json['code'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    data['StatusCode'] = statusCode;
    data['message'] = message;
    data['code'] = code;
    data['id'] = id;
    return data;
  }
}
