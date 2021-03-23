import 'package:begoodyapp/Profile/profilePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../stories.dart';
import '../widgets.dart';

List<Story> getStories() {
  List<Story> stories = new List();
  for (int i = 0; i < 10; i++) {
    stories.add(
      new Story(
        "https://image.freepik.com/free-photo/hairdresser-creates-curls-wavy-hair-blonde-hands-hairdresser-curls-curls-client_121946-544.jpg",
        "Caption",
      ),
    );
  }
  return stories;
}

Widget getStory(String isim, bool seen, BuildContext context) {
  return Container(
    margin: EdgeInsets.all(5),
    child: Column(
      children: <Widget>[
        Container(
          height: 50,
          width: 50,
          child: Stack(
            alignment: Alignment(0, 0),
            children: <Widget>[
              Container(
                height: 50,
                width: 50,
                child: CircleAvatar(
                  backgroundColor: seen ? Colors.red : Colors.grey,
                ),
              ),
              Container(
                height: 47,
                width: 47,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                ),
              ),
              Container(
                height: 45,
                width: 45,
                child: CircleAvatar(
                  backgroundImage: AssetImage("images/profilePicture.jpg"),
                ),
              ),
              FlatButton(
                child: Container(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return Scaffold(
                        body: StoriesWidget(
                          "https://image.freepik.com/free-photo/hairdresser-creates-curls-wavy-hair-blonde-hands-hairdresser-curls-curls-client_121946-544.jpg",
                          "James Goodwin",
                          "2 hours ago",
                          getStories(),
                        ),
                      );
                    }),
                  );
                },
              ),
            ],
          ),
        ),
        Text(isim, style: TextStyle())
      ],
    ),
  );
}

class MaleFemaleButtons extends StatefulWidget {
  @override
  _MaleFemaleButtonsState createState() => _MaleFemaleButtonsState();
}

class _MaleFemaleButtonsState extends State<MaleFemaleButtons> {
  bool female = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        InkWell(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 250),
              padding: EdgeInsets.only(left: 20, right: 20, top: 7, bottom: 7),
              child: Row(
                children: <Widget>[
                  Text(
                    "MALE",
                    style: TextStyle(
                        color: Colors.white.withOpacity(female ? 0.60 : 1),
                        fontSize: 9,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                  color: female ? Color(0xFF353A50) : Color(0xFF009EE2),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8))),
            ),
            onTap: () {
              setState(() {
                female = false;
              });
            }),
        InkWell(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 250),
            padding: EdgeInsets.only(left: 17, right: 16, top: 7, bottom: 7),
            child: Row(
              children: <Widget>[
                Text(
                  "FEMALE",
                  style: TextStyle(
                      color: Colors.white.withOpacity(female ? 1 : 0.60),
                      fontSize: 9,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            decoration: BoxDecoration(
                color: female ? Color(0xFFE5007E) : Color(0xFF353A50),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(8),
                    topRight: Radius.circular(8))),
          ),
          onTap: () {
            setState(() {
              female = true;
            });
          },
        ),
      ],
    );
  }
}

Widget hizmetVerenCubugu(context, String id, String isim, bool freelancer) {
  return Column(
    children: <Widget>[
      InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return ProfilePage(id);
            }),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Image.asset(
                    "images/profilePicture.jpg",
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      isim,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2A2E43),
                      ),
                    ),
                    Sb(h: 5),
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        freelancer ? "FREELANCER" : "SHOP",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Color(0xFF2A2E43),
                          borderRadius: BorderRadius.circular(5)),
                    )
                  ],
                ),
              ],
            ),
            // rating
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.star,
                      size: 16,
                      color: Color(0xFFE5007E),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.star, size: 16, color: Color(0xFFE5007E)),
                    SizedBox(width: 6),
                    Icon(Icons.star, size: 16, color: Color(0xFFE5007E)),
                    SizedBox(width: 6),
                    Icon(Icons.star, size: 16, color: Color(0xFFE5007E)),
                    SizedBox(width: 6),
                    Icon(Icons.star, size: 16, color: Color(0xFF464E63)),
                    SizedBox(width: 6),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  "4.5 stars",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF2A2E43).withOpacity(0.56),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      SizedBox(height: 10),
      Container(
        height: 1,
        width: double.infinity,
        color: Color(0xFF2A2E43).withOpacity(0.05),
      ),
      SizedBox(height: 4),
    ],
  );
}

class ListingProviders extends StatelessWidget {
  BuildContext mainContext;

  ListingProviders(this.mainContext);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('provider').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return Column(
              children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                return hizmetVerenCubugu(mainContext, document.documentID,
                    document["name"], document["freelance"]);
              }).toList(),
            );
        }
      },
    );
  }
}

class Utils {
  static String mapStyles = '''[
    {
        "featureType": "administrative",
        "elementType": "all",
        "stylers": [
            {
                "visibility": "on"
            },
            {
                "lightness": 33
            }
        ]
    },
    {
        "featureType": "landscape",
        "elementType": "all",
        "stylers": [
            {
                "color": "#f7f7f7"
            }
        ]
    },
    {
        "featureType": "poi.business",
        "elementType": "all",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "poi.park",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#deecdb"
            }
        ]
    },
    {
        "featureType": "poi.park",
        "elementType": "labels",
        "stylers": [
            {
                "visibility": "on"
            },
            {
                "lightness": "25"
            }
        ]
    },
    {
        "featureType": "road",
        "elementType": "all",
        "stylers": [
            {
                "lightness": "25"
            }
        ]
    },
    {
        "featureType": "road",
        "elementType": "labels.icon",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#ffffff"
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "labels",
        "stylers": [
            {
                "saturation": "-90"
            },
            {
                "lightness": "25"
            }
        ]
    },
    {
        "featureType": "road.arterial",
        "elementType": "all",
        "stylers": [
            {
                "visibility": "on"
            }
        ]
    },
    {
        "featureType": "road.arterial",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#ffffff"
            }
        ]
    },
    {
        "featureType": "road.local",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#ffffff"
            }
        ]
    },
    {
        "featureType": "transit.line",
        "elementType": "all",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "transit.station",
        "elementType": "all",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "water",
        "elementType": "all",
        "stylers": [
            {
                "visibility": "on"
            },
            {
                "color": "#e0f1f9"
            }
        ]
    }
]''';
}
