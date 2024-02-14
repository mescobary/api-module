import 'package:api_module/mobile_module_api.dart';

class SessionProvider implements SessionManager, TokenManager {
  SessionProvider._();
  static final SessionProvider shared = SessionProvider._();

  @override
  Future<bool> existSession() async {
    // TODO: implement existSession
    return true;
  }

  @override
  Future<String> getToken() async {
    // TODO: implement getToken
    return "";
  }
}
