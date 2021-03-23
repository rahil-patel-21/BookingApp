import 'package:begoodyapp/Bookings/myBookingsPage.dart';
import 'package:begoodyapp/Home/homePage.dart';
import 'package:flutter/material.dart';
import 'Begoodier/settings.dart';

customTextField(
    {String hintText,
    Function onChange,
    bool parola = false,
    bool uzun = false,
    Color backgroundColor = Colors.white,
    TextInputType inputType = TextInputType.text}) {
  return Material(
    elevation: 7,
    borderRadius: BorderRadius.circular(10),
    shadowColor: Color(0xFF455B63).withOpacity(0.10),
    child: TextField(
      minLines: uzun ? 5 : 1,
      maxLines: uzun ? 5 : 1,
      onChanged: (value) {
        onChange(value);
      },
      autofocus: false,
      obscureText: parola ? true : false,
      keyboardType: inputType,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(width: 0, style: BorderStyle.none)),
          hintText: hintText,
          fillColor: backgroundColor,
          filled: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          hintStyle: TextStyle(
              color: Color(0xFF78849E),
              fontSize: 16,
              fontWeight: FontWeight.w600)),
    ),
  );
}

Widget primaryButton({String text, Function onPressed}) {
  return RaisedButton(
      padding: EdgeInsets.symmetric(vertical: 18),
      color: Color(0xFFAC2797),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(width: 0, style: BorderStyle.none)),
      child: Text(
        text,
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
      ),
      onPressed: onPressed);
}

BoxDecoration neuMorphicDecor = BoxDecoration(
    color: Color(0xFFF7F7FA),
    boxShadow: [
      BoxShadow(
        color: Colors.white,
        offset: Offset(-5, -2),
        blurRadius: 10,
      ),
      BoxShadow(
        color: Color(0xFFE1E1E1),
        offset: Offset(2, 5),
        blurRadius: 10,
      ),
    ],
    borderRadius: BorderRadius.circular(15));

BoxDecoration customCardDecoration() {
  return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Color(0xFF455B63).withOpacity(0.08),
          offset: Offset(0, 4),
          blurRadius: 16,
        )
      ]);
}

class ColoredTabBar extends Container implements PreferredSizeWidget {
  ColoredTabBar(this.color, this.tabBar);

  final Color color;
  final TabBar tabBar;

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) => Container(
        color: color,
        child: tabBar,
      );
}

Widget bottomBar(String page, context, Function openDrawer) {
  return

      // BOTTOM BAR
      Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      padding: EdgeInsets.only(top: 8, bottom: 3),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) {
                  return HomePage();
                }),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.home,
                  color: Colors.white.withOpacity(page == "Home" ? 1 : 0.60),
                ),
                Text(
                  "Home",
                  style: TextStyle(
                    color: Colors.white.withOpacity(page == "Home" ? 1 : 0.60),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return MyBookingsPage();
                }),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.timer,
                  color:
                      Colors.white.withOpacity(page == "Bookings" ? 1 : 0.60),
                ),
                Text(
                  "Bookings",
                  style: TextStyle(
                    color:
                        Colors.white.withOpacity(page == "Bookings" ? 1 : 0.60),
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.notifications,
                color: Colors.white
                    .withOpacity(page == "Notifications" ? 1 : 0.60),
              ),
              Text(
                "Notifications",
                style: TextStyle(
                  color: Colors.white
                      .withOpacity(page == "Notifications" ? 1 : 0.60),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: openDrawer,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.menu,
                  color: Colors.white.withOpacity(page == "Others" ? 1 : 0.60),
                ),
                Text(
                  "Others",
                  style: TextStyle(
                    color:
                        Colors.white.withOpacity(page == "Others" ? 1 : 0.60),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
          color: Color(0xFFAC2797),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          )),
    ),
  );
}

class Sb extends StatelessWidget {
  final double h;
  final double w;
  Sb({this.h = 0, this.w = 0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: h,
      width: w,
    );
  }
}

Widget drawer(context, [String begoodierUserName]) {
  menuEleman(String text, IconData icon, bool aktif, [Widget nereye]) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return nereye;
          }),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
        margin: EdgeInsets.only(right: 40),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              icon,
              size: 20,
              color: Colors.white,
            ),
            Sb(w: 16),
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
            color: aktif ? Color(0xFFAC2797) : Colors.transparent,
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  return Drawer(
    child: Container(
      padding: EdgeInsets.only(left: 12, top: 34),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Sb(h: 24),
          Center(child: Image.asset("images/logobeyaz.png", width: 200)),
          Sb(h: 32),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Image.asset(
                    "images/profilePicture.jpg",
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  ),
                ),
                Sb(h: 18),
                Text(
                  "James Goodwin",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Sb(h: 32),
          menuEleman("Home", Icons.home, true),
          Sb(h: 24),
          menuEleman("Bookings", Icons.calendar_today, false),
          Sb(h: 24),
          menuEleman("My Profile", Icons.person_outline, false),
          Sb(h: 24),
          begoodierUserName != null
              ? menuEleman(
                  "Begoodier Settings",
                  Icons.person_outline,
                  false,
                  BegoodierSettings(begoodierUserName),
                )
              : Container(),
          Sb(h: begoodierUserName != null ? 24 : 0),
          menuEleman("Contact Us", Icons.chat_bubble_outline, false),
          Sb(h: 24),
          menuEleman("About Us", Icons.info_outline, false),
        ],
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF009EE2), Color(0xFFE5007E)]),
      ),
    ),
  );
}
