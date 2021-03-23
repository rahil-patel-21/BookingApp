import 'package:begoodyapp/Home/map.dart';
import 'package:begoodyapp/widgets.dart';
import 'package:flutter/material.dart';
import 'package:stories/models/story.dart';
import 'package:stories/stories.dart';
import 'widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'filters.dart';
import '../firebase_functions.dart';

class HomePage extends StatefulWidget {
  final String begoodierUserName;

  HomePage({this.begoodierUserName});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool filtersOpen = false;
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  User myUser;

  getUser() async {
    myUser = await getCurrentUser();
  }

  @override
  void initState() {
    setState(() {
      getUser();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _drawerKey,
      drawer: drawer(context, widget.begoodierUserName),
      body: Stack(
        children: <Widget>[
          // Harita
          Container(
            height: screenHeight * 0.5,
            child: Container(), //  HomeMap(key: UniqueKey()),
          ),

          // Content
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.only(left: 20),
              height: screenHeight * 0.5,
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Sb(h: 12),
                  // - hikayeler
                  Container(
                    height: 85,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        getStory("Chandler", true, context),
                        getStory("Monica", true, context),
                        getStory("Rachel", true, context),
                        getStory("Joey", true, context),
                        getStory("Ross", true, context),
                        getStory("Phoebe", true, context),
                      ],
                    ),
                  ),

                  // - baş kısım
                  Padding(
                    padding: EdgeInsets.only(right: 13),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // -- başlık
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Nearby",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2A2E43),
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              "Shops and freelancers",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF2A2E43).withOpacity(0.56),
                              ),
                            ),
                          ],
                        ),
                        // -- filtre cinsiyet butonları
                        Row(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (filtersOpen) {
                                    filtersOpen = false;
                                  } else {
                                    filtersOpen = true;
                                  }
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(7),
                                child: Icon(
                                  Icons.settings,
                                  size: 13,
                                  color: Colors.white,
                                ),
                                decoration: BoxDecoration(
                                    color: Color(0xFF2A2E43),
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                            ),
                            SizedBox(width: 14),
                            MaleFemaleButtons(),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 15),
                  // - hizmet verenler

                  ListingProviders(context),

                  Sb(h: 90)
                ],
              ),
              decoration: BoxDecoration(
                color: Color(0xFFF7F7FA),
                border: Border(
                  top: BorderSide(width: 5, color: Color(0xFFB91E91)),
                ),
              ),
            ),
          ),

          bottomBar("Home", context, () {
            _drawerKey.currentState.openDrawer();
          }),

          // siyah kaplama
          filtersOpen
              ? InkWell(
                  onTap: () {
                    setState(() {
                      filtersOpen = false;
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black.withOpacity(0.72),
                  ),
                )
              : Container(),

          // Filters penceresi
          filtersOpen ? filtersWindow(screenHeight, screenWidth) : Container(),
        ],
      ),
    );
  }
}
