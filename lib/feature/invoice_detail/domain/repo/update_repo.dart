import 'package:mobile_collection/feature/invoice_detail/data/attachment_preview_model.dart';
import 'package:mobile_collection/feature/invoice_detail/data/attachment_preview_request_model.dart';
import 'package:mobile_collection/feature/invoice_detail/data/general_response_model.dart';
import 'package:mobile_collection/feature/invoice_detail/data/update_request_model.dart';
import 'package:mobile_collection/feature/invoice_detail/data/upload_request_model.dart';
import 'package:mobile_collection/feature/invoice_detail/domain/api/update_api.dart';

class UpdateRepo {
  final UpdateApi updateApi = UpdateApi();
  Future<GeneralResponseModel> attemptUpdate(
          UpdateRequestModel updateRequestModel, String collectorCode) =>
      updateApi.attemptUpdate(updateRequestModel, collectorCode);

  Future<GeneralResponseModel> attemptUpload(
          List<UploadRequestModel> uploadRequestModel, String collectorCode) =>
      updateApi.attemptUpload(uploadRequestModel, collectorCode);

  Future<AttachmentPreviewModel> attemptPreview(
          AttachmentPreviewRequestModel attachmentPreviewRequestModel,
          String collectorCode) =>
      updateApi.attemptPreview(attachmentPreviewRequestModel, collectorCode);
}
