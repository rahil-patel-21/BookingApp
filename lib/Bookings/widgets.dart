import 'package:flutter/material.dart';

class RatingStars extends StatefulWidget {
  @override
  _RatingStarsState createState() => _RatingStarsState();
}

class _RatingStarsState extends State<RatingStars> {
  int star = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        InkWell(
          onTap: () {
            setState(() {
              star = 1;
            });
          },
                  child: Icon(Icons.star,
              size: 24, color: star > 0 ? Color(0xFFAC2797) : Color(0xFF464E63)),
        ),
        SizedBox(width: 6),
   InkWell(
          onTap: () {
            setState(() {
              star = 2;
            });
          },
                  child: Icon(Icons.star,
              size: 24, color: star > 1 ? Color(0xFFAC2797) : Color(0xFF464E63)),
        ),
        SizedBox(width: 6),
   InkWell(
          onTap: () {
            setState(() {
              star = 3;
            });
          },
                  child: Icon(Icons.star,
              size: 24, color: star > 2 ? Color(0xFFAC2797) : Color(0xFF464E63)),
        ),
        SizedBox(width: 6),
   InkWell(
          onTap: () {
            setState(() {
              star = 4;
            });
          },
                  child: Icon(Icons.star,
              size: 24, color: star > 3 ? Color(0xFFAC2797) : Color(0xFF464E63)),
        ),
        SizedBox(width: 6),
   InkWell(
          onTap: () {
            setState(() {
              star = 5;
            });
          },
                  child: Icon(Icons.star,
              size: 24, color: star > 4 ? Color(0xFFAC2797) : Color(0xFF464E63)),
        ),
      ],
    );
  }
}
