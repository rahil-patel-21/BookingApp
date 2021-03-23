import 'dart:convert';

import 'package:begoodyapp/Profile/profilePage.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../home/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:location/location.dart';
import '../../widgets.dart';
import 'package:http/http.dart' as http;

class SelectServiceLocationMap extends StatefulWidget {
  final Function setLocationFunc;

  SelectServiceLocationMap({@required Key key, this.setLocationFunc})
      : super(key: key);

  @override
  _SelectServiceLocationMapState createState() =>
      _SelectServiceLocationMapState();
}

class _SelectServiceLocationMapState extends State<SelectServiceLocationMap> {
  Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor bluePinIcon;
  BitmapDescriptor pinkPinIcon;
  Set<Marker> markers = {};
  bool showDetail = false;
  // wrapper around the location API
  Location location;
  LocationData currentLocation;

  String postCode;

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

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(51.505485, -0.125638),
    zoom: 14.4746,
  );

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

  requestLocWithPostCode(postcode) async {
    if (postcode != null) {
      var url = 'https://api.postcodes.io/postcodes/' + postcode;
      var response = await http.get(url);
      if (response.statusCode == 404) {
        Alert(
            context: context,
            title: "Hata",
            desc: "Posta kodu bulunamadı.",
            type: AlertType.warning,
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
      } else {
        String body = response.body;
        double latitude = json.decode(body)["result"]["latitude"];
        double longitude = json.decode(body)["result"]["longitude"];
        LatLng newLocation = LatLng(latitude, longitude);
        print(newLocation);
        setState(() {
          markers.clear();
          markers.add(Marker(
              markerId: MarkerId("1"),
              position: newLocation,
              icon: bluePinIcon));
        });
        final GoogleMapController controller = await _controller.future;

        controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            bearing: 0,
            target: newLocation,
            zoom: 17.0,
          ),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: customTextField(
                    hintText: "Type postcode",
                    backgroundColor: Colors.grey.withOpacity(0.3),
                    onChange: (value) {
                      setState(() {
                        postCode = value;
                      });
                    },
                  ),
                ),
                IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      requestLocWithPostCode(postCode);
                    })
              ],
            ),
            Expanded(
              child: GoogleMap(
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
                    markers.clear();
                    markers.add(Marker(
                        markerId: MarkerId("1"),
                        position: latLng,
                        icon: bluePinIcon));
                  });

                  widget.setLocationFunc(latLng);
                },
                onMapCreated: (GoogleMapController controller) {
                  controller.setMapStyle(Utils.mapStyles);
                  _controller.complete(controller);
                },
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: EdgeInsets.only(bottom: 20, right: 20),
            child: FloatingActionButton.extended(
              onPressed: _currentLocation,
              label: Text(''),
              icon: Icon(Icons.location_on),
            ),
          ),
        ),
      ],
    );
  }
}
