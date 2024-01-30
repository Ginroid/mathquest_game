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
