import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Setting {
  static Setting _instance;

  static Future<Setting> get instance async {
    if (_instance == null) {
      try {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String jsonString = preferences.getString('setting');
        _instance = Setting.fromJson(json.decode(jsonString));
      } catch (_) {
        _instance = Setting();
      }
    }
    return _instance;
  }

  static Future<Setting> save() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Setting setting = await Setting.instance;
    await preferences.setString('setting', json.encode(setting));
    _instance = null; // reload
    return setting;
  }

  static Future<void> claen() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey('setting')) await preferences.remove('setting');
    _instance = null;
  }

  String name = "";
  String email = "";
  String passwd = "";
  String token = "";

  Setting();

  Setting.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        passwd = json['passwd'],
        token = json['token'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'passwd': passwd,
        'token': token,
      };
}
