enum Strings{
  errorBadRequest, 
  errorConflict,
  errorForbidden, 
  errorNotAllowed, 
  errorNotContent, 
  errorNotFound, 
  errorServer, 
  errorUnauthorized, 
  errorFatal, 
  msgSuccess
}


const Map<Strings, String> dictionary = {
  Strings.errorFatal: "Algo salió mal, intenta más tarde",
  Strings.errorNotContent: "Sin resultados",
  Strings.errorBadRequest: "Error en los campos enviados",
  Strings.errorUnauthorized: "Sin autorización para realizar peticiones",
  Strings.errorForbidden: "Sin permisos para acceder al servidor",
  Strings.errorNotFound: "El servidor no puede encontrar el recurso solicitado",
  Strings.errorNotAllowed: "Método no disponible",
  Strings.errorServer: "El servidor esta teniendo problemas, intenta más tarde",
};


