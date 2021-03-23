import 'package:flutter/material.dart';

filtersWindow(screenHeight, screenWidth) {
  return Center(
    child: Container(
        height: screenHeight * 0.75,
        width: screenWidth - 50,
        child: Column(
          children: <Widget>[
            SizedBox(height: 36),
            Text(
              "Filters",
              style: TextStyle(
                color: Color(0xFF454F63),
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        )),
  );
}
