import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../firebase_functions.dart';
import '../widgets.dart';
import 'package:flutter/material.dart';
import 'widgets.dart';
import 'ui/map.dart';

class BookingSummaryPage extends StatefulWidget {
  DocumentSnapshot provider;
  List selectedServices;
  String selectedDate;
  String selectedTime;

  BookingSummaryPage(this.provider, this.selectedServices, this.selectedDate,
      this.selectedTime);

  @override
  _BookingSummaryPageState createState() => _BookingSummaryPageState();
}

class _BookingSummaryPageState extends State<BookingSummaryPage> {
  double toplam = 0;
  String dateAndTime;
  User myUser;

  getUser() async {
    myUser = await getCurrentUser();
    setState(() {});
  }

  @override
  void initState() {
    widget.selectedServices.forEach((item) {
      toplam += item['price'];
    });

    dateAndTime = widget.selectedDate.substring(0, 2) +
        "." +
        widget.selectedDate.substring(2, 4) +
        "." +
        widget.selectedDate.substring(4, 8) +
        "\n" +
        widget.selectedTime;

    getUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: ListView(
              padding: EdgeInsets.only(top: 48, left: 20, right: 20),
              children: <Widget>[
                // başlık
                Align(
                  alignment: Alignment.topLeft,
                  child: Icon(
                    Icons.arrow_back,
                    size: 24,
                    color: Color(0xFF454F63),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Booking Summary",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF454F63),
                  ),
                ),
                SizedBox(height: 38),
                // özet kutusu
                Container(
                  padding: EdgeInsets.fromLTRB(18, 20, 11, 20),
                  child: Column(
                    children: <Widget>[
                      // hizmet veren foto ve isim
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Image.asset(
                                "images/profilePicture.jpg",
                                width: 44,
                              ),
                              SizedBox(width: 9),
                              Text(
                                widget.provider.data["name"],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF454F63),
                                ),
                              )
                            ],
                          ),

                          // tarih ve saat
                          Text(
                            dateAndTime,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFE5007E),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 14),
                      // hizmet başlıkları
                      Column(
                        children: widget.selectedServices.map((service) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      service["name"],
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF78849E),
                                      ),
                                    ),
                                    Text(
                                      service['price'].toString(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF78849E),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList() +
                            [
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Total",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF78849E),
                                      ),
                                    ),
                                    Text(
                                      toplam.toString(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF78849E),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                      ),
                    ],
                  ),
                  decoration: customCardDecoration(),
                ),
                SizedBox(height: 34),
                // konum
                Text(
                  "Location",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF454F63),
                  ),
                ),
                SizedBox(height: 26),
                /*   Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(Icons.my_location),
                        Sb(w: 5),
                        Text(
                          "Current location (N22 6LB)",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    Icon(Icons.check_circle),
                  ],
                ), */

                InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.map,
                            color: Color(0xFF78849E),
                          ),
                          Sb(w: 5),
                          Text(
                            "Select on map",
                            style: TextStyle(
                                fontSize: 18, color: Color(0xFF78849E)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  onTap: () {
                    Alert(
                        context: context,
                        title: "SELECT LOCATION",
                        content: Container(
                          width: screenWidth * 0.75,
                          height: screenHeight * 0.65,
                          child: SelectServiceLocationMap(
                            key: UniqueKey(),
                            setLocationFunc: (LatLng loc) {
                              /*
                                  setState(() {
                                    locationData =
                                        GeoPoint(loc.latitude, loc.longitude);
                                  });
                                  */
                            },
                          ),
                        ),
                        buttons: [
                          DialogButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              "SAVE",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          )
                        ]).show();
                  },
                ),
                SizedBox(height: 13),
                Container(
                  width: double.infinity,
                  height: 2,
                  color: Color(0xFF78849E),
                ),

                SizedBox(height: 34),

                // ödeme yöntemi
                Text(
                  "Payment Method",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF454F63),
                  ),
                ),
                SizedBox(height: 26),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        cashConfirm(context, () {
                          try {
                            Firestore.instance
                                .collection('bookings')
                                .document()
                                .setData({
                              'providerUid': widget.provider.documentID,
                              'providerName': widget.provider.data['name'],
                              'userUid': myUser.uid,
                              'userName': myUser.name,
                              'status': 2,
                              'time': dateAndTime,
                              'totalPrice': toplam,
                              'location': '',
                            });
                          } catch (e) {
                            print(e);
                          }
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 25),
                        width: (screenWidth - 75) / 2,
                        child: Text(
                          "CASH",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2A2E43),
                          ),
                        ),
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Color(0xFF2A2E43), width: 2),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SizedBox(width: 20),
                    InkWell(
                      onTap: () {
                        bankTrasnferConfirm(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        width: (screenWidth - 75) / 2,
                        child: Text(
                          "BANK TRANSFER",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2A2E43),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Color(0xFF2A2E43), width: 2),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
                Sb(h: 100),
              ],
            ),
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFFF7F7FA),
            ),
          ),
          bottomBar("Home", context, () {}),
        ],
      ),
    );
  }
}
