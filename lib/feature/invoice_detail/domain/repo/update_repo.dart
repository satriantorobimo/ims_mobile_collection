import 'package:mobile_collection/feature/invoice_detail/data/general_response_model.dart';
import 'package:mobile_collection/feature/invoice_detail/data/update_request_model.dart';
import 'package:mobile_collection/feature/invoice_detail/domain/api/update_api.dart';

class UpdateRepo {
  final UpdateApi updateApi = UpdateApi();
  Future<GeneralResponseModel> attemptUpdate(
          UpdateRequestModel updateRequestModel, String collectorCode) =>
      updateApi.attemptUpdate(updateRequestModel, collectorCode);
}
