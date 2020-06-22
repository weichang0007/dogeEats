import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:dogeeats/model/models.dart';
import 'package:dogeeats/service/services.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginService _service = LoginService();

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    try {
      if (event is LoginButtonClickEvent) {
        yield LoginWaiting();
        Map response = await _service.login(event.props[0], event.props[1]);
        Setting setting = await Setting.instance;
        setting.name = response["user"]["name"].toString();
        setting.email = response["user"]["email"].toString();
        setting.passwd = event.props[1].toString();
        setting.token = response["token"].toString();
        setting.flag =
            response['user']['transporter'] != null ? "transporter" : "custom";
        setting = await Setting.save();
        await (HttpService.instance).resetClient(); // reload token
        yield LoginSucceeded(response.toString());
      }
    } on DioError catch (_) {
      yield LoginFailed("連線錯誤");
    } catch (e) {
      String message = e.toString().replaceAll("HttpServiceException:", "");
      yield LoginFailed(message.trim().isEmpty ? "伺服器沒有回應" : message);
    }
  }
}
