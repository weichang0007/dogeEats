part of 'appbar_bloc.dart';

abstract class AppbarState extends Equatable {
  const AppbarState();
}

class AppbarInitial extends AppbarState {
  @override
  List<Object> get props => [];
}

class AppbarModify extends AppbarState {
  final Widget _appbar;
  const AppbarModify(this._appbar);

  @override
  List<Object> get props => [_appbar];
}
