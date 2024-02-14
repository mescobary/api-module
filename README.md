# Modulo - Api Manager 

![flutter_logo](https://static.wikia.nocookie.net/logo-timeline/images/7/71/B3A46E91-F45E-44DC-93FA-0B1B1AE3B4C0.png/revision/latest?cb=20210426191524)

# Api Manager

El objetivo de este modulo es normalizar el manejo de peticiones, dentro de las aplicaciones mobiles, que se realizan hacia cualquier servicio de Universales. 

## Instalación

Agregar la dependencia en `./pubspec.yaml` de la siguiente manera:

```
api_module:
    git:
      url: git@github.com:anibalmunoz/module-api-manager.git
      ref: main
```



## Ejemplo

#### `example/main.dart`
```Dart
import 'package:flutter/material.dart';
import 'package:api_module/src/api_config.dart';

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
      "report":(jsonData) {
        ApiMapper.emiter!( jsonData["report"], msgResponse: "Reporte encontrado");
      }
    });

    // Se debe ejecutar la siguiente instrucción, previo a reemplazar las acciones  
    ApiMapper(); 
    // Modificar accion de una propiedad ya definida
    ApiMapper.functions[DefaultKeys.result.value] = (jsonData) {
      ApiMapper.emiter!(jsonData["result2"]);
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: FutureBuilder(
        future: initApiManager(),
        builder: (context, snapshot) => const HomePage()
      )
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage ({super.key});

  static const routeName = "HomePage"; 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => LoginProvider.shared.doLogin()
      ),
    );
  }
}
```


#### `example/providers/session_provider.dart`
```Dart
import 'package:api_module/api_module.dart';

class SessionProvider with SessionManager, TokenManager {
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
```


#### `example/providers/login_provider.dart`
```Dart
import 'package:api_module/api_module.dart';

class LoginProvider  {
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

  // Using Basic Auth
  Future<void> getDataWithBasicAuth() async {
    ApiManager.shared.request(
      baseUrl: baseUrl,
      pathUrl: "user/me",
      type: HttpType.get,
      authentication: BasicAuthentication(user: "1234", password: "3455")
    );
  }
}
```
