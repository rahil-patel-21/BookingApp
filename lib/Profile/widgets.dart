import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

Widget ratingCard({double screenWidth, String name, String rating}) {
  return Container(
    width: (screenWidth - 72) * 0.25,
    padding: EdgeInsets.symmetric(vertical: 11),
    child: Column(
      children: <Widget>[
        Text(
          name,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        Text(
          rating,
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    ),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.white, width: 1),
      borderRadius: BorderRadius.circular(8),
    ),
  );
}

Widget hizmetCubugu(
    {String name, String image, String price, Function buyAction}) {
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
                      image: AssetImage(image), fit: BoxFit.cover)),
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
                  // -- ekle butonu
                  AddToCartButton(buyAction),
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

class AddToCartButton extends StatefulWidget {
  final Function buyAction;

  AddToCartButton(this.buyAction);
  @override
  _AddToCartButtonState createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton> {
  bool bought = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (bought) {
          widget.buyAction(true);
          setState(() {
            bought = false;
          });
        } else {
          widget.buyAction(false);
          setState(() {
            bought = true;
          });
        }
      },
      child: Icon(
        bought ? Icons.add_circle : Icons.add_circle_outline,
        color: Color(0xFFAC2797),
        size: 28,
      ),
    );
  }
}

Widget haftaninGunu(
    {int doluluk,
    double ekranGenislik,
    bool bugun,
    int tarih,
    String gun,
    Function onTap}) {
  Widget maviYuvarlak(bool dolu) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF3ACCE1).withOpacity(dolu ? 1 : 0.20)),
    );
  }

  return InkWell(
    onTap: onTap,
    child: Column(
      children: <Widget>[
        Text(
          gun,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF2A2E43),
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: (ekranGenislik - 70) * 1 / 7,
          padding: EdgeInsets.only(top: 13, bottom: 11),
          child: Column(
            children: <Widget>[
              Text(
                "$tarih",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  color: bugun == false || bugun == null
                      ? Color(0xFF2A2E43)
                      : Colors.white,
                ),
              ),
              SizedBox(height: 7),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  maviYuvarlak(doluluk >= 1),
                  SizedBox(width: 2),
                  maviYuvarlak(doluluk >= 2),
                  SizedBox(width: 2),
                  maviYuvarlak(doluluk >= 3),
                  SizedBox(width: 2),
                  maviYuvarlak(doluluk >= 4),
                  SizedBox(width: 2),
                  maviYuvarlak(doluluk >= 5),
                ],
              ),
            ],
          ),
          decoration: BoxDecoration(
              color: bugun == false || bugun == null
                  ? Colors.white
                  : Color(0xFF2A2E43),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.16),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ]),
        ),
      ],
    ),
  );
}

class SaatKutusu extends StatefulWidget {
  final String saat;
  final bool dolu;
  final Function selectFunc;

  SaatKutusu({this.saat, this.selectFunc, this.dolu = false});

  @override
  _SaatKutusuState createState() => _SaatKutusuState();
}

class _SaatKutusuState extends State<SaatKutusu> {
  bool secildi = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (secildi) {
          setState(() {
            secildi = false;
          });
          widget.selectFunc(widget.saat, true);
        } else {
          if (!widget.dolu) {
            setState(() {
              secildi = true;
            });
            widget.selectFunc(widget.saat, false);
          } else {
            Alert(
                context: context,
                title: "Uyarı",
                desc: "Maalesef bu saat dolu.",
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
          }
        }
      },
      child: Container(
        margin: EdgeInsets.only(right: 12),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Text(
          widget.saat,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            color: widget.dolu == false || widget.dolu == null
                ? secildi ? Colors.white : Color(0xFF2A2E43)
                : Colors.white,
          ),
        ),
        decoration: BoxDecoration(
            color: widget.dolu == false || widget.dolu == null
                ? secildi ? Color(0xFFAC2797) : Colors.black.withOpacity(0.15)
                : Color(0xFF3ACCE1),
            borderRadius: BorderRadius.circular(5)),
      ),
    );
  }
}
