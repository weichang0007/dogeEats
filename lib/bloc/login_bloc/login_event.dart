part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginButtonClickEvent extends LoginEvent {
  @override
  List<Object> get props => [];
}

class LoginRequireEvent extends LoginEvent {
  @override
  List<Object> get props => [];
}
