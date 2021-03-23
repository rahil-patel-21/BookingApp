import 'package:begoodyapp/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../firebase_functions.dart';
import 'reviewWindow.dart';

class MyBookingsPage extends StatefulWidget {
  @override
  _MyBookingsPageState createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool reviewOpen = false;
  User myUser;
  List<Widget> bookings = [];
  List<Widget> pendingBookings = [];

  getUser() async {
    myUser = await getCurrentUser();
    setState(() {});
  }

  getFutureBookings() async {
    QuerySnapshot snapshot = await Firestore.instance
        .collection('bookings')
        .where('userUid', isEqualTo: myUser.uid)
        .where("status", isEqualTo: 0)
        .getDocuments();

    List liste = snapshot.documents;

    setState(() {
      bookings = liste.map((document) {
        return bookingLine(
          providerName: document['providerName'],
          dateAndTime: document['time'],
        );
      }).toList();
    });
  }

  getPendingBookings() async {
    QuerySnapshot snapshot = await Firestore.instance
        .collection('bookings')
        .where('userUid', isEqualTo: myUser.uid)
        .where("status", isEqualTo: 2)
        .getDocuments();

    List liste = snapshot.documents;

    setState(() {
      pendingBookings = liste.map((document) {
        return bookingLinePending(
          providerName: document['providerName'],
          dateAndTime: document['time'],
        );
      }).toList();
    });
  }

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);

    firstData() async {
      await getUser();
      getFutureBookings();
      getPendingBookings();
    }

    firstData();

    super.initState();
  }

  closePopup() {
    setState(() {
      reviewOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(150),
            child: Padding(
              padding: EdgeInsets.only(top: 25),
              child: AppBar(
                backgroundColor: Color(0xFFF7F7FA),
                bottom: ColoredTabBar(
                  Colors.white,
                  TabBar(
                    controller: _tabController,
                    indicatorColor: Color(0xFFAC2797),
                    indicatorWeight: 5,
                    unselectedLabelColor: Color(0xFF959DAD),
                    labelColor: Color(0xFF454F63),
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    tabs: [
                      Tab(
                        text: "FUTURE",
                      ),
                      Tab(
                        text: "PAST",
                      ),
                      Tab(
                        text: "PENDING",
                      ),
                    ],
                  ),
                ),
                title: Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "My Bookings",
                    style: TextStyle(
                      color: Color(0xFF454F63),
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: Stack(
            children: <Widget>[
              TabBarView(
                controller: _tabController,
                children: [
                  // FUTURE

                  Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 16, right: 16, top: 37),
                        padding: EdgeInsets.only(
                            top: 20, bottom: 20, left: 18, right: 11),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: bookings,
                        ),
                        decoration: customCardDecoration(),
                      ),
                    ],
                  ),

                  // PAST

                  Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 16, right: 16, top: 37),
                        padding: EdgeInsets.only(
                            top: 20, bottom: 20, left: 18, right: 11),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            // hizmet veren foto ve isim
                            bookingLinePast(() {
                              setState(() {
                                if (reviewOpen) {
                                  reviewOpen = false;
                                } else {
                                  reviewOpen = true;
                                }
                              });
                            }),
                            SizedBox(
                              height: 18,
                            ),
                            Container(
                              height: 1,
                              width: double.infinity,
                              color: Color(0xFFF4F4F6),
                            ),
                            SizedBox(
                              height: 22,
                            ),
                            bookingLinePast(() {
                              setState(() {
                                if (reviewOpen) {
                                  reviewOpen = false;
                                } else {
                                  reviewOpen = true;
                                }
                              });
                            }),
                            SizedBox(height: 14),
                          ],
                        ),
                        decoration: customCardDecoration(),
                      ),
                    ],
                  ),

                  // PENDING
                  Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 16, right: 16, top: 37),
                        padding: EdgeInsets.only(
                            top: 20, bottom: 20, left: 18, right: 11),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: pendingBookings,
                        ),
                        decoration: customCardDecoration(),
                      ),
                    ],
                  ),
                ],
              ),
              bottomBar("Bookings", context, () {}),
            ],
          ),
        ),
        reviewOpen
            ? Scaffold(
                body: Stack(
                  children: <Widget>[
                    // siyah kaplama
                    reviewOpen
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                reviewOpen = false;
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.black.withOpacity(0.72),
                            ),
                          )
                        : Container(),

                    // Review penceresi
                    reviewOpen
                        ? reviewWindow(screenHeight, screenWidth, closePopup)
                        : Container(),
                  ],
                ),
              )
            : Container()
      ],
    );
  }
}

Widget bookingLine({String providerName, String dateAndTime}) {
  return Column(
    children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Image.asset(
                "images/profilePicture.jpg",
                width: 52,
              ),
              SizedBox(width: 9),
              Column(
                children: <Widget>[
                  Text(
                    providerName == null ? "" : providerName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF454F63),
                    ),
                  ),
                  Text(
                    "Hair Cut - Blow Dry",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF78849E),
                    ),
                  ),
                ],
              )
            ],
          ),

          // tarih ve saat
          Text(
            dateAndTime != null ? dateAndTime : "",
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          )
        ],
      ),
      SizedBox(
        height: 18,
      ),
      Container(
        height: 1,
        width: double.infinity,
        color: Color(0xFFF4F4F6),
      ),
    ],
  );
}

Widget bookingLinePending({String providerName, String dateAndTime}) {
  return Column(
    children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Image.asset(
                "images/profilePicture.jpg",
                width: 52,
              ),
              SizedBox(width: 9),
              Column(
                children: <Widget>[
                  Text(
                    providerName == null ? "" : providerName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF454F63),
                    ),
                  ),
                  Text(
                    "Hair Cut - Blow Dry",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF78849E),
                    ),
                  ),
                ],
              )
            ],
          ),

          // tarih ve saat
          Text(
            dateAndTime != null ? dateAndTime : "",
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFFE5007E),
            ),
          )
        ],
      ),
      SizedBox(
        height: 18,
      ),
      Container(
        height: 1,
        width: double.infinity,
        color: Color(0xFFF4F4F6),
      ),
    ],
  );
}

bookingLinePast(onTap) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Row(
        children: <Widget>[
          Image.asset(
            "images/profilePicture.jpg",
            width: 52,
          ),
          SizedBox(width: 9),
          Column(
            children: <Widget>[
              Text(
                "James Goodwin",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF454F63),
                ),
              ),
              Text(
                "Hair Cut - Blow Dry",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF78849E),
                ),
              ),
            ],
          )
        ],
      ),

      // review butonu
      InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 23, vertical: 10),
          child: Text(
            "REVIEW",
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          decoration: BoxDecoration(
            color: Color(0xFFAC2797),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    ],
  );
}
