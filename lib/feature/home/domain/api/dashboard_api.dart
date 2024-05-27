import 'dart:convert';
import 'package:mobile_collection/feature/home/data/dashboard_response_model.dart';
import 'package:mobile_collection/utility/general_util.dart';
import 'package:mobile_collection/utility/shared_pref_util.dart';
import 'package:mobile_collection/utility/url_util.dart';
import 'package:http/http.dart' as http;

class DashboardApi {
  DashboardResponseModel dashboardResponseModel = DashboardResponseModel();
  final UrlUtil urlUtil = UrlUtil();

  Future<DashboardResponseModel> attemptDashboard(String collectorCode) async {
    List a = [];
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(
        token!, GeneralUtil().encodeId(collectorCode));
    final Map mapData = {};
    mapData['p_collector_code'] = collectorCode;
    a.add(mapData);

    final json = jsonEncode(a);

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(Uri.parse(urlUtil.getUrlDashboard()),
          body: json, headers: header);
      if (res.statusCode == 200) {
        stopwatch.stop();
        dashboardResponseModel =
            DashboardResponseModel.fromJson(jsonDecode(res.body));
        return dashboardResponseModel;
      } else if (res.statusCode == 401) {
        throw 'expired';
      } else {
        dashboardResponseModel =
            DashboardResponseModel.fromJson(jsonDecode(res.body));
        throw dashboardResponseModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }
}
