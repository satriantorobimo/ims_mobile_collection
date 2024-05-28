class UpdateRequestModel {
  int? pTaskId;
  String? pResultCode;
  String? pResultRemarks;
  String? pResultPromiseDate;
  int? pResultPaymentAmount;

  UpdateRequestModel(
      {this.pTaskId,
      this.pResultCode,
      this.pResultRemarks,
      this.pResultPromiseDate,
      this.pResultPaymentAmount});

  UpdateRequestModel.fromJson(Map<String, dynamic> json) {
    pTaskId = json['p_task_id'];
    pResultCode = json['p_result_code'];
    pResultRemarks = json['p_result_remarks'];
    pResultPromiseDate = json['p_result_promise_date'];
    pResultPaymentAmount = json['p_result_payment_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['p_task_id'] = pTaskId;
    data['p_result_code'] = pResultCode;
    data['p_result_remarks'] = pResultRemarks;
    data['p_result_promise_date'] = pResultPromiseDate;
    data['p_result_payment_amount'] = pResultPaymentAmount;
    return data;
  }
}
