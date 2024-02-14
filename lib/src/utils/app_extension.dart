import 'dart:convert';

extension StringParse on String {
  dynamic parseResponse() {
    try {
      return json.decode(this);
    } catch (e) {
      return this;
    }
  }
}