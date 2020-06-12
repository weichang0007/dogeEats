part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginWaiting extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginFailed extends LoginState {
  final String message;

  LoginFailed(this.message);

  @override
  List<Object> get props => [message];
}

class LoginSucceeded extends LoginState {
  final String response;

  LoginSucceeded(this.response);

  @override
  List<Object> get props => [response];
}
