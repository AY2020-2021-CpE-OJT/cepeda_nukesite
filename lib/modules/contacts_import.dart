import 'dart:async';
import 'package:http/http.dart' as http;

class ImportAPIContacts {
  static Future getContacts() {
    return http.get("https://nukesite-phonebook-api.herokuapp.com/all");
  }
}
