import 'package:flutter/material.dart';
import 'widgets.dart';
import '../widgets.dart';

reviewWindow(screenHeight, screenWidth, Function close) {
  TextStyle titleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Color(0xFF454F63).withOpacity(0.56),
  );

  return Center(
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 33),
      width: screenWidth - 50,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 34),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Image.asset(
              "images/profilePicture.jpg",
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 17),
          Text(
            "James Goodwin",
            style: TextStyle(
              color: Color(0xFF454F63),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "Hair Cut - Blow Dry",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF454F63).withOpacity(0.50),
            ),
          ),
          SizedBox(height: 20),
          Text("Hygiene", style: titleStyle),
          SizedBox(height: 10),
          RatingStars(),
          SizedBox(height: 26),
          Text("Talent", style: titleStyle),
          SizedBox(height: 10),
          RatingStars(),
          SizedBox(height: 26),
          Text("Timing", style: titleStyle),
          SizedBox(height: 10),
          RatingStars(),
          SizedBox(height: 26),
          Text("Kindness", style: titleStyle),
          SizedBox(height: 10),
          RatingStars(),
          SizedBox(height: 47),

          // button
          Container(
            width: double.infinity,
            child: RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 18),
                color: Color(0xFFAC2797),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(width: 0, style: BorderStyle.none)),
                child: Text(
                  "SUBMIT RATING",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  close();
                }),
          ),

          Sb(h: 31),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}
