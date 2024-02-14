import 'dart:convert';

import '../../mobile_module_api.dart';

class BearerAuthentication extends AuthenticationMethod {
  final String token;

  BearerAuthentication({required this.token});

  @override
  Map<String, String> getAuthenticationHeader() {
    if (token.contains("Bearer ")) token.replaceAll("Bearer ", "");
    return {'Authorization': 'Bearer $token'};
  }
}

class BasicAuthentication extends AuthenticationMethod {
  final String user;
  final String password;

  BasicAuthentication({required this.user, required this.password});
  
  @override
  Map<String, String> getAuthenticationHeader() => {
        'Authorization': 'Basic ${base64Encode(utf8.encode("$user:$password"))}',
      };
}
