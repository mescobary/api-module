import 'package:api_module/src/utils/app_types.dart';

/// Transiciones personalizadas
/// [status] guarda el estado de la petición, el estado será error cuando el codigo de la respuesta
/// sea diferente de 200, 201, 202. [code] almacena el codigo de estado
/// [msg] recibe el mensaje devuelvo por la petición o por algun error encontrado
/// [recordset] objeto dynamico que proporciona los datos solicitados.
class ResponseData {
  late HttpStatus status;
  late HttpCode code;
  late String msg;
  dynamic recordset;

  ResponseData({required this.code, required this.recordset, required this.status, required this.msg});

  ResponseData.empty();
}
