import 'package:begoodyapp/Payment/summary.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'widgets.dart';
import '../widgets.dart';
import 'package:intl/intl.dart';

class SchedulePage extends StatefulWidget {
  DocumentSnapshot provider;
  List selectedServices;

  SchedulePage(this.provider, this.selectedServices);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List saatListesi = [];

  List<Widget> saatler = [];
  String selectedTime;
  String selectedDate;
  DateTime selectedDateF;

  selectFunc(String time, bool unselect) {
    setState(() {
      if (unselect) {
        selectedTime = null;
      } else {
        selectedTime = time;
      }
    });
  }

  createDate({DateTime change}) {
    if (change == null) {
      selectedDateF = DateTime.now();
    } else {
      selectedDateF = change;
    }

    int gun = selectedDateF.day;
    int ay = selectedDateF.month;
    int yil = selectedDateF.year;

    String gunStr = gun < 10 ? "0" + gun.toString() : gun.toString();
    String ayStr = ay < 10 ? "0" + ay.toString() : ay.toString();

    String birlestir = gunStr + ayStr + yil.toString();
    selectedDate = birlestir;
  }

  gettingSaatler() async {
    QuerySnapshot snapshot = await widget.provider.reference
        .collection('schedule')
        .document(selectedDate)
        .collection("busyhours")
        .getDocuments();

    List liste = List.generate(snapshot.documents.length, (index) {
      return snapshot.documents[index].documentID;
    });

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

    setState(() {
      saatler = ilkSaatler.map((saat) {
        return SaatKutusu(
            saat: saat, selectFunc: selectFunc, dolu: liste.contains(saat));
      }).toList();
    });
  }

  @override
  void initState() {
    createDate();
    gettingSaatler();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // ÜST KISIM
          Container(
            alignment: Alignment.bottomLeft,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/profilePicture.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            height: screenHeight * 0.22,
            width: double.infinity,
            child: Stack(
              children: <Widget>[
                // siyah gradient
                Container(
                  width: double.infinity,
                  height: screenHeight * 0.22,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Color(0xFF08090D).withOpacity(0.5),
                    ],
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                  )),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 24, right: 24, top: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // geri butonu
                      Icon(Icons.arrow_back, color: Colors.white, size: 24),
                      SizedBox(height: 14),
                      // başlık
                      Text(
                        "James Goodwin",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // CONTENT
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.only(left: 18, right: 18),
              width: double.infinity,
              height: screenHeight * 0.80,
              decoration: BoxDecoration(
                  color: Color(0xFFF7F7FA),
                  borderRadius: BorderRadius.circular(15)),
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Sb(h: 15),
                  // mevcut gün başlığı
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 25,
                          color: Color(0xFF454F63),
                        ),
                        onTap: () {
                          setState(() {
                            selectedDateF =
                                selectedDateF.subtract(Duration(days: 1));
                          });
                          createDate(change: selectedDateF);
                          gettingSaatler();
                        },
                      ),
                      Text(
                        DateFormat.yMMMMEEEEd().format(selectedDateF),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF2A2E43),
                        ),
                      ),
                      InkWell(
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 25,
                          color: Color(0xFF454F63),
                        ),
                        onTap: () {
                          setState(() {
                            selectedDateF =
                                selectedDateF.add(Duration(days: 1));
                          });
                          createDate(change: selectedDateF);
                          gettingSaatler();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // haftanın günleri
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      haftaninGunu(
                          tarih: selectedDateF.subtract(Duration(days: 3)).day,
                          gun: "S",
                          doluluk: 4,
                          ekranGenislik: screenWidth,
                          onTap: () {
                            setState(() {
                              selectedDateF =
                                  selectedDateF.subtract(Duration(days: 3));
                            });
                            createDate(change: selectedDateF);
                            gettingSaatler();
                          }),
                      SizedBox(width: 5),
                      haftaninGunu(
                          tarih: selectedDateF.subtract(Duration(days: 2)).day,
                          gun: "M",
                          doluluk: 4,
                          ekranGenislik: screenWidth,
                          onTap: () {
                            setState(() {
                              selectedDateF =
                                  selectedDateF.subtract(Duration(days: 2));
                            });
                            createDate(change: selectedDateF);
                            gettingSaatler();
                          }),
                      SizedBox(width: 5),
                      haftaninGunu(
                          tarih: selectedDateF.subtract(Duration(days: 1)).day,
                          gun: "T",
                          doluluk: 4,
                          ekranGenislik: screenWidth,
                          onTap: () {
                            setState(() {
                              selectedDateF =
                                  selectedDateF.subtract(Duration(days: 1));
                            });
                            createDate(change: selectedDateF);
                            gettingSaatler();
                          }),
                      SizedBox(width: 5),
                      haftaninGunu(
                        tarih: selectedDateF.day,
                        gun: "W",
                        doluluk: 4,
                        ekranGenislik: screenWidth,
                        bugun: true,
                      ),
                      SizedBox(width: 5),
                      haftaninGunu(
                          tarih: selectedDateF.add(Duration(days: 1)).day,
                          gun: "T",
                          doluluk: 4,
                          ekranGenislik: screenWidth,
                          onTap: () {
                            setState(() {
                              selectedDateF =
                                  selectedDateF.add(Duration(days: 1));
                            });
                            createDate(change: selectedDateF);
                            gettingSaatler();
                          }),
                      SizedBox(width: 5),
                      haftaninGunu(
                          tarih: selectedDateF.add(Duration(days: 2)).day,
                          gun: "F",
                          doluluk: 4,
                          ekranGenislik: screenWidth,
                          onTap: () {
                            setState(() {
                              selectedDateF =
                                  selectedDateF.add(Duration(days: 2));
                            });
                            createDate(change: selectedDateF);
                            gettingSaatler();
                          }),
                      SizedBox(width: 5),
                      haftaninGunu(
                          tarih: selectedDateF.add(Duration(days: 3)).day,
                          gun: "S",
                          doluluk: 4,
                          ekranGenislik: screenWidth,
                          onTap: () {
                            setState(() {
                              selectedDateF =
                                  selectedDateF.add(Duration(days: 3));
                            });
                            createDate(change: selectedDateF);
                            gettingSaatler();
                          }),
                    ],
                  ),
                  SizedBox(height: 22),

                  // seçildi
                  selectedTime != null
                      ? Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "$selectedTime selected.",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFFAC2797),
                                ),
                              ),
                              RaisedButton(
                                  padding: EdgeInsets.only(
                                      top: 9, bottom: 9, left: 22, right: 16),
                                  color: Color(0xFFAC2797),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      side: BorderSide(
                                          width: 0, style: BorderStyle.none)),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "GO TO PAYMENT",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Sb(w: 7),
                                      Icon(Icons.keyboard_arrow_right,
                                          color: Colors.white, size: 16)
                                    ],
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return BookingSummaryPage(
                                          widget.provider,
                                          widget.selectedServices,
                                          selectedDate,
                                          selectedTime,
                                        );
                                      }),
                                    );
                                  }),
                            ],
                          ),
                        )
                      : Container(),

                  // saatler
                  Text(
                    "MORNING",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFA5ACB9),
                    ),
                  ),
                  SizedBox(height: 20),

                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: saatler.sublist(
                          0, saatler.length >= 5 ? 5 : saatler.length)),

                  SizedBox(height: 16),
                  saatler.length >= 5
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: saatler.sublist(
                              5, saatler.length >= 10 ? 10 : saatler.length))
                      : Container(),
                  SizedBox(height: 20),
                  Text(
                    "AFTERNOON",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFA5ACB9),
                    ),
                  ),
                  SizedBox(height: 20),

                  saatler.length >= 10
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: saatler.sublist(
                              10, saatler.length >= 15 ? 15 : saatler.length))
                      : Container(),
                  SizedBox(height: 16),
                  saatler.length >= 15
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: saatler.sublist(
                              15, saatler.length >= 20 ? 20 : saatler.length))
                      : Container(),
                  SizedBox(height: 20),
                  Text(
                    "EVENING",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFA5ACB9),
                    ),
                  ),
                  SizedBox(height: 20),

                  saatler.length >= 20
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: saatler.sublist(
                              20, saatler.length >= 25 ? 25 : saatler.length))
                      : Container(),
                  SizedBox(height: 16),
                  saatler.length >= 25
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: saatler.sublist(
                              25, saatler.length >= 30 ? 30 : saatler.length))
                      : Container(),
                  SizedBox(height: 90),
                ],
              ),
            ),
          ),

          bottomBar("Home", context, () {}),
        ],
      ),
    );
  }
}
