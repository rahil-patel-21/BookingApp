import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets.dart';
import 'widgets.dart';

class MyServices extends StatefulWidget {
  final String username;

  MyServices(this.username);

  @override
  _MyServicesState createState() => _MyServicesState();
}

class _MyServicesState extends State<MyServices> {
  String username;
  List<Widget> services = [];
  List<DropdownMenuItem<String>> items = [
    DropdownMenuItem(child: Text("Select Service"), value: "Select Service"),
  ];
  Map<String, String> allServices = {};

  @override
  void initState() {
    username = widget.username;

    listingServices(context, username);

    gettingAllServices();

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
        return myServiceUi(document["name"], document['price'].toString());
      }).toList();
    });
  }

  gettingAllServices() async {
    QuerySnapshot snapshot =
        await Firestore.instance.collection("services").getDocuments();

    List<DocumentSnapshot> liste = snapshot.documents;
    allServices = {};
    liste.forEach((doc) {
      setState(() {
        items.add(DropdownMenuItem(
          value: doc.data["name"],
          child: Text(doc.data["name"]),
        ));

        allServices.addAll({doc.data["name"]: doc.documentID});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 23),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Sb(h: 70),
            Text(
              "My Services",
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
                  Container(),
                  InkWell(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 19, vertical: 9),
                      child: Text(
                        "CREATE NEW ONE",
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
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return CreateNewService(
                              username: username,
                              allServices: allServices,
                              items: items,
                            );
                          });
                    },
                  ),
                ],
              ),
            ),
            Sb(h: 18),
            Padding(
              padding: const EdgeInsets.only(right: 23.0),
              child: Column(
                children: services,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
