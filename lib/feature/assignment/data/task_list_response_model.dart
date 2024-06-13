class TaskListResponseModel {
  int? result;
  int? statusCode;
  String? message;
  List<Data>? data;
  String? code;
  int? id;

  TaskListResponseModel(
      {this.result,
      this.statusCode,
      this.message,
      this.data,
      this.code,
      this.id});

  TaskListResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? clientNo;
  String? clientName;
  int? invoiceCount;
  String? taskDate;
  String? taskStatus;
  String? phoneNo1;
  String? phoneNo2;
  double? overdueInstallment;
  String? fullAddress;
  String? address;
  String? rt;
  String? rw;
  String? village;
  String? subDistrict;
  String? cityName;
  String? provinceName;
  String? zipCode;
  String? latitude;
  String? longitude;
  List<AgreementList>? agreementList;

  Data(
      {this.clientNo,
      this.clientName,
      this.invoiceCount,
      this.taskDate,
      this.taskStatus,
      this.phoneNo1,
      this.phoneNo2,
      this.overdueInstallment,
      this.fullAddress,
      this.address,
      this.rt,
      this.rw,
      this.village,
      this.subDistrict,
      this.cityName,
      this.provinceName,
      this.zipCode,
      this.latitude,
      this.longitude,
      this.agreementList});

  Data.fromJson(Map<String, dynamic> json) {
    clientNo = json['client_no'];
    clientName = json['client_name'];
    invoiceCount = json['invoice_count'];
    taskDate = json['task_date'];
    taskStatus = json['task_status'];
    phoneNo1 = json['phone_no_1'];
    phoneNo2 = json['phone_no_2'];
    overdueInstallment = json['overdue_installment'];
    fullAddress = json['full_address'];
    address = json['address'];
    rt = json['rt'];
    rw = json['rw'];
    village = json['village'];
    subDistrict = json['sub_district'];
    cityName = json['city_name'];
    provinceName = json['province_name'];
    zipCode = json['zip_code'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    if (json['agreement_list'] != null) {
      agreementList = <AgreementList>[];
      json['agreement_list'].forEach((v) {
        agreementList!.add(AgreementList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['client_no'] = clientNo;
    data['client_name'] = clientName;
    data['invoice_count'] = invoiceCount;
    data['task_date'] = taskDate;
    data['task_status'] = taskStatus;
    data['phone_no_1'] = phoneNo1;
    data['phone_no_2'] = phoneNo2;
    data['overdue_installment'] = overdueInstallment;
    data['full_address'] = fullAddress;
    data['address'] = address;
    data['rt'] = rt;
    data['rw'] = rw;
    data['village'] = village;
    data['sub_district'] = subDistrict;
    data['city_name'] = cityName;
    data['province_name'] = provinceName;
    data['zip_code'] = zipCode;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    if (agreementList != null) {
      data['agreement_list'] = agreementList!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'client_no': clientNo,
      'client_name': clientName,
      'invoice_count': invoiceCount,
      'task_date': taskDate,
      'task_status': taskStatus,
      'phone_no_1': phoneNo1,
      'phone_no_2': phoneNo2,
      'overdue_installment': overdueInstallment,
      'full_address': fullAddress,
      'address': address,
      'rt': rt,
      'rw': rw,
      'village': village,
      'sub_district': subDistrict,
      'city_name': cityName,
      'province_name': provinceName,
      'zip_code': zipCode,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      clientNo: map['client_no'],
      clientName: map['client_name'],
      invoiceCount: map['invoice_count'],
      taskDate: map['task_date'],
      taskStatus: map['task_status'],
      phoneNo1: map['phone_no_1'],
      phoneNo2: map['phone_no_2'],
      overdueInstallment: map['overdue_installment'],
      fullAddress: map['full_address'],
      address: map['address'],
      rt: map['rt'],
      rw: map['rw'],
      village: map['village'],
      subDistrict: map['sub_district'],
      cityName: map['city_name'],
      provinceName: map['province_name'],
      zipCode: map['zip_code'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}

class DataEmpty {
  String? clientNo;
  String? clientName;
  int? invoiceCount;
  String? phoneNo1;
  String? phoneNo2;
  double? overdueInstallment;
  String? fullAddress;
  String? address;
  String? rt;
  String? rw;
  String? village;
  String? subDistrict;
  String? cityName;
  String? provinceName;
  String? zipCode;
  String? latitude;
  String? longitude;
  List<AgreementList>? agreementList;

  DataEmpty(
      {this.clientNo,
      this.clientName,
      this.invoiceCount,
      this.phoneNo1,
      this.phoneNo2,
      this.overdueInstallment,
      this.fullAddress,
      this.address,
      this.rt,
      this.rw,
      this.village,
      this.subDistrict,
      this.cityName,
      this.provinceName,
      this.zipCode,
      this.latitude,
      this.longitude,
      this.agreementList});

  DataEmpty.fromJson(Map<String, dynamic> json) {
    clientNo = json['client_no'];
    clientName = json['client_name'];
    invoiceCount = json['invoice_count'];
    phoneNo1 = json['phone_no_1'];
    phoneNo2 = json['phone_no_2'];
    overdueInstallment = json['overdue_installment'];
    fullAddress = json['full_address'];
    address = json['address'];
    rt = json['rt'];
    rw = json['rw'];
    village = json['village'];
    subDistrict = json['sub_district'];
    cityName = json['city_name'];
    provinceName = json['province_name'];
    zipCode = json['zip_code'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    if (json['agreement_list'] != null) {
      agreementList = <AgreementList>[];
      json['agreement_list'].forEach((v) {
        agreementList!.add(AgreementList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['client_no'] = clientNo;
    data['client_name'] = clientName;
    data['invoice_count'] = invoiceCount;
    data['phone_no_1'] = phoneNo1;
    data['phone_no_2'] = phoneNo2;
    data['overdue_installment'] = overdueInstallment;
    data['full_address'] = fullAddress;
    data['address'] = address;
    data['rt'] = rt;
    data['rw'] = rw;
    data['village'] = village;
    data['sub_district'] = subDistrict;
    data['city_name'] = cityName;
    data['province_name'] = provinceName;
    data['zip_code'] = zipCode;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    if (agreementList != null) {
      data['agreement_list'] = agreementList!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'client_no': clientNo,
      'client_name': clientName,
      'invoice_count': invoiceCount,
      'phone_no_1': phoneNo1,
      'phone_no_2': phoneNo2,
      'overdue_installment': overdueInstallment,
      'full_address': fullAddress,
      'address': address,
      'rt': rt,
      'rw': rw,
      'village': village,
      'sub_district': subDistrict,
      'city_name': cityName,
      'province_name': provinceName,
      'zip_code': zipCode,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory DataEmpty.fromMap(Map<String, dynamic> map) {
    return DataEmpty(
      clientNo: map['code'],
      clientName: map['date'],
      invoiceCount: map['status'],
      phoneNo1: map['remark'],
      phoneNo2: map['result'],
      overdueInstallment: map['pic_code'],
      fullAddress: map['pic_name'],
      address: map['branch_name'],
      rt: map['agreement_no'],
      rw: map['client_name'],
      village: map['mobile_no'],
      subDistrict: map['location'],
      cityName: map['latitude'],
      provinceName: map['longitude'],
      zipCode: map['type'],
      latitude: map['appraisal_amount'],
      longitude: map['review_remark'],
    );
  }
}

class AgreementList {
  int? taskId;
  String? agreementNo;
  String? collateralNo;
  int? overdueDays;
  int? overduePeriod;
  double? overdueInstallmentAmount;
  int? lastPaidInstallmentNo;
  String? installmentDueDate;
  double? installmentAmount;
  String? resultCode;
  String? resultRemarks;
  String? resultPromiseDate;
  double? resultPaymentAmount;
  int? tenor;
  String? platNo;
  String? vehicleDescription;
  String? vehicleCondition;
  List<AttachmentList>? attachmentList;
  int? sync;

  AgreementList(
      {this.taskId,
      this.agreementNo,
      this.collateralNo,
      this.overdueDays,
      this.overduePeriod,
      this.overdueInstallmentAmount,
      this.lastPaidInstallmentNo,
      this.installmentDueDate,
      this.installmentAmount,
      this.resultCode,
      this.resultRemarks,
      this.resultPromiseDate,
      this.resultPaymentAmount,
      this.tenor,
      this.platNo,
      this.vehicleDescription,
      this.vehicleCondition,
      this.attachmentList,
      this.sync});

  AgreementList.fromJson(Map<String, dynamic> json) {
    taskId = json['task_id'];
    agreementNo = json['agreement_no'];
    collateralNo = json['collateral_no'];
    overdueDays = json['overdue_days'];
    overduePeriod = json['overdue_period'];
    overdueInstallmentAmount = json['overdue_installment_amount'];
    lastPaidInstallmentNo = json['last_paid_installment_no'];
    installmentDueDate = json['installment_due_date'];
    installmentAmount = json['installment_amount'];
    resultCode = json['result_code'];
    resultRemarks = json['result_remarks'];
    resultPromiseDate = json['result_promise_date'];
    resultPaymentAmount = json['result_payment_amount'];
    tenor = json['tenor'];
    platNo = json['plat_no'];
    vehicleDescription = json['vehicle_description'];
    vehicleCondition = json['vehicle_condition'];
    if (json['attachment_list'] != null) {
      attachmentList = <AttachmentList>[];
      json['attachment_list'].forEach((v) {
        attachmentList!.add(AttachmentList.fromJson(v));
      });
    }
    sync = 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['task_id'] = taskId;
    data['agreement_no'] = agreementNo;
    data['collateral_no'] = collateralNo;
    data['overdue_days'] = overdueDays;
    data['overdue_period'] = overduePeriod;
    data['overdue_installment_amount'] = overdueInstallmentAmount;
    data['last_paid_installment_no'] = lastPaidInstallmentNo;
    data['installment_due_date'] = installmentDueDate;
    data['installment_amount'] = installmentAmount;
    data['result_code'] = resultCode;
    data['result_remarks'] = resultRemarks;
    data['result_promise_date'] = resultPromiseDate;
    data['result_payment_amount'] = resultPaymentAmount;
    data['tenor'] = tenor;
    data['plat_no'] = platNo;
    data['vehicle_description'] = vehicleDescription;
    data['vehicle_condition'] = vehicleCondition;
    if (attachmentList != null) {
      data['attachment_list'] = attachmentList!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'task_id': taskId,
      'agreement_no': agreementNo,
      'collateral_no': collateralNo,
      'overdue_days': overdueDays,
      'overdue_period': overduePeriod,
      'overdue_installment_amount': overdueInstallmentAmount,
      'last_paid_installment_no': lastPaidInstallmentNo,
      'installment_due_date': installmentDueDate,
      'installment_amount': installmentAmount,
      'result_code': resultCode,
      'result_remarks': resultRemarks,
      'result_promise_date': resultPromiseDate,
      'result_payment_amount': resultPaymentAmount,
      'tenor': tenor,
      'plat_no': platNo,
      'vehicle_description': vehicleDescription,
      'vehicle_condition': vehicleCondition,
      'sync': sync,
    };
  }

  factory AgreementList.fromMap(Map<String, dynamic> map) {
    return AgreementList(
      taskId: map['task_id'],
      agreementNo: map['agreement_no'],
      collateralNo: map['dcollateral_noate'],
      overdueDays: map['overdue_days'],
      overduePeriod: map['overdue_period'],
      overdueInstallmentAmount: map['overdue_installment_amount'],
      lastPaidInstallmentNo: map['last_paid_installment_no'],
      installmentDueDate: map['installment_due_date'],
      installmentAmount: map['installment_amount'],
      resultCode: map['result_code'],
      resultRemarks: map['result_remarks'],
      resultPromiseDate: map['result_promise_date'],
      resultPaymentAmount: map['result_payment_amount'],
      tenor: map['tenor'],
      platNo: map['plat_no'],
      vehicleDescription: map['vehicle_description'],
      vehicleCondition: map['vehicle_condition'],
      sync: map['sync'],
    );
  }
}

class AttachmentList {
  int? taskId;
  int? attachmentId;
  String? fileName;
  String? filePath;
  int? fileSize;
  String? modDate;

  AttachmentList(
      {this.taskId,
      this.attachmentId,
      this.fileName,
      this.filePath,
      this.fileSize,
      this.modDate});

  AttachmentList.fromJson(Map<String, dynamic> json) {
    attachmentId = json['attachment_id'];
    fileName = json['file_name'];
    filePath = json['file_path'];
    fileSize = json['file_size'];
    modDate = json['mod_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['attachment_id'] = attachmentId;
    data['file_name'] = fileName;
    data['file_path'] = filePath;
    data['file_size'] = fileSize;
    data['mod_date'] = modDate;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'task_id': taskId,
      'attachment_id': attachmentId,
      'file_name': fileName,
      'file_path': filePath,
      'file_size': fileSize,
      'mod_date': modDate
    };
  }

  factory AttachmentList.fromMap(Map<String, dynamic> map) {
    return AttachmentList(
        taskId: map['task_id'],
        attachmentId: map['attachment_id'],
        fileName: map['file_name'],
        filePath: map['file_path'],
        fileSize: map['file_size'],
        modDate: map['mod_date']);
  }
}
