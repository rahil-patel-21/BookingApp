import 'package:begoodyapp/Bookings/myBookingsPage.dart';
import 'package:begoodyapp/Home/homePage.dart';
import 'package:begoodyapp/Intro/signIn.dart';
import 'package:begoodyapp/Profile/profilePage.dart';
import 'package:begoodyapp/Profile/schedulePage.dart';
import 'package:begoodyapp/Payment/summary.dart';
import 'package:flutter/material.dart';
import 'intro/introPage.dart';
import 'package:stories/models/story.dart';
import 'package:stories/stories.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeGoody',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Gibson",
      ),
      home: HomePage(
        begoodierUserName: "chandlerbing",
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}
