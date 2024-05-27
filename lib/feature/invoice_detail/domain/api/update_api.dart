import 'dart:convert';
import 'package:mobile_collection/feature/invoice_detail/data/general_response_model.dart';
import 'package:mobile_collection/feature/invoice_detail/data/update_request_model.dart';
import 'package:mobile_collection/utility/general_util.dart';
import 'package:mobile_collection/utility/shared_pref_util.dart';
import 'package:mobile_collection/utility/url_util.dart';
import 'package:http/http.dart' as http;

class UpdateApi {
  GeneralResponseModel generalResponseModel = GeneralResponseModel();
  final UrlUtil urlUtil = UrlUtil();

  Future<GeneralResponseModel> attemptUpdate(
      UpdateRequestModel updateRequestModel, String collectorCode) async {
    List a = [];
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(
        token!, GeneralUtil().encodeId(collectorCode));
    a.add(updateRequestModel.toJson());

    final json = jsonEncode(a);

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(Uri.parse(urlUtil.getUrlUpdate()),
          body: json, headers: header);
      if (res.statusCode == 200) {
        stopwatch.stop();
        generalResponseModel =
            GeneralResponseModel.fromJson(jsonDecode(res.body));
        return generalResponseModel;
      } else if (res.statusCode == 401) {
        throw 'expired';
      } else {
        generalResponseModel =
            GeneralResponseModel.fromJson(jsonDecode(res.body));
        throw generalResponseModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }
}
