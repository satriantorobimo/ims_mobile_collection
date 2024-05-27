import 'package:mobile_collection/feature/amortization/data/amortization_response_model.dart';
import 'package:mobile_collection/feature/amortization/domain/api/amortization_api.dart';

class AmortizationRepo {
  final AmortizationApi amortizationApi = AmortizationApi();
  Future<AmortizationResponseModel> attemptAmortization(String agreementNo) =>
      amortizationApi.attemptAmortization(agreementNo);
}
