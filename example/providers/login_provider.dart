import 'package:api_module/mobile_module_api.dart';

class LoginProvider {
  LoginProvider._();
  static final LoginProvider shared = LoginProvider._();

  final String baseUrl = "dev.universales.com";

  Future<void> doLogin() async {
    ApiManager.shared.request(
      baseUrl: baseUrl,
      pathUrl: "user/login",
      type: HttpType.post,
      body: {"user": "prueba@example.com", "password": "module_1234"},
    );
  }
  Future<void> getDataWithBasicAuth() async {
    ApiManager.shared.request(
      baseUrl: baseUrl,
      pathUrl: "user/me",
      type: HttpType.get,
      authentication: BasicAuthentication(user: "1234", password: "3455")
    );
  }
}
