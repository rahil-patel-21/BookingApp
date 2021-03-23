import 'package:begoodyapp/Bookings/myBookingsPage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/material.dart';

cashConfirm(context, Function confirmFunc) {
  bool ok = false;
  return Alert(
    context: context,
    type: AlertType.info,
    title: "CONFIRM YOUR BOOKING",
    desc:
        "Your order will be created as shown in the summary and you will pay in cash.",
    buttons: [
      DialogButton(
        child: Text(
          "CONFIRM",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () {
          confirmFunc();
          ok = true;
          Navigator.pop(context);
        },
        color: Color.fromRGBO(0, 179, 134, 1.0),
      ),
      DialogButton(
        child: Text(
          "CANCEL",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Navigator.pop(context),
        gradient: LinearGradient(colors: [
          Color.fromRGBO(116, 116, 191, 1.0),
          Color.fromRGBO(52, 138, 199, 1.0)
        ]),
      )
    ],
  ).show().then((bool arg) {
    if (ok) {
      successAlert(context);
    }
  });
}

bankTrasnferConfirm(context) {
  return Alert(
    context: context,
    type: AlertType.info,
    title: "CONFIRM YOUR BOOKING",
    desc:
        "Your order will be created as shown in the summary and you will make your payment by transfer to the bank accounts shown on the next page.",
    buttons: [
      DialogButton(
        child: Text(
          "CONFIRM",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Navigator.pop(context),
        color: Color.fromRGBO(0, 179, 134, 1.0),
      ),
      DialogButton(
        child: Text(
          "CANCEL",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Navigator.pop(context),
        gradient: LinearGradient(colors: [
          Color.fromRGBO(116, 116, 191, 1.0),
          Color.fromRGBO(52, 138, 199, 1.0)
        ]),
      )
    ],
  ).show();
}

successAlert(context) {
  return Alert(
    context: context,
    type: AlertType.success,
    title: "Success",
    desc:
        "Your appointment request has been created successfully. Approval of the provider is pending.",
    buttons: [
      DialogButton(
        child: Text(
          "OK",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) {
              return MyBookingsPage();
            }),
          );
        },
        width: 120,
      )
    ],
  ).show();
}
