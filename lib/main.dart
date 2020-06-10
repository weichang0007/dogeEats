import 'package:flutter/material.dart';
import 'package:dogeeats/page/pages.dart';

void main() => runApp(DogeEatsApp());

class DogeEatsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DogeEats',
      theme: ThemeData.light().copyWith(
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
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
      ),
      routes: {
        "/": (context) => HomePage(),
        "/home": (context) => HomePage(),
      },
    );
  }
}
