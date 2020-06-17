part of 'appbar_bloc.dart';

abstract class AppbarEvent extends Equatable {
  const AppbarEvent();
}

class ModifyAppbarEvent extends AppbarEvent {
  final Widget _appbar;
  const ModifyAppbarEvent(this._appbar);

  @override
  List<Object> get props => [_appbar];
}
