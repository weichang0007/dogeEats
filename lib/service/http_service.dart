import 'dart:io';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class HttpService {
  static final String baseUrl = "https://dogeeats.pohc.me/api";
  static HttpService _instance;
  PersistCookieJar _cookieJar;
  Dio _dio;

  HttpService._internal();

  static HttpService get instance {
    if (_instance == null) _instance = HttpService._internal();
    return _instance;
  }

  Future<PersistCookieJar> get cookieManager async {
    if (_cookieJar == null) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      _cookieJar = new PersistCookieJar(dir: appDocPath);
    }
    return _cookieJar;
  }

  Future<Dio> get client async {
    if (_dio == null) {
      _dio = Dio();
      _dio.interceptors.add(CookieManager(await cookieManager));
    }
    return _dio;
  }

  Future<Response> getByte(String path) async {
    final Dio request = await this.client;
    Options options = Options(responseType: ResponseType.bytes);
    return await request.get(path, options: options);
  }

  Future<Response> getData(String path) async {
    final Dio request = await this.client;
    return await request.get(path);
  }

  Future<Response> postForm(String path, Map form) async {
    final Dio request = await this.client;
    Options options = Options(contentType: Headers.formUrlEncodedContentType);
    return await request.post(path, data: form, options: options);
  }

  Future<Response> postJson(String path, String jsonString) async {
    final Dio request = await this.client;
    Options options = Options(
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      headers: {HttpHeaders.acceptHeader: "accept: application/json"},
      validateStatus: (status) => status < 500,
    );
    return await request.post(path, data: jsonString, options: options);
  }

  Future<void> clearCookie() async {
    (await cookieManager).deleteAll();
  }
}

class HttpServiceException implements Exception {
  final message;

  HttpServiceException([this.message]);

  String toString() {
    if (message == null) return "HttpServiceException";
    return "HttpServiceException: $message";
  }
}
