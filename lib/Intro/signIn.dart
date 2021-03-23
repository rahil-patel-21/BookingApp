import 'package:begoodyapp/Home/homePage.dart';
import 'package:begoodyapp/Intro/beGoodierLogin.dart';
import 'package:flutter/material.dart';
import '../widgets.dart';
import '../firebase_functions.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String email;
  String password;

  singInFunc() async {
    bool success;
    try {
      User userObj = await signIn(email, password, () {
        success = true;
      }, () {
        print("Mail or password wrong");
        success = false;
        return false;
      }, () {
        print("Bir hata oluştu");
        success = false;
        return false;
      });

      if (success) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return HomePage();
          }),
        );
      }
    } catch (e) {
      print("Hata");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 23, right: 23),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Sb(h: 50),
          // TEXT FIELDS
          customTextField(
            hintText: "Email",
            onChange: (value) {
              setState(() {
                email = value;
              });
            },
            parola: false,
          ),
          SizedBox(height: 24),
          customTextField(
            hintText: "Password",
            onChange: (value) {
              setState(() {
                password = value;
              });
            },
            parola: true,
          ),

          SizedBox(height: 36),
          // FORGOT PASSWORD
          Center(
            child: Text(
              "FORGOT PASSWORD",
              style: TextStyle(
                color: Color(0xFF78849E),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          SizedBox(height: 33),

          // SIGN IN BUTTON
          Container(
              width: double.infinity,
              child: primaryButton(
                  text: "SIGN IN",
                  onPressed: () {
                    singInFunc();
                  })),
          SizedBox(height: 37),

          // OTHER OPTIONS
          Container(
            width: double.infinity,
            height: 2,
            color: Color(0xFFEFEFEF),
          ),
          SizedBox(height: 31),

          Text(
            "Other options:",
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF78849E),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16),

          Center(
            child: Container(
                padding:
                    EdgeInsets.only(top: 11, bottom: 11, left: 9, right: 18),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.asset(
                      "images/google.png",
                      width: 42,
                    ),
                    Text(
                      "Sign in with Google",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2A2E43),
                      ),
                    )
                  ],
                ),
                decoration: neuMorphicDecor),
          ),
          Sb(h: 40),

          // BEGOODIER LOGIN
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return BegoodierLoginPage();
                }),
              );
            },
            child: Center(
              child: Text(
                "BEGOODIER LOGIN",
                style: TextStyle(
                  color: Color(0xFF78849E),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          Sb(h: 50),
        ],
      ),
    );
  }
}
