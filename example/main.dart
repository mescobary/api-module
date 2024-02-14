import 'package:api_module/src/api_config.dart';
import 'package:api_module/src/api_manager.dart';
import 'package:api_module/src/utils/app_types.dart';
import 'package:flutter/material.dart';

import 'providers/login_provider.dart';
import 'providers/session_provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<void> initApiManager() async {
    ApiConfig.sessionManager = SessionProvider.shared;
    ApiConfig.tokenManager = SessionProvider.shared;

    ApiConfig.onErrorListener = (flutterErrorDetails) {
      // FirebaseCrashlytics.instance.recordFlutterError(flutterErrorDetails);
    };

    ApiConfig.onUnauthorizedListener = () {
      // signOut()
    };

    // Buscar una propiedad que no esta definida
    ApiMapper.functions.addAll({
      "report": (jsonData) {
        ApiMapper.emiter!(jsonData["report"], msgResponse: "Reporte encontrado");
      }
    });

    // Modificar accion de una propiedad ya definida
    ApiMapper.functions[DefaultKeys.result.value] = (jsonData) {
      ApiMapper.emiter!(jsonData["result2"]);
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Material App',
        home: FutureBuilder(future: initApiManager(), builder: (context, snapshot) => const HomePage()));
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const routeName = "HomePage";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
      floatingActionButton: FloatingActionButton(onPressed: () => LoginProvider.shared.doLogin()),
    );
  }
}
