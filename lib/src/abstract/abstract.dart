/// Las solicitudes que utilizan un token relacionado al usuario, necesitan una clase que extienda de
/// [SessionManager] para sobreescribir la funcion existSession().
/// En la misma clase u otra, se debe extender de [TokenManager] para sobreescribir
/// la funciion getToken(), que debe devolver el token de acceso para las solicitudes.
///
abstract class SessionManager {
  Future<bool> existSession();
}

abstract class TokenManager {
  Future<String> getToken();
}

abstract class AuthenticationMethod {
  Map<String, String> getAuthenticationHeader();
}
