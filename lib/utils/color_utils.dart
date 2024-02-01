import 'package:flutter/material.dart';

//correct method:
Color hexStringToActualColor(String hex) {
  hex = hex.replaceAll("#", "");
  if (hex.length == 6) {
    hex = "FF" + hex; // Add FF for full opacity if not provided
  }
  int val = int.parse(hex, radix: 16);
  return Color(val);
}

//contains a logic error, but I liked the color so I kept it
hexStringToColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor += "FF";
  }
  return Color(int.parse(hexColor, radix: 16));
}
