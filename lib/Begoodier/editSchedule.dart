import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../widgets.dart';

class EditSchedule extends StatefulWidget {
  String username;

  EditSchedule(this.username);

  @override
  _EditScheduleState createState() => _EditScheduleState();
}

class _EditScheduleState extends State<EditSchedule> {
  List ilkSaatler = [
    "08:00",
    "08:30",
    "09:00",
    "09:30",
    "10:00",
    "10:30",
    "11:00",
    "11:30",
    "12:00",
    "12:30",
    "13:00",
    "13:30",
    "14:00",
    "14:30",
    "15:00",
    "15:30",
    "16:00",
    "16:30",
    "17:00",
    "17:30",
    "18:00",
    "18:30",
    "19:00",
    "19:30",
    "20:00",
    "20:30",
    "21:00",
    "21:30",
    "22:00",
    "22:30",
  ];

  List seciliSaatler = [];

  DateTime seciliTarihDate;
  int seciliAy;
  int seciliGun;
  String seciliAyStr;
  String seciliGunStr;
  String seciliYil;
  String seciliTarih;

  getBusyHours(String tarih) async {
    await Firestore.instance
        .collection('provider')
        .document(widget.username)
        .collection("schedule")
        .document(tarih)
        .collection("busyhours")
        .getDocuments()
        .then((snapshot) {
      snapshot.documents.forEach((snap) {
        setState(() {
          seciliSaatler.add(snap.documentID);
        });
      });
    });
  }

  update() async {
    await Firestore.instance
        .collection('provider')
        .document(widget.username)
        .collection("schedule")
        .document(seciliTarih)
        .collection("busyhours")
        .getDocuments()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.delete();
      }
    });
    seciliSaatler.forEach((saat) {
      Firestore.instance
          .collection('provider')
          .document(widget.username)
          .collection("schedule")
          .document(seciliTarih)
          .collection("busyhours")
          .document(saat)
          .setData({});
    });
  }

  gunuGuncelle(DateTime seciliTarihDate) {
    seciliAy = seciliTarihDate.month;
    seciliGun = seciliTarihDate.day;
    seciliYil = seciliTarihDate.year.toString();

    setState(() {
      seciliGunStr =
          seciliGun < 10 ? "0" + seciliGun.toString() : seciliGun.toString();
      seciliAyStr =
          seciliAy < 10 ? "0" + seciliAy.toString() : seciliAy.toString();
      seciliTarih = seciliGunStr + seciliAyStr + seciliYil;
    });
  }

  @override
  void initState() {
    seciliTarihDate = DateTime.now();
    gunuGuncelle(seciliTarihDate);

    getBusyHours(seciliTarih);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
                onTap: () {
                  seciliTarihDate = seciliTarihDate.subtract(Duration(days: 1));

                  gunuGuncelle(seciliTarihDate);
                  setState(() {
                    seciliSaatler.clear();
                  });

                  getBusyHours(seciliTarih);
                },
                child: Icon(Icons.arrow_back)),
            Sb(w: 15),
            Text(seciliAyStr + "." + seciliGunStr + "." + seciliYil),
            Sb(w: 15),
            InkWell(
                onTap: () {
                  seciliTarihDate = seciliTarihDate.add(Duration(days: 1));

                  gunuGuncelle(seciliTarihDate);
                  setState(() {
                    seciliSaatler.clear();
                  });
                  getBusyHours(seciliTarih);
                },
                child: Icon(Icons.arrow_forward)),
          ],
        ),
        Sb(h: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 15.0),
              child: Column(
                  children: ilkSaatler.sublist(0, 15).map((saat) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(saat),
                      Sb(w: 10),
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (seciliSaatler.contains(saat)) {
                              seciliSaatler.remove(saat);
                            } else {
                              seciliSaatler.add(saat);
                            }
                          });
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          color: Color(0xFFE9E9E9),
                          child: seciliSaatler.contains(saat)
                              ? Icon(Icons.done, size: 18)
                              : Container(),
                        ),
                      )
                    ],
                  ),
                );
              }).toList()),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Column(
                  children: ilkSaatler.sublist(15, 30).map((saat) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(saat),
                      Sb(w: 10),
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (seciliSaatler.contains(saat)) {
                              seciliSaatler.remove(saat);
                            } else {
                              seciliSaatler.add(saat);
                            }
                          });
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          color: Color(0xFFE9E9E9),
                          child: seciliSaatler.contains(saat)
                              ? Icon(Icons.done, size: 18)
                              : Container(),
                        ),
                      )
                    ],
                  ),
                );
              }).toList()),
            ),
          ],
        ),
        Sb(h: 10),
        DialogButton(
          onPressed: () {
            try {
              update();
              Alert(
                  context: context,
                  title: "Success",
                  desc: "Busy hours have been saved.",
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
            } catch (e) {
              print(e);
            }
          },
          child: Text(
            "SAVE",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ],
    );
  }
}
