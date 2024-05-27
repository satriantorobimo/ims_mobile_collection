import 'package:equatable/equatable.dart';
import 'package:mobile_collection/feature/invoice_detail/data/update_request_model.dart';

abstract class UpdateEvent extends Equatable {
  const UpdateEvent();
}

class UpdateAttempt extends UpdateEvent {
  const UpdateAttempt(this.updateRequestModel, this.collectorCode);
  final String collectorCode;
  final UpdateRequestModel updateRequestModel;

  @override
  List<Object> get props => [updateRequestModel, collectorCode];
}
