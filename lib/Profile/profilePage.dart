import 'package:begoodyapp/Profile/schedulePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'widgets.dart';
import '../widgets.dart';
import '../firebase_functions.dart';

class ProfilePage extends StatefulWidget {
  String username;

  ProfilePage(this.username);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int toplam = 0;
  DocumentSnapshot provider;
  List<Widget> services = [];

  List selected = [];

  @override
  void initState() {
    getProv(Function state) async {
      provider = await getProvider(widget.username);
      state();
    }

    getProv(() {
      setState(() {});
    });

    listingServices(context, widget.username);

    super.initState();
  }

  listingServices(BuildContext context, String username) async {
    QuerySnapshot snapshot = await Firestore.instance
        .collection('provider')
        .document(username)
        .collection("services")
        .getDocuments();

    List liste = snapshot.documents;

    setState(() {
      services = liste.map((document) {
        return hizmetCubugu(
            image: "images/cuttingHair.jpg",
            name: document["name"],
            price: document["price"].toString(),
            buyAction: (bool withdraw) {
              setState(() {
                if (withdraw) {
                  selected.remove(document);
                  toplam = toplam - document["price"];
                } else {
                  selected.add(document);
                  toplam = toplam + document["price"];
                }
              });
            });
      }).toList();
    });
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
            height: screenHeight * 0.45,
            width: double.infinity,
            child: Stack(
              children: <Widget>[
                // siyah gradient
                Container(
                  width: double.infinity,
                  height: screenHeight * 0.45,
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
                  padding: EdgeInsets.only(left: 24, right: 24, bottom: 27),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // başlık
                      Text(
                        provider != null ? provider.data["name"] : "",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 12),
                      // puanlamalar
                      Row(
                        children: <Widget>[
                          ratingCard(
                            screenWidth: screenWidth,
                            name: "Hygiene",
                            rating: provider != null
                                ? provider.data["hygiene"].toString()
                                : "",
                          ),
                          SizedBox(width: 8),
                          ratingCard(
                            screenWidth: screenWidth,
                            name: "Talent",
                            rating: provider != null
                                ? provider.data["talent"].toString()
                                : "",
                          ),
                          SizedBox(width: 8),
                          ratingCard(
                            screenWidth: screenWidth,
                            name: "Timing",
                            rating: provider != null
                                ? provider.data["timing"].toString()
                                : "",
                          ),
                          SizedBox(width: 8),
                          ratingCard(
                            screenWidth: screenWidth,
                            name: "Kindness",
                            rating: provider != null
                                ? provider.data["kindness"].toString()
                                : "",
                          ),
                        ],
                      )
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
              padding: EdgeInsets.symmetric(
                horizontal: 22,
              ),
              width: double.infinity,
              height: screenHeight * 0.57,
              decoration: BoxDecoration(
                  color: Color(0xFFF7F7FA),
                  borderRadius: BorderRadius.circular(15)),
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Sb(h: 25),
                  // toplam ve devam et
                  toplam > 0
                      ? Padding(
                          padding: EdgeInsets.only(bottom: 21.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                " Total: \$ $toplam",
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
                                        "CHECK THE SCHEDULE",
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
                                        return SchedulePage(provider, selected);
                                      }),
                                    );
                                  }),
                            ],
                          ),
                        )
                      : Container(),
                  // - açıklama
                  Text(
                    provider != null ? provider.data["description"] : "",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF2A2E43),
                    ),
                  ),
                  SizedBox(height: 28),
                  // - hizmetler
                  Column(children: services),

                  /*     hizmetCubugu(
                      screenWidth: screenWidth,
                      image: "images/cuttingHair.jpg",
                      name: "Hair Cut",
                      price: "25",
                      buyAction: (bool withdraw) {
                        setState(() {
                          if (withdraw) {
                            toplam = toplam - 25;
                          } else {
                            toplam = toplam + 25;
                          }
                        });
                      }),
                  SizedBox(height: 15),
                  hizmetCubugu(
                      screenWidth: screenWidth,
                      image: "images/cuttingHair.jpg",
                      name: "Blow Dry",
                      price: "10",
                      buyAction: (bool withdraw) {
                        setState(() {
                          if (withdraw) {
                            toplam = toplam - 10;
                          } else {
                            toplam = toplam + 10;
                          }
                        });
                      }),
                  SizedBox(height: 15),
                  hizmetCubugu(
                      screenWidth: screenWidth,
                      image: "images/cuttingHair.jpg",
                      name: "Hair Coloring",
                      price: "50",
                      buyAction: (bool withdraw) {
                        setState(() {
                          if (withdraw) {
                            toplam = toplam - 50;
                          } else {
                            toplam = toplam + 50;
                          }
                        });
                      }),
                  SizedBox(height: 15),
                  hizmetCubugu(
                      screenWidth: screenWidth,
                      image: "images/cuttingHair.jpg",
                      name: "Hair Coloring",
                      price: "50",
                      buyAction: (bool withdraw) {
                        setState(() {
                          if (withdraw) {
                            toplam = toplam - 50;
                          } else {
                            toplam = toplam + 50;
                          }
                        });
                      }),*/
                  SizedBox(height: 50),
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
