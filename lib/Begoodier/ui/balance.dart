import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../widgets.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

Widget showBalance({context, balance, username}) {
  String addBalanceAmount = "0";

  return Row(
    children: <Widget>[
      Text(
        "Balance: € $balance",
        style: TextStyle(
          color: Color(0xFFAC2797),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      Sb(w: 5),
      InkWell(
        onTap: () {
          Alert(
              context: context,
              title: "ADD MONEY TO YOUR BALANCE",
              content: Container(
                child: Column(children: <Widget>[
                  Sb(h: 15),
                  Text("Write the amount of money you want to load."),
                  Sb(h: 15),
                  customTextField(
                      hintText: "Ex: 10",
                      backgroundColor: Color(0xFFE6E6E6),
                      inputType: TextInputType.number,
                      onChange: (value) {
                        addBalanceAmount = value;
                      }),
                  Sb(h: 15),
                  DialogButton(
                    onPressed: () {
                      try {
                        Firestore.instance
                            .collection('balanceadding')
                            .document()
                            .setData({
                          "username": username,
                          "amount": int.parse(addBalanceAmount),
                          "status": 0,
                          "time": DateTime.now(),
                        });
                      } catch (e) {
                        print(e);
                      }

                      Navigator.pop(context);
                      Alert(
                          context: context,
                          title: "Pending",
                          desc:
                              "Your payment is pending approval. It will be added to your account after confirmation.",
                          type: AlertType.success,
                          buttons: [
                            DialogButton(
                              child: Text(
                                "OK",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ]).show();
                    },
                    child: Text(
                      "PROCEED",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ]),
              ),
              buttons: []).show();
        },
        child: Icon(
          Icons.add_box,
          color: Color(0xFFD21AB5),
        ),
      ),
    ],
  );
}
