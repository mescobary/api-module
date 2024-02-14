/// [HttpType] - Tipos de peticiones
enum HttpType{
  get, post, put, delete, patch,  multipart
}

/// [HttpStatus] - Estado de la solicitud
enum HttpStatus {
  success,
  error,
}

/// [HttpCode] - Codigos de estados 
enum HttpCode {
  success,
  created,
  notContent,
  accepted, 
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  methodNotAllowed,
  conflict,
  serverError
}

/// [DefaultKeys] - propiedades por defecto, para el mapeo de la respuesta. 
enum DefaultKeys {
  recordset ('recordset'),
  id        ('id'),
  result    ('result'),
  data      ('result'),
  embedded  ('_embedded'),
  page      ('page');

  const DefaultKeys(this.value);
  final String value;
}