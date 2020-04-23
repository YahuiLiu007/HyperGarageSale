import 'package:flutter/material.dart';


class MyTextStyle {
  static TextStyle priceStyle() {
    return new TextStyle(
      color: Colors.black,
      fontSize: 30,
      fontWeight: FontWeight.w600,
      //fontWeight: FontWeight.bold,
    );
  }

  static TextStyle titleStyle(){
    return new TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle descriptionStyle(){
    return  new TextStyle(
      color: Colors.black,
      fontSize: 15,
      fontWeight: FontWeight.w400,
    );
  }

  TextStyle get(String s) {
    TextStyle temp;
    switch(s) {
      case 'title' :
        temp = titleStyle();
        break;
      case 'price' :
        temp = priceStyle();
        break;
      case 'decription' :
        temp = descriptionStyle();
        break;
    }
    return temp;
  }
}