import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../widgets.dart';

TextStyle settingsTextStyle = TextStyle(
    color: Color(0xFF78849E), fontSize: 16, fontWeight: FontWeight.w600);

Widget buttonWithShadow({String text, Function onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF455B63).withOpacity(0.10),
              offset: Offset(0, 4),
              blurRadius: 16,
            )
          ]),
      child: Text(
        text,
        style: settingsTextStyle,
      ),
    ),
  );
}

Widget myServiceUi(String name, String price) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15.0),
    child: Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            // -- resim
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFF621055),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: AssetImage("images/cuttingHair.jpg"),
                      fit: BoxFit.cover)),
            ),
            SizedBox(width: 16),
            // -- başlık
            Text(
              name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2A2E43),
              ),
            ),

            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  // -- fiyat
                  Text(
                    "\$ $price",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2A2E43),
                    ),
                  ),
                  SizedBox(width: 14),
                  // -- edit butonu
                  InkWell(
                    onTap: () {},
                    child: Icon(
                      Icons.edit,
                      color: Color(0xFFAC2797),
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Container(
          height: 1,
          width: double.infinity,
          color: Color(0xFF2A2E43).withOpacity(0.10),
        )
      ],
    ),
  );
}

class CreateNewService extends StatefulWidget {
  final String username;
  final List items;
  final Map allServices;

  CreateNewService({this.username, this.items, this.allServices});

  @override
  _CreateNewServiceState createState() => _CreateNewServiceState();
}

class _CreateNewServiceState extends State<CreateNewService> {
  Map<String, String> selectedService;
  double newServicePrice;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context2, setState) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Create New Service",
              style: TextStyle(fontSize: 20),
            ),
            Sb(h: 10),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedService == null
                  ? "Select Service"
                  : selectedService['name'],
              style: settingsTextStyle,
              items: widget.items,
              onChanged: (value) {
                setState(() {
                  selectedService = {
                    "id": widget.allServices[value],
                    "name": value
                  };
                });
              },
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Price',
              ),
              onChanged: (value) {
                setState(() {
                  newServicePrice = double.parse(value);
                });
              },
            ),
            DialogButton(
              onPressed: () {
                // hizmet oluştur db
                if (selectedService != null && newServicePrice != null) {
                  try {
                    Firestore.instance
                        .collection('provider')
                        .document(widget.username)
                        .collection('services')
                        .document()
                        .setData({
                      'name': selectedService['name'],
                      'serviceId': selectedService['id'],
                      'price': newServicePrice,
                      'active': true,
                    });
                    Alert(
                        context: context,
                        title: "Success",
                        desc: "New service have been created.",
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
                              Navigator.pop(context2);
                            },
                          )
                        ]).show();
                  } catch (e) {
                    print(e);
                  }
                }
              },
              child: Text(
                "CREATE",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ],
        ),
      );
    });
  }
}
