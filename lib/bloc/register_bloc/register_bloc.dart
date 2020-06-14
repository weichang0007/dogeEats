import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:dogeeats/service/services.dart';
import 'package:equatable/equatable.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterService _service = RegisterService();

  @override
  RegisterState get initialState => RegisterInitial();

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    try {
      if (event is RegisterButtonClickEvent) {
        yield RegisterWaiting();
        await _service.register(
          event.props[0],
          event.props[1],
          event.props[2],
        );
        yield RegisterSucceeded();
      }
    } on DioError catch (_) {
      yield RegisterFailed("連線錯誤");
    } catch (e) {
      String message = e.toString().replaceAll("HttpServiceException:", "");
      yield RegisterFailed(message.trim().isEmpty ? "伺服器沒有回應" : message);
    }
  }
}
