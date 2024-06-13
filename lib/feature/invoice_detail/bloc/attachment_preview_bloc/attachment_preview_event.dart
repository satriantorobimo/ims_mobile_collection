import 'package:equatable/equatable.dart';
import 'package:mobile_collection/feature/invoice_detail/data/attachment_preview_request_model.dart';

abstract class AttachmentPreviewEvent extends Equatable {
  const AttachmentPreviewEvent();
}

class AttachmentPreviewAttempt extends AttachmentPreviewEvent {
  const AttachmentPreviewAttempt(
      this.attachmentPreviewRequestModel, this.collectorCode);
  final AttachmentPreviewRequestModel attachmentPreviewRequestModel;
  final String collectorCode;

  @override
  List<Object> get props => [attachmentPreviewRequestModel, collectorCode];
}
