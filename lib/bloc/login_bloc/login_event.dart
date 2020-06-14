part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginButtonClickEvent extends LoginEvent {
  final String email, password;

  LoginButtonClickEvent(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}
