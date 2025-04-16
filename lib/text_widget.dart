import 'package:flutter/material.dart';

Widget textWidget(){
  return Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding:const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color:Colors.white54),
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Text(
            "\$14,000",
            style: TextStyle(
              fontSize: 72.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  ],
);
}
