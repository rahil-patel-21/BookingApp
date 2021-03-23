import 'package:begoodyapp/Home/homePage.dart';
import 'package:flutter/material.dart';
import '../widgets.dart';

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 23, right: 23),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // TEXT FIELDS
          SizedBox(height: 28),
          customTextField(hintText: "Name"),
          SizedBox(height: 24),
          customTextField(hintText: "Phone number"),
          SizedBox(height: 24),
          customTextField(hintText: "Email"),
          SizedBox(height: 24),
          customTextField(hintText: "Gender"),
          SizedBox(height: 24),
          customTextField(hintText: "Address"),
          SizedBox(height: 24),
          customTextField(hintText: "Password"),

          SizedBox(height: 36),

          // SIGN IN BUTTON
          Container(
              width: double.infinity,
              child: primaryButton(
                  text: "SIGN UP",
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return HomePage();
                      }),
                    );
                  })),
          SizedBox(height: 37),
        ],
      ),
    );
  }
}
