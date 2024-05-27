import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_collection/feature/login/data/auth_response_model.dart';
import 'package:mobile_collection/utility/url_util.dart';

class AuthApi {
  AuthResponseModel authResponseModel = AuthResponseModel();

  UrlUtil urlUtil = UrlUtil();

  Future<AuthResponseModel> attemptAuth(
      String username, String password) async {
    final Map<String, String> header = urlUtil.getHeaderTypeForm();

    try {
      final res = await http.post(Uri.parse(urlUtil.getUrlLogin()),
          body: {
            'username': username,
            'password': password,
            'device_id': 'admin',
            'device_type': 'a'
          },
          headers: header);
      if (res.statusCode == 200) {
        authResponseModel = AuthResponseModel.fromJson(jsonDecode(res.body));
        return authResponseModel;
      } else {
        authResponseModel = AuthResponseModel.fromJson(jsonDecode(res.body));
        throw authResponseModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }
}
