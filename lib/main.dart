import 'dart:ffi';
import 'dart:io';
import 'package:dogeeats/bloc/blocs.dart';
import 'package:dogeeats/model/models.dart';
import 'package:flutter/material.dart';
import 'package:dogeeats/page/pages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:page_transition/page_transition.dart';

void main() {
  HttpOverrides.global = UnsafeHttpOverrides();
  runApp(Phoenix(child: DogeEatsApp()));
}

class UnsafeHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class DogeEatsApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DogeEatsAppState();
}

class DogeEatsAppState extends State<DogeEatsApp> {
  String modeFlag;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    modeFlag = null;
    _loadSetting();
  }

  _loadSetting() async {
    Setting setting = await Setting.instance;
    modeFlag = setting.flag;
    setState(() {});
  }

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
    debugShowCheckedModeBanner: false,
    title: 'DogeEats',
    theme: theme,
    onGenerateRoute: (settings) {
      switch (settings.name) {
        case '/':
          return PageTransition(
            duration: Duration(milliseconds: 500),
            child: LoginPage(),
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
        case '/option':
          return PageTransition(
            duration: Duration(milliseconds: 500),
            child: OptionPage(),
            type: PageTransitionType.fade,
            settings: settings,
          );
          break;
        default:
          return null;
      }
    },
  );

  final deliveryPersonApp = MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'DogeEats - DeliveryMode',
    theme: theme,
    onGenerateRoute: (settings) {
      switch (settings.name) {
        case '/':
          return PageTransition(
            duration: Duration(milliseconds: 500),
            child: LoginPage(),
            type: PageTransitionType.fade,
            settings: settings,
          );
          break;
        case '/home':
          return PageTransition(
            duration: Duration(milliseconds: 500),
            child: Scaffold(body: DeliveryHomePage()),
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
    if (modeFlag == null) return MaterialApp(home: Scaffold(body: Center()));
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (BuildContext context) => LoginBloc(),
        ),
        BlocProvider<RegisterBloc>(
          create: (BuildContext context) => RegisterBloc(),
        ),
        BlocProvider<AppbarBloc>(
          create: (BuildContext context) => AppbarBloc(),
        ),
      ],
      child: modeFlag == "custom" ? coustomerApp : deliveryPersonApp,
    );
  }
}
