import 'package:flutter/material.dart';
import 'package:flutter_app_banhang/src/widget/home_page.dart';
import 'package:flutter_app_banhang/src/widget/login_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Grocery Store',
      theme: ThemeData(
        primaryColor: Colors.black,
        fontFamily: 'JosefinSans',
      ),
      home: LoginPage(),
    );
  }
}
