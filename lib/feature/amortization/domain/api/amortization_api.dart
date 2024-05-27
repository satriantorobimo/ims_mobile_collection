import 'dart:convert';
import 'package:mobile_collection/feature/amortization/data/amortization_response_model.dart';
import 'package:mobile_collection/utility/general_util.dart';
import 'package:mobile_collection/utility/shared_pref_util.dart';
import 'package:mobile_collection/utility/url_util.dart';
import 'package:http/http.dart' as http;

class AmortizationApi {
  AmortizationResponseModel amortizationResponseModel =
      AmortizationResponseModel();
  final UrlUtil urlUtil = UrlUtil();

  Future<AmortizationResponseModel> attemptAmortization(
      String agreementNo) async {
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
      final res = await http.post(Uri.parse(urlUtil.getUrlAmortization()),
          body: json, headers: header);
      if (res.statusCode == 200) {
        stopwatch.stop();
        amortizationResponseModel =
            AmortizationResponseModel.fromJson(jsonDecode(res.body));
        return amortizationResponseModel;
      } else if (res.statusCode == 401) {
        throw 'expired';
      } else {
        amortizationResponseModel =
            AmortizationResponseModel.fromJson(jsonDecode(res.body));
        throw amortizationResponseModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }
}
