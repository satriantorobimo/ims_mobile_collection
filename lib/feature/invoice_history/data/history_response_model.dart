class HistoryResponseModel {
  int? result;
  int? statusCode;
  String? message;
  List<Data>? data;
  String? code;
  int? id;

  HistoryResponseModel(
      {this.result,
      this.statusCode,
      this.message,
      this.data,
      this.code,
      this.id});

  HistoryResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? agreementNo;
  int? installmentNo;
  double? installmentAmount;
  String? resultCode;
  String? resultPromiseDate;
  double? resultPaymentAmount;
  String? resultRemarks;
  String? collectorName;
  String? modDate;

  Data(
      {this.agreementNo,
      this.installmentNo,
      this.installmentAmount,
      this.resultCode,
      this.resultPromiseDate,
      this.resultPaymentAmount,
      this.resultRemarks,
      this.collectorName,
      this.modDate});

  Data.fromJson(Map<String, dynamic> json) {
    installmentNo = json['installment_no'];
    installmentAmount = json['installment_amount'];
    resultCode = json['result_code'];
    resultPromiseDate = json['result_promise_date'];
    resultPaymentAmount = json['result_payment_amount'];
    resultRemarks = json['result_remarks'];
    collectorName = json['collector_name'];
    modDate = json['mod_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['installment_no'] = installmentNo;
    data['installment_amount'] = installmentAmount;
    data['result_code'] = resultCode;
    data['result_promise_date'] = resultPromiseDate;
    data['result_payment_amount'] = resultPaymentAmount;
    data['result_remarks'] = resultRemarks;
    data['collector_name'] = collectorName;
    data['mod_date'] = modDate;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'agreement_no': agreementNo,
      'installment_no': installmentNo,
      'installment_amount': installmentAmount,
      'result_code': resultCode,
      'result_promise_date': resultPromiseDate,
      'result_payment_amount': resultPaymentAmount,
      'result_remarks': resultRemarks,
      'mod_date': modDate,
    };
  }

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      agreementNo: map['agreement_no'],
      installmentNo: map['installment_no'],
      installmentAmount: map['installment_amount'],
      resultCode: map['result_code'],
      resultPromiseDate: map['result_promise_date'],
      resultPaymentAmount: map['result_payment_amount'],
      resultRemarks: map['result_remarks'],
      modDate: map['mod_date'],
    );
  }
}
