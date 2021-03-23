import 'package:begoodyapp/Profile/profilePage.dart';
import 'package:flutter/material.dart';
import 'widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:location/location.dart';

class HomeMap extends StatefulWidget {
  HomeMap({@required Key key}) : super(key: key);

  @override
  _HomeMapState createState() => _HomeMapState();
}

class _HomeMapState extends State<HomeMap> {
  Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor bluePinIcon;
  BitmapDescriptor pinkPinIcon;
  Set<Marker> markers = {};
  bool showDetail = false;
  // wrapper around the location API
  Location location;

  LocationData currentLocation;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(51.505485, -0.125638),
    zoom: 14.4746,
  );

  void _currentLocation() async {
    final GoogleMapController controller = await _controller.future;
    LocationData currentLocation;
    var location = new Location();
    try {
      currentLocation = await location.getLocation();
    } on Exception {
      currentLocation = null;
    }

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 17.0,
      ),
    ));
  }

  @override
  void initState() {
    // create an instance of Location
    location = new Location();

    // subscribe to changes in the user's location
    // by "listening" to the location's onLocationChanged event
    location.onLocationChanged().listen((LocationData cLoc) {
      // cLoc contains the lat and long of the
      // current user's position in real time,
      // so we're holding on to it
      currentLocation = cLoc;
    });
    // set the initial location
    setInitialLocation();

    super.initState();
    setCustomMapPin();
  }

  void setInitialLocation() async {
    // set the initial location by pulling the user's
    // current location from the location's getLocation()
    currentLocation = await location.getLocation();
  }

  void setCustomMapPin() async {
    /*pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'images/icons/pin.png');
        */

    bluePinIcon = BitmapDescriptor.defaultMarkerWithHue(210);
    pinkPinIcon = BitmapDescriptor.defaultMarkerWithHue(310);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          mapToolbarEnabled: true,
          markers: markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomGesturesEnabled: true,
          padding: EdgeInsets.only(top: 0),
          mapType: MapType.normal,
          tiltGesturesEnabled: true,
          initialCameraPosition: _kGooglePlex,
          onTap: (LatLng latLng) {
            setState(() {
              showDetail = false;
            });
          },
          onMapCreated: (GoogleMapController controller) {
            controller.setMapStyle(Utils.mapStyles);
            _controller.complete(controller);

            setState(() {
              markers.add(Marker(
                markerId: MarkerId("1"),
                position: LatLng(51.508992, -0.120527),
                onTap: () {
                  setState(() {
                    showDetail = true;
                  });
                },
                icon: bluePinIcon
              ));

              markers.add(Marker(
                markerId: MarkerId("2"),
                position: LatLng(51.515463, -0.143268),
                onTap: () {
                  setState(() {
                    showDetail = true;
                  });
                },
                icon: pinkPinIcon,
              ));
              markers.add(Marker(
                markerId: MarkerId("3"),
                position: LatLng(51.503360, -0.138158),
                onTap: () {
                  setState(() {
                    showDetail = true;
                  });
                },
                icon: bluePinIcon
              ));
              markers.add(Marker(
                markerId: MarkerId("4"),
                position: LatLng(51.499262, -0.113830),
                onTap: () {
                  setState(() {
                    showDetail = true;
                  });
                },
                icon: pinkPinIcon,
              ));
            });
          },
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: EdgeInsets.only(bottom: 20, right: 20),
            child: FloatingActionButton.extended(
              onPressed: _currentLocation,
              label: Text('My Location'),
              icon: Icon(Icons.location_on),
            ),
          ),
        ),
        AnimatedPositioned(
          bottom: showDetail ? 5 : -100,
          right: 0,
          left: 0,
          duration: Duration(milliseconds: 400),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return ProfilePage("");
                  }),
                );
              },
              child: Container(
                margin: EdgeInsets.all(20),
                height: 70,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          blurRadius: 20,
                          offset: Offset.zero,
                          color: Colors.grey.withOpacity(0.5))
                    ]),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 50,
                      height: 50,
                      margin: EdgeInsets.only(left: 10),
                      child: ClipOval(
                          child: Image.asset("images/profilePicture.jpg",
                              fit: BoxFit.cover)),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("James Goodwin",
                                style: TextStyle(color: Colors.blue)),
                            Text('With 10 years of experience and successes...',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Image.asset("images/icons/pin.png"),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
