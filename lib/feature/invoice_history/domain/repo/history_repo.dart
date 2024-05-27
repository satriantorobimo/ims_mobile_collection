import 'package:mobile_collection/feature/invoice_history/data/history_response_model.dart';
import 'package:mobile_collection/feature/invoice_history/domain/api/history_api.dart';

class HistoryRepo {
  final HistoryApi historyApi = HistoryApi();
  Future<HistoryResponseModel> attemptHistory(String agreementNo) =>
      historyApi.attemptHistory(agreementNo);
}
