import 'package:begoodyapp/Home/homePage.dart';
import 'package:flutter/material.dart';
import '../widgets.dart';
import '../firebase_functions.dart';

class BegoodierLoginPage extends StatefulWidget {
  @override
  _BegoodierLoginPageState createState() => _BegoodierLoginPageState();
}

class _BegoodierLoginPageState extends State<BegoodierLoginPage> {
  String username;
  String password;

  singInFunc() async {
    try {
      await signInBegoodier(username, password, () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return HomePage(
              begoodierUserName: username,
            );
          }),
        );
      }, () {
        print("Mail or password wrong");

        return false;
      }, () {
        print("Bir hata oluştu");
        return false;
      });
    } catch (e) {
      print("Hata");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 23, right: 23),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Sb(h: 50),
            Image.asset(
              "images/logo.png",
              height: 80,
            ),

            Sb(h: 40),

            Text(
              "Begoodier Login",
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w600,
                color: Color(0xFF454F63),
              ),
            ),
            Sb(h: 36),
            // TEXT FIELDS
            customTextField(
              hintText: "Username",
              onChange: (value) {
                setState(() {
                  username = value;
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

            Sb(h: 40),

            // BEGOODIER LOGIN
            Center(
              child: Text(
                "REGISTER PAGE",
                style: TextStyle(
                  color: Color(0xFF78849E),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            Sb(h: 50),
          ],
        ),
      ),
    );
  }
}
