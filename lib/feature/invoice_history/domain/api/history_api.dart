import 'dart:convert';
import 'package:mobile_collection/feature/invoice_history/data/history_response_model.dart';
import 'package:mobile_collection/utility/general_util.dart';
import 'package:mobile_collection/utility/shared_pref_util.dart';
import 'package:mobile_collection/utility/url_util.dart';
import 'package:http/http.dart' as http;

class HistoryApi {
  HistoryResponseModel historyResponseModel = HistoryResponseModel();
  final UrlUtil urlUtil = UrlUtil();

  Future<HistoryResponseModel> attemptHistory(String agreementNo) async {
    List a = [];
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(
        token!, GeneralUtil().encodeId(agreementNo));
    final Map mapData = {};
    mapData['p_agreement_no'] = agreementNo;
    a.add(mapData);

    final json = jsonEncode(a);

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(Uri.parse(urlUtil.getUrlHistory()),
          body: json, headers: header);
      if (res.statusCode == 200) {
        stopwatch.stop();
        historyResponseModel =
            HistoryResponseModel.fromJson(jsonDecode(res.body));
        return historyResponseModel;
      } else if (res.statusCode == 401) {
        throw 'expired';
      } else {
        historyResponseModel =
            HistoryResponseModel.fromJson(jsonDecode(res.body));
        throw historyResponseModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }
}
