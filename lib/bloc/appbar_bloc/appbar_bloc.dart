import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'appbar_event.dart';
part 'appbar_state.dart';

class AppbarBloc extends Bloc<AppbarEvent, AppbarState> {
  @override
  AppbarState get initialState => AppbarInitial();

  @override
  Stream<AppbarState> mapEventToState(AppbarEvent event) async* {
    yield AppbarInitial();
    if (event is ModifyAppbarEvent) {
      yield AppbarModify(event.props[0]);
    }
  }
}
