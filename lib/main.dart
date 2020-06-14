import 'dart:io';

import 'package:dogeeats/bloc/blocs.dart';
import 'package:flutter/material.dart';
import 'package:dogeeats/page/pages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

void main() {
  HttpOverrides.global = UnsafeHttpOverrides();
  runApp(DogeEatsApp());
}

class UnsafeHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class DogeEatsApp extends StatelessWidget {
  static final ThemeData theme = ThemeData.light().copyWith(
    brightness: Brightness.light,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: Colors.green,
    textTheme: ThemeData.light().textTheme.apply(
          bodyColor: Colors.black,
          displayColor: Colors.black,
        ),
    appBarTheme: AppBarTheme(
      color: Colors.white,
      textTheme: TextTheme(
        headline6: TextStyle(color: Colors.black, fontSize: 18),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
    ),
  );

  final coustomerApp = MaterialApp(
    title: 'DogeEats',
    theme: theme,
    onGenerateRoute: (settings) {
      switch (settings.name) {
        case '/':
          return PageTransition(
            duration: Duration(milliseconds: 500),
            child: HomePage(),
            type: PageTransitionType.fade,
            settings: settings,
          );
          break;
        case '/home':
          return PageTransition(
            duration: Duration(milliseconds: 500),
            child: HomePage(),
            type: PageTransitionType.fade,
            settings: settings,
          );
          break;
        case '/login':
          return PageTransition(
            duration: Duration(milliseconds: 500),
            child: LoginPage(),
            type: PageTransitionType.fade,
            settings: settings,
          );
          break;
        case '/register':
          return PageTransition(
            duration: Duration(milliseconds: 500),
            child: RegisterPage(),
            type: PageTransitionType.fade,
            settings: settings,
          );
          break;
        case '/restaurant':
          return PageTransition(
            duration: Duration(milliseconds: 500),
            child: RestaurantPage(),
            type: PageTransitionType.fade,
            settings: settings,
          );
          break;
        default:
          return null;
      }
    },
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (BuildContext context) => LoginBloc()),
      ],
      child: coustomerApp,
    );
  }
}
