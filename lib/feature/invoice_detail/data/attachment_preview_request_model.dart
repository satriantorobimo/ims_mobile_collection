class AttachmentPreviewRequestModel {
  String? pFileName;
  String? pFilePaths;

  AttachmentPreviewRequestModel({this.pFileName, this.pFilePaths});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['p_file_name'] = pFileName;
    data['p_file_paths'] = pFilePaths;
    return data;
  }
}
