import 'dart:convert';

import 'package:api_module/mobile_module_api.dart';
import 'package:api_module/src/utils/app_strings.dart';
import 'package:api_module/src/utils/app_extension.dart';
import 'package:api_module/src/utils/app_validate.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiManager {
  ApiManager._();

  static final ApiManager shared = ApiManager._();

  /// Realiza una petición mediante https
  /// [baseUrl] segmento que define el host (dev.universales.com)
  /// [pathUrl] proporciona la ruta a la que se realizara la peticion ( api/endpoint )
  /// [type] es el tipo de petición a realizar (get, post, put, delete, patch o multipart)
  /// [body] proporciona el cuerpo de la petición, que sera mapeado a formato JSON
  /// [uriParams] define una serie de parametros adjuntos al final de la url
  Future<ResponseData> request({
    required String baseUrl,
    required String pathUrl,
    required HttpType type,
    dynamic body,
    Map<String, dynamic>? uriParams,
    AuthenticationMethod? authentication,
    bool isHttp = false,
    Map<String, String> addHeaders = const {'Content-Type': 'application/json'},
  }) async {
    Uri url = isHttp ? Uri.http(baseUrl, pathUrl, uriParams) : Uri.https(baseUrl, pathUrl, uriParams);
    Map<String, String> headers = Map.from(addHeaders);

    final hasSession = ApiConfig.sessionManager != null ? await ApiConfig.sessionManager!.existSession() : false;
    if (hasSession) {
      String userToken = await ApiConfig.tokenManager?.getToken() ?? "";
      if (userToken.isNotEmpty) authentication ??= BearerAuthentication(token: userToken);
    }

    if (authentication != null) headers.addAll(authentication.getAuthenticationHeader());

    http.Response response;

    switch (type) {
      case HttpType.get:
        response = await http.get(
          url,
          headers: headers,
        );
        break;
      case HttpType.post:
        response = await http.post(
          url,
          headers: headers,
          body: jsonEncode(body),
          encoding: Encoding.getByName('utf-8'),
        );
        break;
      case HttpType.put:
        response = await http.put(
          url,
          headers: headers,
          body: jsonEncode(body),
          encoding: Encoding.getByName('utf-8'),
        );
        break;
      case HttpType.delete:
        response = await http.delete(
          url,
          headers: headers,
          // body: jsonEncode(body),
          // encoding: Encoding.getByName('utf-8'),
        );
        break;
      case HttpType.patch:
        response = await http.patch(
          url,
          body: jsonEncode(body),
          headers: headers,
          encoding: Encoding.getByName('utf-8'),
        );
        break;
      case HttpType.multipart:
        final multipartRequest = http.MultipartRequest("POST", Uri.https(baseUrl, pathUrl));
        multipartRequest.headers.addAll(headers);

        _addMultipartData(multipartRequest, body as Map<String, String?>);
        final streamedResponse = await multipartRequest.send();
        response = await http.Response.fromStream(streamedResponse);
        break;
    }
    return _parseResponse(response);
  }

  ResponseData _parseResponse(http.Response response) {
    HttpStatus httpStatus = HttpStatus.error;
    HttpCode httpCode = ValidateHttp.parseCode(response.statusCode);

    String? mgsServer;
    dynamic recordset;

    try {
      final responseUtf8 = utf8.decode(response.bodyBytes);
      final dynamic jsonData = responseUtf8.contains("<!DOCTYPE") ? responseUtf8 : responseUtf8.parseResponse();

      if (jsonData is List) {
        recordset = jsonData;
      } else if (jsonData is String) {
        recordset = jsonData;
      } else {
        jsonData as Map<String, dynamic>;
        ApiMapper.emiter = (data, {failedHttpCode, msgResponse}) {
          recordset = data;
          httpCode = failedHttpCode ?? httpCode;
          mgsServer = msgResponse;
        };

        ApiMapper().validate(jsonData);
      }
    } on FormatException catch (e) {
      ApiConfig.onErrorListener != null
          ? ApiConfig.onErrorListener!(FlutterErrorDetails(exception: e))
          : debugPrint(e.message);
    }

    String msg = _getMessage(httpCode, mgsServer);
    httpStatus = _getStatus(httpCode);

    return ResponseData(code: httpCode, recordset: recordset, status: httpStatus, msg: msg);
  }

  HttpStatus _getStatus(HttpCode httpCode) =>
      httpCode == HttpCode.success || httpCode == HttpCode.created || httpCode == HttpCode.accepted
          ? HttpStatus.success
          : HttpStatus.error;

  String _getMessage(HttpCode httpCode, String? mgsServer) {
    switch (httpCode) {
      case HttpCode.success:
      case HttpCode.created:
      case HttpCode.accepted:
        return _buildMessage(mgsServer, Strings.msgSuccess);
      case HttpCode.notContent:
        return _buildMessage(mgsServer, Strings.errorNotContent);
      case HttpCode.badRequest:
        return _buildMessage(mgsServer, Strings.errorBadRequest);
      case HttpCode.unauthorized:
        if (ApiConfig.onUnauthorizedListener != null) ApiConfig.onUnauthorizedListener!();
        return _buildMessage(mgsServer, Strings.errorUnauthorized);
      case HttpCode.forbidden:
        return _buildMessage(mgsServer, Strings.errorForbidden);
      case HttpCode.notFound:
        return _buildMessage(mgsServer, Strings.errorNotFound);
      case HttpCode.methodNotAllowed:
        return _buildMessage(mgsServer, Strings.errorNotAllowed);
      case HttpCode.conflict:
        return _buildMessage(mgsServer, Strings.errorConflict);
      case HttpCode.serverError:
        return _buildMessage(mgsServer, Strings.errorServer);

      default:
        return dictionary[Strings.errorFatal]!;
    }
  }

  String _buildMessage(String? msg, Strings customMsg) => msg ?? dictionary[customMsg] ?? "";

  void _addMultipartData(http.MultipartRequest multipartRequest, Map<String, String?> params) async {
    for (var param in params.entries) {
      if (param.key == "file" && params["file"] != null) {
        var selectedFile = await http.MultipartFile.fromPath("file", params["file"]!);
        multipartRequest.files.add(selectedFile);
        continue;
      }
      multipartRequest.fields[param.key] = param.value!;
    }
  }
}

class ApiMapper {
  ApiMapper._private() {
    _init();
  }

  static final ApiMapper shared = ApiMapper._private();

  factory ApiMapper() => shared;

  static Function(dynamic recordset, {String? msgResponse, HttpCode? failedHttpCode})? emiter;
  static Map<String, Function(Map<String, dynamic>)> functions = {};

  _init() {
    ApiMapper.functions.addAll({
      DefaultKeys.recordset.value: (Map<String, dynamic> jsonData) {
        emiter!(jsonData[DefaultKeys.recordset.value], msgResponse: jsonData["message"] ?? jsonData["msg"]);
      },
      DefaultKeys.id.value: (Map<String, dynamic> jsonData) => emiter!(jsonData),
      DefaultKeys.result.value: (Map<String, dynamic> jsonData) => emiter!(jsonData["data"]),
      DefaultKeys.data.value: (Map<String, dynamic> jsonData) => emiter!(jsonData["data"]),
      DefaultKeys.embedded.value: (Map<String, dynamic> jsonData) => emiter!(jsonData["_embedded"]),
      DefaultKeys.page.value: (Map<String, dynamic> jsonData) {
        final page = jsonData["page"]["totalPages"];
        HttpCode? httpCode;
        if (page <= 0) {
          httpCode = HttpCode.notContent;
          emiter!("", failedHttpCode: httpCode);
          return;
        }
        emiter!(jsonData["content"]);
      },
    });
  }

  validate(Map<String, dynamic> jsonData) {
    for (var property in functions.keys) {
      if (jsonData.containsKey(property)) {
        functions[property]!(jsonData);
        return;
      }
    }
    emiter!(jsonData);
  }
}
