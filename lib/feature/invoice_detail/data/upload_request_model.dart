class UploadRequestModel {
  int? pTaskId;
  String? pAgreementNo;
  int? pFilePath;
  String? pFileName;
  int? pFileSize;
  String? pBase64;

  UploadRequestModel(
      {this.pTaskId,
        this.pAgreementNo,
        this.pFilePath,
        this.pFileName,
        this.pFileSize,
        this.pBase64});

  UploadRequestModel.fromJson(Map<String, dynamic> json) {
    pTaskId = json['p_task_id'];
    pAgreementNo = json['p_agreement_no'];
    pFilePath = json['p_file_path'];
    pFileName = json['p_file_name'];
    pFileSize = json['p_file_size'];
    pBase64 = json['p_base64'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['p_task_id'] = pTaskId;
    data['p_agreement_no'] = pAgreementNo;
    data['p_file_path'] = pFilePath;
    data['p_file_name'] = pFileName;
    data['p_file_size'] = pFileSize;
    data['p_base64'] = pBase64;
    return data;
  }
}
