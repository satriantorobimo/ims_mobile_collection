import 'package:equatable/equatable.dart';
import 'package:mobile_collection/feature/invoice_detail/data/upload_request_model.dart';

abstract class UploadEvent extends Equatable {
  const UploadEvent();
}

class UploadAttempt extends UploadEvent {
  const UploadAttempt(this.uploadRequestModel, this.collectorCode);
  final String collectorCode;
  final List<UploadRequestModel> uploadRequestModel;

  @override
  List<Object> get props => [uploadRequestModel, collectorCode];
}
