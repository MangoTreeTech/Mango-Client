import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class API {
  static const BASE_URL = "api.hibanaw.com";
  static var client = http.Client();
  static Future<Map> register(String username, String password) async {
    var url = Uri.http(BASE_URL, 'user/register');
    var response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': username, 'password': password}),
    );
    return jsonDecode(utf8.decode(response.bodyBytes)) as Map;
  }

  static Future<Map> login(String username, String password) async {
    var url = Uri.http(BASE_URL, 'user/login');
    var response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': username, 'password': password}),
    );
    print(jsonDecode(utf8.decode(response.bodyBytes)) as Map);
    return jsonDecode(utf8.decode(response.bodyBytes)) as Map;
  }
}
