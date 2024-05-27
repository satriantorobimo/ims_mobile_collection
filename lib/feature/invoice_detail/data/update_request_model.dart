class UpdateRequestModel {
  int? pId;
  String? pResultCode;
  String? pResultRemarks;
  String? pResultPromiseDate;
  int? pResultPaymentAmount;

  UpdateRequestModel(
      {this.pId,
      this.pResultCode,
      this.pResultRemarks,
      this.pResultPromiseDate,
      this.pResultPaymentAmount});

  UpdateRequestModel.fromJson(Map<String, dynamic> json) {
    pId = json['p_id'];
    pResultCode = json['p_result_code'];
    pResultRemarks = json['p_result_remarks'];
    pResultPromiseDate = json['p_result_promise_date'];
    pResultPaymentAmount = json['p_result_payment_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['p_id'] = pId;
    data['p_result_code'] = pResultCode;
    data['p_result_remarks'] = pResultRemarks;
    data['p_result_promise_date'] = pResultPromiseDate;
    data['p_result_payment_amount'] = pResultPaymentAmount;
    return data;
  }
}
