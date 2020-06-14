import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dogeeats/service/services.dart';

class LoginService {
  static HttpService _http = HttpService.instance;
  final String baseUrl = HttpService.baseUrl;

  Future<Map> login(String email, String password) async {
    String jsonString = json.encode({"email": email, "password": password});
    Response response = await _http.postJson("$baseUrl/auth/login", jsonString);
    Map jsonData = response.data;
    if (jsonData.containsKey("errors"))
      throw HttpServiceException(jsonData["message"]);
    return response.data;
  }
}
