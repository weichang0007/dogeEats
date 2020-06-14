part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();
}

class RegisterInitial extends RegisterState {
  @override
  List<Object> get props => [];
}

class RegisterWaiting extends RegisterState {
  @override
  List<Object> get props => [];
}

class RegisterFailed extends RegisterState {
  final String message;

  RegisterFailed(this.message);

  @override
  List<Object> get props => [message];
}

class RegisterSucceeded extends RegisterState {
  @override
  List<Object> get props => [];
}
