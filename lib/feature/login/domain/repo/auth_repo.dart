import 'package:mobile_collection/feature/login/data/auth_response_model.dart';
import 'package:mobile_collection/feature/login/domain/api/auth_api.dart';

class AuthRepo {
  final AuthApi authApi = AuthApi();

  Future<AuthResponseModel?> attemptAuth(String username, String password) =>
      authApi.attemptAuth(username, password);
}
