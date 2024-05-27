class AmortizationResponseModel {
  int? result;
  int? statusCode;
  String? message;
  List<Data>? data;

  AmortizationResponseModel(
      {this.result, this.statusCode, this.message, this.data});

  AmortizationResponseModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    statusCode = json['StatusCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    data['StatusCode'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? agreementNo;
  int? installmentNo;
  String? dueDate;
  double? installmentAmount;
  double? osPrincipalAmount;
  List<PaymentList>? paymentList;

  Data(
      {this.agreementNo,
      this.installmentNo,
      this.dueDate,
      this.installmentAmount,
      this.osPrincipalAmount,
      this.paymentList});

  Data.fromJson(Map<String, dynamic> json) {
    installmentNo = json['installment_no'];
    dueDate = json['due_date'];
    installmentAmount = json['installment_amount'];
    osPrincipalAmount = json['os_principal_amount'];
    if (json['payment_list'] != null) {
      paymentList = <PaymentList>[];
      json['payment_list'].forEach((v) {
        paymentList!.add(PaymentList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['installment_no'] = installmentNo;
    data['due_date'] = dueDate;
    data['installment_amount'] = installmentAmount;
    data['os_principal_amount'] = osPrincipalAmount;
    if (paymentList != null) {
      data['payment_list'] = paymentList!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'agreement_no': agreementNo,
      'installment_no': installmentNo,
      'due_date': dueDate,
      'installment_amount': installmentAmount,
      'os_principal_amount': osPrincipalAmount,
    };
  }

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      agreementNo: map['agreement_no'],
      installmentNo: map['installment_no'],
      dueDate: map['due_date'],
      installmentAmount: map['installment_amount'],
      osPrincipalAmount: map['os_principal_amount'],
    );
  }
}

class PaymentList {
  String? agreementNo;
  String? paymentDate;
  String? paymentSourceType;
  double? paymentAmount;

  PaymentList(
      {this.agreementNo,
      this.paymentDate,
      this.paymentSourceType,
      this.paymentAmount});

  PaymentList.fromJson(Map<String, dynamic> json) {
    paymentDate = json['payment_date'];
    paymentSourceType = json['payment_source_type'];
    paymentAmount = json['payment_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['payment_date'] = paymentDate;
    data['payment_source_type'] = paymentSourceType;
    data['payment_amount'] = paymentAmount;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'agreement_no': agreementNo,
      'payment_date': paymentDate,
      'payment_source_type': paymentSourceType,
      'payment_amount': paymentAmount,
    };
  }

  factory PaymentList.fromMap(Map<String, dynamic> map) {
    return PaymentList(
      agreementNo: map['agreement_no'],
      paymentDate: map['payment_date'],
      paymentSourceType: map['payment_source_type'],
      paymentAmount: map['payment_amount'],
    );
  }
}
