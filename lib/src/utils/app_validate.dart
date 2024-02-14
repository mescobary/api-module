import 'package:api_module/src/utils/app_types.dart';

/// Mapeo del codigo de estado devuelto por la solicitud al tipo [HttpCode]
class ValidateHttp {
  static HttpCode parseCode(int httpCode) {
    switch (httpCode) {
      case 200:
        return HttpCode.success;
      case 201:
        return HttpCode.created;
      case 202:
        return HttpCode.accepted;
      case 204:
      case 207:
        return HttpCode.notContent;
      case 400:
        return HttpCode.badRequest;
      case 401:
        return HttpCode.unauthorized;
      case 403:
        return HttpCode.forbidden;
      case 404:
        return HttpCode.notFound;
      case 405:
        return HttpCode.methodNotAllowed;
      case 409:
        return HttpCode.conflict;
      case 502:
        return HttpCode.serverError;
      default:
        return HttpCode.serverError;
    }
  }
}
