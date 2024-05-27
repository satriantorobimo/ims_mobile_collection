import 'dart:convert';

class UrlUtil {
  static String baseUrl = 'http://192.168.1.85/';

  static final Map<String, String> headerType = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  static Map<String, String> headerTypeBasicAuth(
          String username, String password) =>
      {
        "content-type": "application/json",
        "accept": "application/json",
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$username:$password'))}'
      };

  static Map<String, String> headerTypeWithToken(String token, String userId) =>
      {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Userid': userId
      };

  static Map<String, String> headerTypeForm() => {
        'Content-Type': 'application/x-www-form-urlencoded',
      };

  Map<String, String> getHeaderTypeWithToken(String token, String userId) {
    return headerTypeWithToken(token, userId);
  }

  Map<String, String> getHeaderTypeBasicAuth(String username, String password) {
    return headerTypeBasicAuth(username, password);
  }

  Map<String, String> getHeaderTypeForm() {
    return headerTypeForm();
  }

  static String urlLogin() => 'api/mobcoll_api/api/Authenticate/Login';

  String getUrlLogin() {
    final String getUrlLogin2 = urlLogin();
    return baseUrl + getUrlLogin2;
  }

  static String urlTaskList() => 'api/mobcoll_api/api/TaskList/TodayTask';

  String getUrlTaskList() {
    final String getUrlTaskList2 = urlTaskList();
    return baseUrl + getUrlTaskList2;
  }

  static String urlDashboard() => 'api/mobcoll_api/api/Home/GetDataByCollector';

  String getUrlDashboard() {
    final String getUrlDashboard2 = urlDashboard();
    return baseUrl + getUrlDashboard2;
  }

  static String urlUpdate() => 'api/mobcoll_api/api/Agreement/UpdateResult';

  String getUrlUpdate() {
    final String getUrlUpdate2 = urlUpdate();
    return baseUrl + getUrlUpdate2;
  }

  static String urlAmortization() => 'api/Agreement/GetAmortization';

  String getUrlAmortization() {
    final String getUrlAmortization2 = urlAmortization();
    return baseUrl + getUrlAmortization2;
  }

  static String urlHistory() => 'api/mobcoll_api/api/Agreement/GetHistory';

  String getUrlHistory() {
    final String getUrlHistory2 = urlHistory();
    return baseUrl + getUrlHistory2;
  }
}
