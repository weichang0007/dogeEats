import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dogeeats/service/services.dart';

class RegisterService {
  static HttpService _http = HttpService.instance;
  final String baseUrl = HttpService.baseUrl;

  Future<Map> register(String name, String email, String password) async {
    String jsonString = json.encode({
      "name": name,
      "email": email,
      "password": password,
    });
    Response response = await _http.postJson(
      "$baseUrl/auth/register",
      jsonString,
    );
    Map jsonData = response.data;
    if (jsonData.containsKey("errors"))
      throw HttpServiceException(jsonData["message"]);
    return response.data;
  }
}
