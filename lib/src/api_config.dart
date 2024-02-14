import 'package:api_module/mobile_module_api.dart';
import 'package:flutter/material.dart';

/// Utilizar para incorporar funcionalidades propias
/// [onErrorListener] Función que se llamara cuando el mapeo de la respuesta falle
/// [onUnauthorizedListener] Función a ejecutar cuando la petición devuelva un estado 401 o Unauthorized
/// [sessionManager] Proporciona la funcion existSession(), que comprueba la session almacenada localmente
/// [tokenManager] Proporciona la funcion getToken() para devolver el token de autorizacion envida en las solicitudes
/// [basicAuth] Variable para establecer un token por defecto que se enviara en las solicitudes,
/// cuando sessionManager y tokenManager no sean asignadas
class ApiConfig {
  static Function(FlutterErrorDetails)? onErrorListener;
  static VoidCallback? onUnauthorizedListener;
  static SessionManager? sessionManager;
  static TokenManager? tokenManager;
}
