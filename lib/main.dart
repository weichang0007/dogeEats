import 'package:flutter/material.dart';

void main() => runApp(DogeEatsApp());

class DogeEatsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DogeEats',
      theme: ThemeData.light().copyWith(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Center(),
    );
  }
}