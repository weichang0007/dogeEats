part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
}

class RegisterButtonClickEvent extends RegisterEvent {
  final String name, email, password;

  RegisterButtonClickEvent(this.name, this.email, this.password);

  @override
  List<Object> get props => [name, email, password];
}
