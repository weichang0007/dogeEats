import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    try {
      // TODO: 實作登入邏輯
    } on DioError catch (_) {
      yield LoginFailed("連線錯誤");
    } catch (e) {
      String message = e.toString().replaceAll("HttpServiceException:", "");
      yield LoginFailed(message.trim().isEmpty ? "伺服器沒有回應" : message);
    }
  }
}
