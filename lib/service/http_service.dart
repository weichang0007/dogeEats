import 'dart:io';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dogeeats/model/models.dart';
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
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (RequestOptions options) async {
            Setting setting = await Setting.instance;
            options.headers["Authorization"] = "Bearer " + setting.token;
            return options;
          },
          onResponse: (Response response) => response,
          /*onError: (DioError error) async { // 重新登入
            if (error.response?.statusCode == 403) {
              _dio.interceptors.requestLock.lock();
              _dio.interceptors.responseLock.lock();
              RequestOptions options = error.response.request;
              //options.headers["Authorization"] = "Bearer " + token;
              _dio.interceptors.requestLock.unlock();
              _dio.interceptors.responseLock.unlock();
              return _dio.request(options.path, options: options);
            } else {
              return error;
            }
          },*/
        ),
      );
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

  Future<Response> getJsonData(String path) async {
    final Dio request = await this.client;
    Options options = Options(
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      headers: {HttpHeaders.acceptHeader: "accept: application/json"},
      validateStatus: (status) => status < 500,
    );
    return await request.get(path, options: options);
  }

  Future<Response> postEmpty(String path) async {
    final Dio request = await this.client;
    Options options = Options(
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      headers: {HttpHeaders.acceptHeader: "accept: application/json"},
      validateStatus: (status) => status < 500,
    );
    return await request.post(path, options: options);
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

  Future<Response> deleteEmpty(String path) async {
    final Dio request = await this.client;
    Options options = Options(
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      headers: {HttpHeaders.acceptHeader: "accept: application/json"},
      validateStatus: (status) => status < 500,
    );
    return await request.delete(path, options: options);
  }

  Future<void> clearCookie() async {
    (await cookieManager).deleteAll();
    _dio = null;
  }

  Future<void> resetClient() async {
    _dio = null;
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
