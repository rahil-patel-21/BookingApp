import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../widgets.dart';
import 'map.dart';
import 'widgets.dart';
import 'editSchedule.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'uploader.dart';
import 'myServices.dart';
import 'ui/balance.dart';

class BegoodierSettings extends StatefulWidget {
  final String username;

  BegoodierSettings(this.username);

  @override
  _BegoodierSettingsState createState() => _BegoodierSettingsState();
}

class _BegoodierSettingsState extends State<BegoodierSettings> {
  DocumentSnapshot currentData;

  String username;
  String name;
  String password;
  String description;
  GeoPoint locationData;
  bool toMale = false;
  bool toFemale = false;
  int serviceType = 0;
  double balance = 0;

  String currentPhotoUrl;
  File _image;

  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://begoody-app.appspot.com/');
  StorageUploadTask _uploadTask;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  getCurrentData(username) async {
    currentData = await Firestore.instance
        .collection('provider')
        .document(username)
        .get();
    setState(() {
      description = currentData.data["description"];
      locationData = currentData.data["location"];
      name = currentData.data["name"];
      toMale = currentData.data["toMale"];
      toFemale = currentData.data["toFemale"];
      balance = double.parse(currentData.data["balance"].toString());
      currentPhotoUrl = currentData.data["profilePhoto"];
      if (currentData.data["serviceType"] != null) {
        serviceType = currentData.data["serviceType"];
      } else {
        serviceType = 0;
      }
    });
  }

  @override
  void initState() {
    username = widget.username;

    getCurrentData(username);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 23),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Sb(h: 70),
            Text(
              "Begoodier Settings",
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w600,
                color: Color(0xFF454F63),
              ),
            ),
            Sb(h: 22),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  showBalance(
                      context: context, username: username, balance: balance),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => MyServices(username)));
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 19, vertical: 9),
                      child: Text(
                        "MY SERVICES",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFAC2797),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          topLeft: Radius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Sb(h: 18),
            Padding(
              padding: EdgeInsets.only(right: 23.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  customTextField(
                    hintText: username,
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

                  SizedBox(height: 24),

                  customTextField(
                    hintText: name == null ? "Name" : name,
                    onChange: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                  ),
                  SizedBox(height: 24),
                  // SERVICE TYPE
                  Padding(
                    padding: EdgeInsets.only(left: 12, right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Service type: ",
                          style: settingsTextStyle,
                        ),
                        DropdownButton<String>(
                          value: serviceType == 0
                              ? "Freelance"
                              : serviceType == 1 ? "Shop" : "",
                          style: settingsTextStyle,
                          items:
                              <String>["Freelance", "Shop"].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (_) {
                            setState(() {
                              if (_ == "Freelance") {
                                serviceType = 0;
                              } else if (_ == "Shop") {
                                serviceType = 1;
                              }
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  // CİNSİYET
                  Padding(
                    padding: EdgeInsets.only(left: 12, right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Service to: ",
                          style: settingsTextStyle,
                        ),
                        Row(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (toMale) {
                                    toMale = false;
                                  } else {
                                    toMale = true;
                                  }
                                });
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Color(0xFF455B63).withOpacity(0.10),
                                        offset: Offset(0, 4),
                                        blurRadius: 16,
                                      )
                                    ]),
                                child: toMale
                                    ? Icon(
                                        Icons.done,
                                        color: Color(0xFF78849E),
                                      )
                                    : Container(),
                              ),
                            ),
                            Sb(w: 10),
                            Text(
                              "MALE",
                              style: settingsTextStyle,
                            ),
                            Sb(w: 20),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (toFemale) {
                                    toFemale = false;
                                  } else {
                                    toFemale = true;
                                  }
                                });
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Color(0xFF455B63).withOpacity(0.10),
                                        offset: Offset(0, 4),
                                        blurRadius: 16,
                                      )
                                    ]),
                                child: toFemale
                                    ? Icon(
                                        Icons.done,
                                        color: Color(0xFF78849E),
                                      )
                                    : Container(),
                              ),
                            ),
                            Sb(w: 10),
                            Text(
                              "FEMALE",
                              style: settingsTextStyle,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  buttonWithShadow(
                      text: "Edit Schedule",
                      onTap: () {
                        Alert(
                            context: context,
                            title: "SELECT BUSY HOURS",
                            content: Container(
                              width: screenWidth * 0.90,
                              height: screenHeight * 0.65,
                              child: EditSchedule(username),
                            ),
                            buttons: []).show();
                      }),
                  SizedBox(height: 24),
                  buttonWithShadow(
                      text: locationData == null
                          ? "Set Location"
                          : locationData.latitude.toStringAsFixed(3) +
                              " , " +
                              locationData.longitude.toStringAsFixed(3),
                      onTap: () {
                        Alert(
                            context: context,
                            title: "SELECT LOCATION",
                            content: Container(
                              width: screenWidth * 0.75,
                              height: screenHeight * 0.65,
                              child: SelectLocationMap(
                                key: UniqueKey(),
                                setLocationFunc: (LatLng loc) {
                                  setState(() {
                                    locationData =
                                        GeoPoint(loc.latitude, loc.longitude);
                                  });
                                },
                              ),
                            ),
                            buttons: [
                              DialogButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  "SAVE",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              )
                            ]).show();
                      }),

                  SizedBox(height: 24),

                  customTextField(
                    hintText: description != null
                        ? description
                        : "Profile Description",
                    onChange: (value) {
                      setState(() {
                        description = value;
                      });
                    },
                    uzun: true,
                  ),

                  SizedBox(height: 24),
                  // PROFILE PHOTO
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: buttonWithShadow(
                          text: "Set Profile Photo",
                          onTap: getImage,
                        ),
                      ),
                      Sb(w: 20),
                      Column(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: currentPhotoUrl != null
                                ? Image.network(
                                    currentPhotoUrl,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  )
                                : _image != null
                                    ? Image.file(
                                        _image,
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        "images/profilePicture.jpg",
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.cover,
                                      ),
                          ),
                          Sb(h: 10),
                          Text(
                            "CURRENT PHOTO",
                            style: TextStyle(
                                color: Color(0xFF78849E),
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 36),

                  // SAVE BUTTON
                  Container(
                      width: double.infinity,
                      child: primaryButton(
                          text: "SAVE",
                          onPressed: () {
                            if (_image != null) {
                              Alert(
                                  context: context,
                                  title: "UPLOAD PROCESS",
                                  content: Uploader(_image, username),
                                  buttons: []).show();
                            }

                            Map<String, dynamic> newValues = {
                              "username": username,
                              "description": description,
                              "location": locationData,
                              "toMale": toMale,
                              "toFemale": toFemale,
                              "serviceType": serviceType,
                            };
                            try {
                              Firestore.instance
                                  .collection('provider')
                                  .document(username)
                                  .updateData(newValues)
                                  .catchError((e) {
                                print(e);
                              });

                              Alert(
                                  context: context,
                                  title: "Success",
                                  desc: "Settings have been saved.",
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
                            } catch (e) {}
                          })),

                  Sb(h: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
